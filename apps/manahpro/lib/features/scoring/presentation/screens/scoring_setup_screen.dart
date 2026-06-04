import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
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
  BowCategory _bowCategory = BowCategory.modern;
  BowClass _bowClass = BowClass.recurve;
  DistanceCategory _distance = DistanceCategory.d70m;
  ArcheryEnvironment _environment = ArcheryEnvironment.outdoor;
  TargetFaceEntity? _selectedTargetFace;
  int _numEnds = 6;
  int _arrowsPerEnd = 6;
  String? _equipmentProfileId;
  bool _starting = false;

  Future<void> _start() async {
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
            bowClass: _bowClass,
            distanceCategory: _distance,
            distanceM: _distance.meters,
            numEnds: _numEnds,
            arrowsPerEnd: _arrowsPerEnd,
            environment: _environment,
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

    if (_selectedTargetFace == null && targetFaces.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _selectedTargetFace == null) {
          setState(() {
            _selectedTargetFace = targetFaces.firstWhere(
              (t) => t.code == 'fita_122',
              orElse: () => targetFaces.first,
            );
          });
        }
      });
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
              selected: {_bowCategory},
              onSelectionChanged: (s) => setState(() {
                _bowCategory = s.first;
                _bowClass = BowClass.ofCategory(_bowCategory).first;
              }),
            ),
            const SizedBox(height: ManahSpacing.lg),
            _SectionLabel('Tipe Busur'),
            _Dropdown<BowClass>(
              value: _bowClass,
              items: BowClass.ofCategory(_bowCategory),
              labelOf: (e) => e.label,
              onChanged: (v) => setState(() => _bowClass = v),
            ),
            const SizedBox(height: ManahSpacing.lg),
            _buildEquipmentPicker(),
            _SectionLabel('Jarak'),
            _Dropdown<DistanceCategory>(
              value: _distance,
              items: DistanceCategory.values,
              labelOf: (e) => e.label,
              onChanged: (v) => setState(() => _distance = v),
            ),
            const SizedBox(height: ManahSpacing.lg),
            _SectionLabel('Lingkungan'),
            SegmentedButton<ArcheryEnvironment>(
              segments: const [
                ButtonSegment(value: ArcheryEnvironment.outdoor, label: Text('Outdoor')),
                ButtonSegment(value: ArcheryEnvironment.indoor, label: Text('Indoor')),
              ],
              selected: {_environment},
              onSelectionChanged: (s) => setState(() => _environment = s.first),
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
                  return const SizedBox.shrink();
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
                        setState(() => _selectedTargetFace = result);
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
              label: 'Jumlah End',
              value: _numEnds,
              min: 1,
              max: 30,
              onChanged: (v) => setState(() => _numEnds = v),
            ),
            const SizedBox(height: ManahSpacing.md),
            _Stepper(
              label: 'Panah / End',
              value: _arrowsPerEnd,
              min: 1,
              max: 12,
              onChanged: (v) => setState(() => _arrowsPerEnd = v),
            ),
            const SizedBox(height: ManahSpacing.xl),
            Card(
              color: ManahColors.brandSurface,
              child: Padding(
                padding: const EdgeInsets.all(ManahSpacing.base),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total panah'),
                    Text(
                      '${_numEnds * _arrowsPerEnd} panah · maks ${_numEnds * _arrowsPerEnd * maxScore}',
                      style: const TextStyle(fontWeight: FontWeight.w700, color: ManahColors.brand),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: ManahSpacing.lg),
            FilledButton(
              onPressed: _starting ? null : _start,
              child: _starting
                  ? const SizedBox(
                      height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Mulai Scoring'),
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

class _Dropdown<T> extends StatelessWidget {
  const _Dropdown({
    required this.value,
    required this.items,
    required this.labelOf,
    required this.onChanged,
  });

  final T value;
  final List<T> items;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items
          .map((e) => DropdownMenuItem<T>(value: e, child: Text(labelOf(e))))
          .toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
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
