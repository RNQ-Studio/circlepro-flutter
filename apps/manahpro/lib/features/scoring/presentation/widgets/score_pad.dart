import 'package:flutter/material.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/scoring_entities.dart';

/// A single key on the score pad.
class ScoreKey {
  const ScoreKey.value(this.value)
      : isX = false,
        isMiss = false,
        label = null,
        color = null;
  const ScoreKey.x()
      : value = 10,
        isX = true,
        isMiss = false,
        label = 'X',
        color = null;
  const ScoreKey.miss()
      : value = 0,
        isX = false,
        isMiss = true,
        label = 'M',
        color = null;
  const ScoreKey.custom({
    required this.value,
    this.label,
    required this.color,
    this.isX = false,
    this.isMiss = false,
  });

  final int value;
  final bool isX;
  final bool isMiss;
  final String? label;
  final Color? color;

  String get display => label ?? '$value';

  Color get colorValue {
    if (color != null) return color!;
    return ManahColors.forScore(value, isX: isX, isMiss: isMiss);
  }
}

/// The dynamic, high-contrast, one-handed score input pad (M, 1-10, X + Undo).
/// ui-ux-design-guide.md §6.2.
class ScorePad extends StatelessWidget {
  const ScorePad({
    super.key,
    required this.onScore,
    required this.onUndo,
    required this.undoEnabled,
    this.targetFace,
  });

  final ValueChanged<ScoreKey> onScore;
  final VoidCallback onUndo;
  final bool undoEnabled;
  final TargetFaceEntity? targetFace;

  static const List<ScoreKey> _keys = [
    ScoreKey.miss(),
    ScoreKey.value(1),
    ScoreKey.value(2),
    ScoreKey.value(3),
    ScoreKey.value(4),
    ScoreKey.value(5),
    ScoreKey.value(6),
    ScoreKey.value(7),
    ScoreKey.value(8),
    ScoreKey.value(9),
    ScoreKey.value(10),
    ScoreKey.x(),
  ];

  List<ScoreKey> get keys {
    final tf = targetFace;
    if (tf == null) return _keys;
    return tf.scoringRules.map((r) {
      Color? parsedColor;
      try {
        final hex = r.colorHex.replaceFirst('#', '');
        final val = int.parse(hex, radix: 16);
        parsedColor = Color(val | 0xFF000000);
      } catch (_) {}
      return ScoreKey.custom(
        value: r.value,
        label: r.label,
        color: parsedColor,
        isX: r.isX,
        isMiss: r.isMiss,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final buttons = keys;
    final columnCount = buttons.length <= 4 ? buttons.length : 4;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: buttons.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columnCount,
            mainAxisSpacing: ManahSpacing.sm,
            crossAxisSpacing: ManahSpacing.sm,
            childAspectRatio: columnCount == 3 ? 2.0 : 1.6,
          ),
          itemBuilder: (context, i) => _ScoreButton(scoreKey: buttons[i], onTap: onScore),
        ),
        const SizedBox(height: ManahSpacing.sm),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: undoEnabled ? onUndo : null,
            icon: const Icon(Icons.backspace_outlined),
            label: const Text('Undo'),
          ),
        ),
      ],
    );
  }
}

class _ScoreButton extends StatelessWidget {
  const _ScoreButton({required this.scoreKey, required this.onTap});

  final ScoreKey scoreKey;
  final ValueChanged<ScoreKey> onTap;

  Color _getTextColor(Color buttonColor) {
    if (buttonColor.computeLuminance() > 0.6) {
      return ManahColors.nearBlack;
    }
    if (buttonColor == ManahColors.scoreGold) {
      return ManahColors.amberDeep;
    }
    return buttonColor;
  }

  @override
  Widget build(BuildContext context) {
    final color = scoreKey.colorValue;
    final textColor = _getTextColor(color);
    final theme = Theme.of(context);

    // Subtle border for light colored buttons
    final hasBorder = color.computeLuminance() > 0.8;

    return Material(
      color: color.withValues(alpha: 0.16),
      borderRadius: BorderRadius.circular(ManahRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(ManahRadius.md),
        onTap: () => onTap(scoreKey),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ManahRadius.md),
            border: hasBorder
                ? Border.all(color: theme.dividerColor.withValues(alpha: 0.2), width: 1)
                : null,
          ),
          child: Center(
            child: Text(
              scoreKey.display,
              style: TextStyle(
                fontSize: scoreKey.display.length > 5 ? 16 : 24,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
