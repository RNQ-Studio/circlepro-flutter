import 'package:flutter/material.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';

/// A single key on the score pad.
class ScoreKey {
  const ScoreKey.value(this.value)
      : isX = false,
        isMiss = false,
        label = null;
  const ScoreKey.x()
      : value = 10,
        isX = true,
        isMiss = false,
        label = 'X';
  const ScoreKey.miss()
      : value = 0,
        isX = false,
        isMiss = true,
        label = 'M';

  final int value;
  final bool isX;
  final bool isMiss;
  final String? label;

  String get display => label ?? '$value';

  Color get color => ManahColors.forScore(value, isX: isX, isMiss: isMiss);
}

/// The large, high-contrast, one-handed score input pad (M, 1-10, X + Undo).
/// ui-ux-design-guide.md §6.2.
class ScorePad extends StatelessWidget {
  const ScorePad({
    super.key,
    required this.onScore,
    required this.onUndo,
    required this.undoEnabled,
  });

  final ValueChanged<ScoreKey> onScore;
  final VoidCallback onUndo;
  final bool undoEnabled;

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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _keys.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: ManahSpacing.sm,
            crossAxisSpacing: ManahSpacing.sm,
            childAspectRatio: 1.6,
          ),
          itemBuilder: (context, i) => _ScoreButton(scoreKey: _keys[i], onTap: onScore),
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

  @override
  Widget build(BuildContext context) {
    final color = scoreKey.color;

    return Material(
      color: color.withValues(alpha: 0.16),
      borderRadius: BorderRadius.circular(ManahRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(ManahRadius.md),
        onTap: () => onTap(scoreKey),
        child: Center(
          child: Text(
            scoreKey.display,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: color == ManahColors.scoreGold ? ManahColors.amberDeep : color,
            ),
          ),
        ),
      ),
    );
  }
}
