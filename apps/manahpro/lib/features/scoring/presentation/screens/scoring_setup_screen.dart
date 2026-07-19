import 'dart:developer';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/manah_navigation_button.dart';
import '../../../../theme/manah_tokens.dart';
import '../../../monetization/presentation/monetization_providers.dart';
import '../../domain/round_preset.dart';
import '../../domain/scoring_entities.dart';
import '../../domain/scoring_enums.dart';
import '../equipment_notifier.dart';
import '../scoring_providers.dart';
import '../scoring_routes.dart';
import '../widgets/scoring_setup_components.dart';

export '../widgets/scoring_setup_components.dart' show TargetFacePreview;

/// Creates a personal scoring session while preserving the offline-first
/// repository contract.
class ScoringSetupScreen extends ConsumerStatefulWidget {
  const ScoringSetupScreen({super.key});

  @override
  ConsumerState<ScoringSetupScreen> createState() => _ScoringSetupScreenState();
}

class _ScoringSetupScreenState extends ConsumerState<ScoringSetupScreen> {
  BowCategory _bowCategory = BowCategory.modern;
  BowClass _bowClass = BowClass.recurve;
  DistanceCategory _distance = DistanceCategory.d50m;
  ArcheryEnvironment _environment = ArcheryEnvironment.outdoor;
  TargetFaceEntity? _selectedTargetFace;
  RoundPreset? _selectedPreset;
  int _numEnds = 6;
  int _arrowsPerEnd = 6;
  int _sighterEndCount = 0;
  String? _equipmentProfileId;
  bool _starting = false;
  String? _startError;

  String? _lastSelectedTargetFaceId;
  bool _hasLoadedLastSelected = false;
  bool _initialTargetFaceApplied = false;

  int get _effectiveDistanceM => _selectedPreset?.distanceM ?? _distance.meters;

  @override
  void initState() {
    super.initState();
    _loadLastSelections();
  }

  Future<void> _loadLastSelections() async {
    try {
      final storage = SharedPreferencesStorage();
      await storage.init();

      final lastTargetId = await storage.read('last_selected_target_face_id');
      final lastBowCategory = await storage.read('last_selected_bow_category');
      final lastBowClass = await storage.read('last_selected_bow_class');
      final lastDistance = await storage.read('last_selected_distance');
      final lastEnvironment = await storage.read('last_selected_environment');

      if (!mounted) return;
      setState(() {
        _lastSelectedTargetFaceId = lastTargetId;
        _bowCategory = BowCategory.values.firstWhere(
          (value) => value.value == lastBowCategory,
          orElse: () => _bowCategory,
        );
        _bowClass = BowClass.values.firstWhere(
          (value) => value.value == lastBowClass,
          orElse: () => _bowClass,
        );
        _distance = DistanceCategory.values.firstWhere(
          (value) => value.value == lastDistance,
          orElse: () => _distance,
        );
        _environment = ArcheryEnvironment.values.firstWhere(
          (value) => value.value == lastEnvironment,
          orElse: () => _environment,
        );
        _hasLoadedLastSelected = true;
      });
    } on Exception catch (error, stackTrace) {
      log(
        'Failed to restore scoring setup selections',
        error: error,
        stackTrace: stackTrace,
      );
      if (!mounted) return;
      setState(() => _hasLoadedLastSelected = true);
    }
  }

  Future<void> _persistSelection(String key, String value) async {
    try {
      final storage = SharedPreferencesStorage();
      await storage.init();
      await storage.write(key, value);
    } on Exception catch (error, stackTrace) {
      log(
        'Failed to persist scoring setup selection: $key',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _updateTarget(TargetFaceEntity target) async {
    setState(() {
      _selectedPreset = null;
      _selectedTargetFace = target;
      _startError = null;
    });
    await _persistSelection('last_selected_target_face_id', target.id);
  }

  void _applyPreset(
    RoundPreset preset,
    List<TargetFaceEntity> targetFaces,
  ) {
    setState(() {
      _selectedPreset = preset;
      _numEnds = preset.numEnds;
      _arrowsPerEnd = preset.arrowsPerEnd;
      _distance = preset.distanceCategory;
      _environment = preset.environment;
      _sighterEndCount =
          preset.sighterEndCount.clamp(0, preset.numEnds - 1).toInt();
      _selectedTargetFace = _targetFaceForPreset(preset, targetFaces);
      _startError = null;
    });
  }

  TargetFaceEntity? _targetFaceForPreset(
    RoundPreset preset,
    List<TargetFaceEntity> targetFaces,
  ) {
    if (preset.key.contains('jemparingan')) {
      final matches = targetFaces.where(
        (target) => target.code == 'jemparingan',
      );
      if (matches.isNotEmpty) return matches.first;
    }

    final targetFaceCm = preset.targetFaceCm;
    if (targetFaceCm == null) return null;
    final matches = targetFaces.where(
      (target) => target.code == 'fita_$targetFaceCm',
    );
    return matches.isEmpty ? null : matches.first;
  }

  Future<void> _updateBowCategory(BowCategory category) async {
    final bowClass = BowClass.ofCategory(category).first;
    setState(() {
      _bowCategory = category;
      _bowClass = bowClass;
      _selectedPreset = null;
      _startError = null;
    });
    await Future.wait([
      _persistSelection('last_selected_bow_category', category.value),
      _persistSelection('last_selected_bow_class', bowClass.value),
    ]);
  }

  Future<void> _updateBowClass(BowClass bowClass) async {
    setState(() {
      _bowClass = bowClass;
      _selectedPreset = null;
      _startError = null;
    });
    await _persistSelection('last_selected_bow_class', bowClass.value);
  }

  Future<void> _updateDistance(DistanceCategory distance) async {
    setState(() {
      _selectedPreset = null;
      _distance = distance;
      _startError = null;
    });
    await _persistSelection('last_selected_distance', distance.value);
  }

  Future<void> _updateEnvironment(ArcheryEnvironment environment) async {
    setState(() {
      _selectedPreset = null;
      _environment = environment;
      _startError = null;
    });
    await _persistSelection('last_selected_environment', environment.value);
  }

  Future<void> _openPresetPicker() async {
    final preset = await showModalBottomSheet<RoundPreset>(
      context: context,
      isScrollControlled: true,
      builder: (_) => RoundPresetSheet(selected: _selectedPreset),
    );
    if (!mounted || preset == null) return;
    final currentTargets = ref.read(targetFacesListProvider).value ?? const [];
    _applyPreset(preset, currentTargets);
  }

  Future<void> _openTargetPicker() async {
    final result = await context.push<TargetFaceEntity>(
      ScoringRoutes.targetFaceSelection,
      extra: _selectedTargetFace,
    );
    if (!mounted || result == null) return;
    await _updateTarget(result);
  }

  Future<void> _retryTargetFaces() async {
    ref.invalidate(targetFacesListProvider);
  }

  Future<void> _start() async {
    final targetFace = _selectedTargetFace;
    if (targetFace == null) return;

    setState(() {
      _starting = true;
      _startError = null;
    });

    try {
      final maxScore = targetFace.scoringRules.isEmpty
          ? 10
          : targetFace.scoringRules.fold<int>(
              0,
              (current, rule) => rule.value > current ? rule.value : current,
            );
      int? targetFaceCm;
      if (targetFace.code.startsWith('fita_')) {
        targetFaceCm = int.tryParse(
          targetFace.code.replaceFirst('fita_', ''),
        );
      }
      targetFaceCm ??= _selectedPreset?.targetFaceCm;
      final countedEndCount =
          (_numEnds - _sighterEndCount).clamp(0, _numEnds).toInt();

      final session = await ref.read(scoringRepositoryProvider).startSession(
            bowClass: _bowClass,
            distanceCategory: _distance,
            distanceM: _effectiveDistanceM,
            numEnds: _numEnds,
            arrowsPerEnd: _arrowsPerEnd,
            environment: _environment,
            targetFaceCm: targetFaceCm,
            targetFaceId: targetFace.id,
            maxPossibleScoreOverride:
                countedEndCount * _arrowsPerEnd * maxScore,
            equipmentProfileId: _equipmentProfileId,
            title: _selectedPreset?.label,
            sighterEndCount: _sighterEndCount,
          );
      if (!mounted) return;
      context.push(ScoringRoutes.input(session.id));
    } catch (error, stackTrace) {
      log(
        'Failed to start personal scoring session',
        error: error,
        stackTrace: stackTrace,
      );
      if (!mounted) return;
      setState(() {
        _startError = 'Sesi belum berhasil dibuat. Coba lagi.';
      });
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final targetFacesAsync = ref.watch(targetFacesListProvider);
    final targetFaces = targetFacesAsync.value ?? const [];
    final equipmentProfiles =
        ref.watch(equipmentListProvider).value ?? const [];
    final subscription = ref.watch(userSubscriptionProvider).value;
    final isGated = subscription?.isGated ?? false;

    final activePreset = _selectedPreset;
    if (activePreset != null && targetFaces.isNotEmpty) {
      final compatibleTarget = _targetFaceForPreset(
        activePreset,
        targetFaces,
      );
      if (compatibleTarget != _selectedTargetFace) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || _selectedPreset != activePreset) return;
          if (_selectedTargetFace == compatibleTarget) return;
          setState(() => _selectedTargetFace = compatibleTarget);
        });
      }
    } else if (!_initialTargetFaceApplied &&
        targetFaces.isNotEmpty &&
        _hasLoadedLastSelected) {
      _initialTargetFaceApplied = true;
      final matchingTargets = targetFaces.where(
        (target) => target.id == _lastSelectedTargetFaceId,
      );
      if (matchingTargets.isNotEmpty) {
        final target = matchingTargets.first;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted ||
              _selectedTargetFace != null ||
              _selectedPreset != null) {
            return;
          }
          setState(() => _selectedTargetFace = target);
        });
      }
    }

    final countedEndCount =
        (_numEnds - _sighterEndCount).clamp(0, _numEnds).toInt();
    final countedArrows = countedEndCount * _arrowsPerEnd;
    final sighterArrows = _sighterEndCount * _arrowsPerEnd;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 64,
        leading: const ManahNavigationButton.back(),
        title: const Text('Sesi baru'),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            ManahSpacing.base,
            ManahSpacing.sm,
            ManahSpacing.base,
            ManahSpacing.lg,
          ),
          children: [
            const ScoringSetupHeader(),
            const SizedBox(height: ManahSpacing.lg),
            ScoringSetupSection(
              icon: Icons.sports_rounded,
              title: 'Busur',
              description: 'Pilih kategori dan kelas busur yang dipakai.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BowCategorySelector(
                    selected: _bowCategory,
                    onChanged: _updateBowCategory,
                  ),
                  const SizedBox(height: ManahSpacing.base),
                  BowClassSelector(
                    values: BowClass.ofCategory(_bowCategory),
                    selected: _bowClass,
                    onChanged: _updateBowClass,
                  ),
                  EquipmentPicker(
                    profiles: equipmentProfiles,
                    selectedId: _equipmentProfileId,
                    onChanged: (value) {
                      setState(() {
                        _equipmentProfileId = value;
                        _startError = null;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: ManahSpacing.base),
            ScoringSetupSection(
              icon: Icons.tune_rounded,
              title: 'Format latihan',
              description: 'Gunakan preset atau susun formatmu sendiri.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RoundPresetField(
                    selected: _selectedPreset,
                    onTap: _openPresetPicker,
                    onClear: () => setState(() {
                      _selectedPreset = null;
                      _startError = null;
                    }),
                  ),
                  const SizedBox(height: ManahSpacing.base),
                  DistanceSelector(
                    selected: _distance,
                    effectiveMeters: _effectiveDistanceM,
                    onChanged: _updateDistance,
                  ),
                  const SizedBox(height: ManahSpacing.base),
                  EnvironmentSelector(
                    selected: _environment,
                    onChanged: _updateEnvironment,
                  ),
                  const SizedBox(height: ManahSpacing.lg),
                  ScoringCounterRow(
                    label: 'Jumlah rambahan',
                    helper: 'Total rambahan termasuk percobaan',
                    value: _numEnds,
                    min: 1,
                    max: 30,
                    onChanged: (value) => setState(() {
                      _selectedPreset = null;
                      _numEnds = value;
                      if (_sighterEndCount >= _numEnds) {
                        _sighterEndCount =
                            (_numEnds - 1).clamp(0, _numEnds).toInt();
                      }
                      _startError = null;
                    }),
                  ),
                  const SizedBox(height: ManahSpacing.base),
                  ScoringCounterRow(
                    label: 'Panah per rambahan',
                    helper: 'Jumlah panah sebelum mengambil kembali',
                    value: _arrowsPerEnd,
                    min: 1,
                    max: 12,
                    onChanged: (value) => setState(() {
                      _selectedPreset = null;
                      _arrowsPerEnd = value;
                      _startError = null;
                    }),
                  ),
                  const SizedBox(height: ManahSpacing.base),
                  ScoringCounterRow(
                    label: 'Rambahan percobaan',
                    helper: 'Tidak masuk ke skor dan personal best',
                    value: _sighterEndCount,
                    min: 0,
                    max: (_numEnds - 1).clamp(0, _numEnds).toInt(),
                    onChanged: (value) => setState(() {
                      _selectedPreset = null;
                      _sighterEndCount = value;
                      _startError = null;
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: ManahSpacing.base),
            ScoringSetupSection(
              icon: Icons.adjust_rounded,
              title: 'Target',
              description: 'Aturan nilai mengikuti target yang dipilih.',
              child: TargetFaceSelector(
                targets: targetFacesAsync,
                selected: _selectedTargetFace,
                onTap: _openTargetPicker,
                onRetry: _retryTargetFaces,
              ),
            ),
            if (subscription != null && !subscription.isPremium) ...[
              const SizedBox(height: ManahSpacing.base),
              SubscriptionUsageNotice(
                used: subscription.scoringSessionsThisWeek,
                limit: subscription.scoringSessionsLimit,
                isGated: subscription.isGated,
                onUpgrade: () => context.push('/monetization/paywall'),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: SessionActionBar(
        bowClass: _bowClass,
        distanceM: _effectiveDistanceM,
        environment: _environment,
        countedArrows: countedArrows,
        sighterArrows: sighterArrows,
        canStart: _selectedTargetFace != null,
        isStarting: _starting,
        isGated: isGated,
        errorMessage: _startError,
        onPressed: isGated
            ? () => context.push('/monetization/paywall')
            : (_selectedTargetFace == null ? null : _start),
      ),
    );
  }
}
