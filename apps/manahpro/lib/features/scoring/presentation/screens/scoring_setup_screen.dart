import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../../monetization/presentation/monetization_providers.dart';
import '../../domain/scoring_entities.dart';
import '../../domain/scoring_enums.dart';
import '../equipment_notifier.dart';
import '../scoring_providers.dart';
import '../scoring_routes.dart';

/// Scoring setup — choose distance, bow type, target face and round format,
/// then start a session. ui-ux-design-guide.md §6.1/§6.2.
class ScoringSetupScreen extends ConsumerStatefulWidget {
  const ScoringSetupScreen({super.key});

  @override
  ConsumerState<ScoringSetupScreen> createState() => _ScoringSetupScreenState();
}

class _ScoringSetupScreenState extends ConsumerState<ScoringSetupScreen> {
  BowCategory? _bowCategory = BowCategory.modern;
  BowClass? _bowClass = BowClass.recurve;
  DistanceCategory? _distance = DistanceCategory.d50m;
  ArcheryEnvironment? _environment = ArcheryEnvironment.outdoor;
  TargetFaceEntity? _selectedTargetFace;
  int _numEnds = 6;
  int _arrowsPerEnd = 6;
  String? _equipmentProfileId;
  bool _starting = false;

  String? _lastSelectedTargetFaceId;
  bool _hasLoadedLastSelected = false;
  bool _initialTargetFaceApplied = false;

  @override
  void initState() {
    super.initState();
    _loadLastSelectedId();
  }

  Future<void> _loadLastSelectedId() async {
    try {
      final storage = SharedPreferencesStorage();
      await storage.init();
      
      final lastId = await storage.read('last_selected_target_face_id');
      final lastBowCat = await storage.read('last_selected_bow_category');
      final lastBowClass = await storage.read('last_selected_bow_class');
      final lastDist = await storage.read('last_selected_distance');
      final lastEnv = await storage.read('last_selected_environment');

      if (mounted) {
        setState(() {
          _lastSelectedTargetFaceId = lastId;
          
          if (lastBowCat != null) {
            _bowCategory = BowCategory.values.firstWhere((e) => e.value == lastBowCat, orElse: () => BowCategory.modern);
          }
          if (lastBowClass != null) {
            _bowClass = BowClass.values.firstWhere((e) => e.value == lastBowClass, orElse: () => BowClass.recurve);
          }
          if (lastDist != null) {
            _distance = DistanceCategory.values.firstWhere((e) => e.value == lastDist, orElse: () => DistanceCategory.d70m);
          }
          if (lastEnv != null) {
            _environment = ArcheryEnvironment.values.firstWhere((e) => e.value == lastEnv, orElse: () => ArcheryEnvironment.outdoor);
          }

          _hasLoadedLastSelected = true;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _hasLoadedLastSelected = true;
        });
      }
    }
  }

  Future<void> _updateSelectedTargetFace(TargetFaceEntity target) async {
    setState(() => _selectedTargetFace = target);
    try {
      final storage = SharedPreferencesStorage();
      await storage.init();
      await storage.write('last_selected_target_face_id', target.id);
    } catch (_) {}
  }

  Future<void> _updateBowCategory(BowCategory cat) async {
    setState(() {
      _bowCategory = cat;
      _bowClass = BowClass.ofCategory(cat).first;
    });
    try {
      final storage = SharedPreferencesStorage();
      await storage.init();
      await storage.write('last_selected_bow_category', cat.value);
      await storage.write('last_selected_bow_class', _bowClass!.value);
    } catch (_) {}
  }

  Future<void> _updateBowClass(BowClass val) async {
    setState(() => _bowClass = val);
    try {
      final storage = SharedPreferencesStorage();
      await storage.init();
      await storage.write('last_selected_bow_class', val.value);
    } catch (_) {}
  }

  Future<void> _updateDistance(DistanceCategory val) async {
    setState(() => _distance = val);
    try {
      final storage = SharedPreferencesStorage();
      await storage.init();
      await storage.write('last_selected_distance', val.value);
    } catch (_) {}
  }

  Future<void> _updateEnvironment(ArcheryEnvironment val) async {
    setState(() => _environment = val);
    try {
      final storage = SharedPreferencesStorage();
      await storage.init();
      await storage.write('last_selected_environment', val.value);
    } catch (_) {}
  }

  Future<void> _start() async {
    if (_bowClass == null || _distance == null || _environment == null) return;
    setState(() => _starting = true);
    try {
      final targetFace = _selectedTargetFace;
      final maxScore = targetFace != null
          ? targetFace.scoringRules.map((r) => r.value).reduce((a, b) => a > b ? a : b)
          : 10;

      int? targetFaceCm;
      if (targetFace != null && targetFace.code.startsWith('fita_')) {
        targetFaceCm = int.tryParse(targetFace.code.replaceAll('fita_', ''));
      }

      final session = await ref.read(scoringRepositoryProvider).startSession(
            bowClass: _bowClass!,
            distanceCategory: _distance!,
            distanceM: _distance!.meters,
            numEnds: _numEnds,
            arrowsPerEnd: _arrowsPerEnd,
            environment: _environment!,
            targetFaceCm: targetFaceCm,
            targetFaceId: targetFace?.id,
            maxPossibleScoreOverride: _numEnds * _arrowsPerEnd * maxScore,
            equipmentProfileId: _equipmentProfileId,
          );
      if (!mounted) return;
      context.push(ScoringRoutes.input(session.id));
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  /// Optional equipment picker — only shown when the user has profiles (online).
  Widget _buildEquipmentPicker() {
    final async = ref.watch(equipmentListProvider);
    final profiles = async.value ?? const [];
    if (profiles.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel('Equipment (opsional)'),
        DropdownButtonFormField<String?>(
          initialValue: _equipmentProfileId,
          items: [
            const DropdownMenuItem<String?>(value: null, child: Text('Tanpa equipment')),
            for (final p in profiles)
              DropdownMenuItem<String?>(value: p.id, child: Text(p.name)),
          ],
          onChanged: (v) => setState(() => _equipmentProfileId = v),
        ),
        const SizedBox(height: ManahSpacing.lg),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final targetFacesAsync = ref.watch(targetFacesListProvider);
    final targetFaces = targetFacesAsync.value ?? const [];
    final subStatusAsync = ref.watch(userSubscriptionProvider);
    final subStatus = subStatusAsync.value;
    final isGated = subStatus?.isGated ?? false;

    if (!_initialTargetFaceApplied && targetFaces.isNotEmpty && _hasLoadedLastSelected) {
      _initialTargetFaceApplied = true;
      if (_lastSelectedTargetFaceId != null) {
        final found = targetFaces.where((t) => t.id == _lastSelectedTargetFaceId);
        if (found.isNotEmpty) {
          final matched = found.first;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _selectedTargetFace == null) {
              setState(() {
                _selectedTargetFace = matched;
              });
            }
          });
        }
      }
    }

    final maxScore = _selectedTargetFace != null
        ? _selectedTargetFace!.scoringRules.map((r) => r.value).reduce((a, b) => a > b ? a : b)
        : 10;

    return Scaffold(
      appBar: AppBar(title: const Text('Mulai Scoring')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(ManahSpacing.base),
          children: [
            _SectionLabel('Kategori Busur'),
            SegmentedButton<BowCategory>(
              segments: const [
                ButtonSegment(value: BowCategory.traditional, label: Text('Tradisional')),
                ButtonSegment(value: BowCategory.modern, label: Text('Modern')),
              ],
              selected: _bowCategory != null ? {_bowCategory!} : const <BowCategory>{},
              emptySelectionAllowed: true,
              onSelectionChanged: (s) => _updateBowCategory(s.first),
            ),
            const SizedBox(height: ManahSpacing.lg),
            _SectionLabel('Tipe Busur'),
            if (_bowCategory == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: ManahSpacing.sm),
                child: Text('Pilih kategori busur terlebih dahulu', style: TextStyle(fontStyle: FontStyle.italic)),
              )
            else
              Wrap(
                spacing: ManahSpacing.sm,
                runSpacing: ManahSpacing.sm,
                children: BowClass.ofCategory(_bowCategory!).map((bc) {
                  return _ChoiceChip(
                    label: bc.label,
                    selected: _bowClass == bc,
                    onSelected: (selected) {
                      if (selected) {
                        _updateBowClass(bc);
                      }
                    },
                  );
                }).toList(),
              ),
            const SizedBox(height: ManahSpacing.lg),
            _buildEquipmentPicker(),
            _SectionLabel('Jarak'),
            Wrap(
              spacing: ManahSpacing.sm,
              runSpacing: ManahSpacing.sm,
              children: DistanceCategory.values.map((d) {
                return _ChoiceChip(
                  label: d.label,
                  selected: _distance == d,
                  onSelected: (selected) {
                    if (selected) {
                      _updateDistance(d);
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: ManahSpacing.lg),
            _SectionLabel('Lingkungan'),
            SegmentedButton<ArcheryEnvironment>(
              segments: const [
                ButtonSegment(value: ArcheryEnvironment.outdoor, label: Text('Outdoor')),
                ButtonSegment(value: ArcheryEnvironment.indoor, label: Text('Indoor')),
              ],
              selected: _environment != null ? {_environment!} : const <ArcheryEnvironment>{},
              emptySelectionAllowed: true,
              onSelectionChanged: (s) => _updateEnvironment(s.first),
            ),
            const SizedBox(height: ManahSpacing.lg),
            _SectionLabel('Pilihan Target Face'),
            targetFacesAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(ManahSpacing.base),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (e, _) => Center(child: Text('Gagal memuat target face: $e')),
              data: (targets) {
                if (targets.isEmpty) {
                  return const Center(child: Text('Tidak ada target face tersedia'));
                }

                final selected = _selectedTargetFace;
                if (selected == null) {
                  return Card(
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ManahRadius.md),
                      side: BorderSide(
                        color: theme.dividerColor.withValues(alpha: 0.1),
                      ),
                    ),
                    child: InkWell(
                      onTap: () async {
                        final result = await context.push<TargetFaceEntity>(
                          ScoringRoutes.targetFaceSelection,
                        );
                        if (result != null && mounted) {
                          _updateSelectedTargetFace(result);
                        }
                      },
                      borderRadius: BorderRadius.circular(ManahRadius.md),
                      child: Padding(
                        padding: const EdgeInsets.all(ManahSpacing.base),
                        child: Row(
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(ManahRadius.md),
                              ),
                              child: Icon(
                                Icons.adjust,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: ManahSpacing.base),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pilih Target Face',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Ketuk untuk memilih target face',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.textTheme.bodySmall?.color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: ManahSpacing.sm),
                            const Icon(Icons.chevron_right, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ManahRadius.md),
                    side: BorderSide(
                      color: theme.dividerColor.withValues(alpha: 0.1),
                    ),
                  ),
                  child: InkWell(
                    onTap: () async {
                      final result = await context.push<TargetFaceEntity>(
                        ScoringRoutes.targetFaceSelection,
                        extra: selected,
                      );
                      if (result != null && mounted) {
                        _updateSelectedTargetFace(result);
                      }
                    },
                    borderRadius: BorderRadius.circular(ManahRadius.md),
                    child: Padding(
                      padding: const EdgeInsets.all(ManahSpacing.base),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 54,
                            height: 54,
                            child: TargetFacePreview(
                              code: selected.code,
                              imagePath: selected.imagePath,
                            ),
                          ),
                          const SizedBox(width: ManahSpacing.base),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selected.name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  selected.organizationName ?? 'Kategori Umum',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.textTheme.bodySmall?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: ManahSpacing.sm),
                          const Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: ManahSpacing.lg),
            _Stepper(
              label: 'Jumlah Ronde',
              value: _numEnds,
              min: 1,
              max: 30,
              onChanged: (v) => setState(() => _numEnds = v),
            ),
            const SizedBox(height: ManahSpacing.md),
            _Stepper(
              label: 'Anak Panah',
              value: _arrowsPerEnd,
              min: 1,
              max: 12,
              onChanged: (v) => setState(() => _arrowsPerEnd = v),
            ),
            const SizedBox(height: ManahSpacing.xl),
            if (subStatus != null && !subStatus.isPremium) ...[
              Card(
                color: isGated ? const Color(0xFFFFEBEE) : ManahColors.brandSurface,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ManahRadius.md),
                  side: BorderSide(
                    color: isGated ? ManahColors.error.withOpacity(0.3) : ManahColors.brandLight.withOpacity(0.3),
                  ),
                ),
                child: InkWell(
                  onTap: isGated ? () => context.push('/monetization/paywall') : null,
                  borderRadius: BorderRadius.circular(ManahRadius.md),
                  child: Padding(
                    padding: const EdgeInsets.all(ManahSpacing.base),
                    child: Row(
                      children: [
                        Icon(
                          isGated ? Icons.lock_outline_rounded : Icons.info_outline_rounded,
                          color: isGated ? ManahColors.error : ManahColors.brand,
                        ),
                        const SizedBox(width: ManahSpacing.base),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sesi Latihan Minggu Ini: ${subStatus.scoringSessionsThisWeek}/${subStatus.scoringSessionsLimit}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isGated ? ManahColors.error : ManahColors.brand,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isGated
                                    ? 'Batas mingguan tercapai. Ketuk untuk upgrade ke Premium.'
                                    : 'Paket Gratis dibatasi 3 sesi per minggu.',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isGated ? ManahColors.error.withOpacity(0.8) : ManahColors.brand.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isGated)
                          const Icon(Icons.chevron_right, color: ManahColors.error),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: ManahSpacing.md),
            ],
            Card(
              color: ManahColors.brandSurface,
              child: Padding(
                padding: const EdgeInsets.all(ManahSpacing.base),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total anak panah'),
                    Text(
                      '${_numEnds * _arrowsPerEnd} anak panah · maks ${_numEnds * _arrowsPerEnd * maxScore}',
                      style: const TextStyle(fontWeight: FontWeight.w700, color: ManahColors.brand),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: ManahSpacing.lg),
            FilledButton(
              onPressed: _starting
                  ? null
                  : (isGated
                      ? () => context.push('/monetization/paywall')
                      : ((_bowCategory == null ||
                              _bowClass == null ||
                              _distance == null ||
                              _environment == null ||
                              _selectedTargetFace == null)
                          ? null
                          : _start)),
              style: isGated
                  ? FilledButton.styleFrom(backgroundColor: ManahColors.amberDeep)
                  : null,
              child: _starting
                  ? const SizedBox(
                      height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : (isGated
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.workspace_premium, size: 18),
                            SizedBox(width: 8),
                            Text('Upgrade ke Premium'),
                          ],
                        )
                      : const Text('Mulai Scoring')),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: ManahSpacing.sm),
        child: Text(text, style: Theme.of(context).textTheme.titleSmall),
      );
}

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = selected
        ? theme.colorScheme.primary
        : (isDark ? ManahColors.darkSurface : ManahColors.lightGrey);
    final foregroundColor = selected
        ? Colors.white
        : theme.colorScheme.onSurface;

    return InkWell(
      onTap: () => onSelected(!selected),
      borderRadius: BorderRadius.circular(ManahRadius.sm),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: ManahSpacing.base,
          vertical: ManahSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: selected 
                ? theme.colorScheme.primary 
                : theme.dividerColor.withValues(alpha: 0.1),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(ManahRadius.sm),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: foregroundColor,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: Theme.of(context).textTheme.titleSmall)),
        IconButton.filledTonal(
          onPressed: value > min ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.remove),
        ),
        SizedBox(
          width: 44,
          child: Text('$value', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
        ),
        IconButton.filledTonal(
          onPressed: value < max ? () => onChanged(value + 1) : null,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}

class TargetFacePreview extends StatelessWidget {
  const TargetFacePreview({
    super.key,
    required this.code,
    this.imagePath,
  });

  final String code;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final path = imagePath;
    if (path != null && path.isNotEmpty) {
      if (path.startsWith('http://') || path.startsWith('https://')) {
        return AspectRatio(
          aspectRatio: 1.0,
          child: Image.network(
            path,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return CustomPaint(
                painter: _TargetFacePainter(code),
              );
            },
          ),
        );
      } else if (path.startsWith('assets/')) {
        return AspectRatio(
          aspectRatio: 1.0,
          child: Image.asset(
            path,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return CustomPaint(
                painter: _TargetFacePainter(code),
              );
            },
          ),
        );
      }
    }

    return AspectRatio(
      aspectRatio: 1.0,
      child: CustomPaint(
        painter: _TargetFacePainter(code),
      ),
    );
  }
}

class _TargetFacePainter extends CustomPainter {
  _TargetFacePainter(this.code);
  final String code;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    if (code.startsWith('fita_')) {
      // Draw FITA 10-ring: White, Black, Blue, Red, Gold concentric rings
      final paint = Paint()..style = PaintingStyle.fill;
      final strokePaint = Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.grey.withValues(alpha: 0.3)
        ..strokeWidth = 0.5;

      final colors = [
        Colors.white,
        Colors.black,
        const Color(0xFF1976D2), // Blue
        const Color(0xFFD32F2F), // Red
        const Color(0xFFFBC02D), // Gold
      ];

      for (int i = 0; i < colors.length; i++) {
        paint.color = colors[i];
        final r = radius * (1 - i * 0.2);
        canvas.drawCircle(center, r, paint);
        canvas.drawCircle(center, r, strokePaint);
      }
    } else if (code == 'jemparingan') {
      // Draw Jemparingan vertical cylinder (cap is Red/Gold, body is White)
      final paint = Paint()..style = PaintingStyle.fill;
      final capHeight = size.height * 0.25;

      // Cap (Sirah) - Red
      paint.color = const Color(0xFFD32F2F);
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(size.width * 0.35, 0, size.width * 0.3, capHeight),
          topLeft: Radius.circular(size.width * 0.15),
          topRight: Radius.circular(size.width * 0.15),
        ),
        paint,
      );

      // Body (Awak) - White
      paint.color = Colors.white;
      final borderPaint = Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.grey
        ..strokeWidth = 1.0;

      final bodyRect = Rect.fromLTWH(
        size.width * 0.35,
        capHeight,
        size.width * 0.3,
        size.height * 0.7,
      );
      canvas.drawRect(bodyRect, paint);
      canvas.drawRect(bodyRect, borderPaint);
    } else if (code == 'las_vegas_3spot') {
      // Draw Las Vegas 3 Spot: 3 small concentric spots
      final paint = Paint()..style = PaintingStyle.fill;
      final spotRadius = radius * 0.3;
      final spots = [
        Offset(size.width * 0.5, size.height * 0.28),
        Offset(size.width * 0.25, size.height * 0.7),
        Offset(size.width * 0.75, size.height * 0.7),
      ];

      final colors = [
        const Color(0xFF1976D2), // Blue
        const Color(0xFFD32F2F), // Red
        const Color(0xFFFBC02D), // Gold
      ];

      for (final spotCenter in spots) {
        for (int i = 0; i < colors.length; i++) {
          paint.color = colors[i];
          final r = spotRadius * (1 - i * 0.33);
          canvas.drawCircle(spotCenter, r, paint);
        }
      }
    } else {
      // Fallback: draw generic target face
      final paint = Paint()
        ..color = const Color(0xFFFBC02D)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
