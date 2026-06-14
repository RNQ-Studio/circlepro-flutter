import 'package:flutter/material.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../../scoring/domain/scoring_enums.dart';

/// Result of the optional bow-class picker shown before self-joining a group.
/// [confirmed] is false when the sheet was dismissed (the join is cancelled).
typedef JoinBowChoice = ({bool confirmed, BowClass? bowClass});

/// A light bottom sheet that lets a joining member pick a bow class — or skip it
/// (K8: metadata must never block joining). Returns the choice, or null when the
/// sheet is dismissed. The class can always be set later (the join endpoint
/// back-fills it), so "Lewati" is a first-class, friction-free path.
Future<JoinBowChoice?> showJoinBowClassSheet(BuildContext context) {
  return showModalBottomSheet<JoinBowChoice>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => const _JoinBowClassSheet(),
  );
}

class _JoinBowClassSheet extends StatefulWidget {
  const _JoinBowClassSheet();

  @override
  State<_JoinBowClassSheet> createState() => _JoinBowClassSheetState();
}

class _JoinBowClassSheetState extends State<_JoinBowClassSheet> {
  BowClass? _selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            ManahSpacing.base, 0, ManahSpacing.base, ManahSpacing.base),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Kelas busurmu',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: ManahSpacing.xs),
            Text(
              'Opsional — boleh dilengkapi nanti. Mengisi sekarang membuat '
              'skormu masuk rekor pribadi kelas yang tepat.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.textTheme.bodySmall?.color),
            ),
            const SizedBox(height: ManahSpacing.base),
            Wrap(
              spacing: ManahSpacing.sm,
              runSpacing: ManahSpacing.sm,
              children: BowClass.values.map((bc) {
                final selected = _selected == bc;
                return ChoiceChip(
                  label: Text(bc.label),
                  selected: selected,
                  selectedColor: ManahColors.brand,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : null,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (_) =>
                      setState(() => _selected = selected ? null : bc),
                );
              }).toList(),
            ),
            const SizedBox(height: ManahSpacing.lg),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(
                (confirmed: true, bowClass: _selected),
              ),
              icon: const Icon(Icons.login),
              label: const Text('Gabung Sesi'),
            ),
            const SizedBox(height: ManahSpacing.sm),
            TextButton(
              onPressed: () => Navigator.of(context).pop(
                (confirmed: true, bowClass: null),
              ),
              child: const Text('Gabung tanpa kelas busur'),
            ),
          ],
        ),
      ),
    );
  }
}
