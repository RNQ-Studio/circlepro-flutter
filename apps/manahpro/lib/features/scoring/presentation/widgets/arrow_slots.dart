import 'package:flutter/material.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/scoring_entities.dart';

/// Row of arrow slots for the current end, filled left→right. Empty slots are
/// outlined placeholders. ui-ux-design-guide.md §6.2.
class ArrowSlots extends StatelessWidget {
  const ArrowSlots({super.key, required this.arrows, required this.capacity});

  final List<ArrowScore> arrows;
  final int capacity;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: ManahSpacing.sm,
      runSpacing: ManahSpacing.sm,
      children: List.generate(capacity, (i) {
        final filled = i < arrows.length;
        return _Slot(arrow: filled ? arrows[i] : null);
      }),
    );
  }
}

class _Slot extends StatelessWidget {
  const _Slot({this.arrow});

  final ArrowScore? arrow;

  @override
  Widget build(BuildContext context) {
    final filled = arrow != null;
    final color = filled
        ? ManahColors.forScore(arrow!.scoreValue, isX: arrow!.isX, isMiss: arrow!.isMiss)
        : Theme.of(context).dividerColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: filled ? color.withValues(alpha: 0.16) : Colors.transparent,
        borderRadius: BorderRadius.circular(ManahRadius.md),
        border: Border.all(color: filled ? color : color.withValues(alpha: 0.5)),
      ),
      alignment: Alignment.center,
      child: Text(
        filled ? arrow!.displayValue : '',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: filled
              ? (color == ManahColors.scoreGold ? ManahColors.amberDeep : color)
              : Colors.transparent,
        ),
      ),
    );
  }
}
