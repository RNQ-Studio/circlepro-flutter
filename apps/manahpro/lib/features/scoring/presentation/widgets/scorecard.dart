import 'package:flutter/material.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/scoring_entities.dart';

/// Branded, shareable scorecard image (viral loop). Rendered at a fixed width
/// and captured to PNG via a RepaintBoundary. ui-ux-design-guide.md §1.12.
class Scorecard extends StatelessWidget {
  const Scorecard({super.key, required this.session});

  final ScoringSessionEntity session;

  @override
  Widget build(BuildContext context) {
    final d = session.startedAt.toLocal();
    final dateStr = '${d.day}/${d.month}/${d.year}';

    return Container(
      width: 360,
      padding: const EdgeInsets.all(ManahSpacing.lg),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ManahColors.brand, Color(0xFF1B5E20)],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.track_changes, color: Colors.white, size: 22),
              const SizedBox(width: ManahSpacing.sm),
              const Text(
                'ManahPro',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18, letterSpacing: 0.5),
              ),
              const Spacer(),
              if (session.isPersonalBest)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: ManahColors.amber,
                    borderRadius: BorderRadius.circular(ManahRadius.full),
                  ),
                  child: const Text('PB 🎯', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                ),
            ],
          ),
          const SizedBox(height: ManahSpacing.xl),
          Text(
            '${session.bowClass.label} · ${session.distanceCategory.label}',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: ManahSpacing.xs),
          Text(
            '${session.totalScore}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 72, height: 1.0),
          ),
          Text(
            'dari ${session.maxPossibleScore} · avg ${session.avgPerArrow?.toStringAsFixed(2) ?? '–'}/panah',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: ManahSpacing.lg),
          Row(
            children: [
              _Pill(label: 'X', value: '${session.xCount}'),
              const SizedBox(width: ManahSpacing.sm),
              _Pill(label: '10', value: '${session.tenCount}'),
              const SizedBox(width: ManahSpacing.sm),
              _Pill(label: 'Miss', value: '${session.missCount}'),
              const SizedBox(width: ManahSpacing.sm),
              _Pill(label: 'Panah', value: '${session.arrowsShot}'),
            ],
          ),
          const SizedBox(height: ManahSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dateStr, style: const TextStyle(color: Colors.white60, fontSize: 12)),
              const Text('manahpro.id', style: TextStyle(color: Colors.white60, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: ManahSpacing.sm),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(ManahRadius.md),
        ),
        child: Column(
          children: [
            Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
