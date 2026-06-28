import 'package:flutter/material.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../../scoring/domain/scoring_enums.dart';

/// Result of the optional bow-class picker shown before self-joining a group.
/// [confirmed] is false when the sheet was dismissed (the join is cancelled).
typedef JoinBowChoice = ({
  bool confirmed,
  BowClass? bowClass,
  int? distanceM,
  int? targetFaceCm,
});

/// A light bottom sheet that lets a joining member pick a bow class — or skip it
/// (K8: metadata must never block joining). Returns the choice, or null when the
/// sheet is dismissed. The class can always be set later (the join endpoint
/// back-fills it), so "Lewati" is a first-class, friction-free path.
Future<JoinBowChoice?> showJoinBowClassSheet(
  BuildContext context, {
  required int defaultDistanceM,
  int? defaultTargetFaceCm,
}) {
  return showModalBottomSheet<JoinBowChoice>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => _JoinBowClassSheet(
      defaultDistanceM: defaultDistanceM,
      defaultTargetFaceCm: defaultTargetFaceCm,
    ),
  );
}

class _JoinBowClassSheet extends StatefulWidget {
  const _JoinBowClassSheet({
    required this.defaultDistanceM,
    required this.defaultTargetFaceCm,
  });

  final int defaultDistanceM;
  final int? defaultTargetFaceCm;

  @override
  State<_JoinBowClassSheet> createState() => _JoinBowClassSheetState();
}

class _JoinBowClassSheetState extends State<_JoinBowClassSheet> {
  BowClass? _selected;
  late int _distanceM = widget.defaultDistanceM;
  late int? _targetFaceCm = widget.defaultTargetFaceCm;

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
              'Detail bergabung',
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
            Text(
              'Jarak',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: ManahSpacing.xs),
            Wrap(
              spacing: ManahSpacing.sm,
              runSpacing: ManahSpacing.xs,
              children: DistanceCategory.values.map((distance) {
                final selected = _distanceM == distance.meters;
                return ChoiceChip(
                  label: Text('${distance.meters} m'),
                  selected: selected,
                  selectedColor: ManahColors.brand,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : null,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (_) =>
                      setState(() => _distanceM = distance.meters),
                );
              }).toList(),
            ),
            const SizedBox(height: ManahSpacing.base),
            Text(
              'Target face',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: ManahSpacing.xs),
            Wrap(
              spacing: ManahSpacing.sm,
              runSpacing: ManahSpacing.xs,
              children: _faceOptions.map((face) {
                final selected = _targetFaceCm == face;
                return ChoiceChip(
                  label: Text('$face cm'),
                  selected: selected,
                  selectedColor: ManahColors.brand,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : null,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (_) => setState(() => _targetFaceCm = face),
                );
              }).toList(),
            ),
            const SizedBox(height: ManahSpacing.base),
            Text(
              'Kelas busur',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: ManahSpacing.xs),
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
                (
                  confirmed: true,
                  bowClass: _selected,
                  distanceM: _distanceM,
                  targetFaceCm: _targetFaceCm,
                ),
              ),
              icon: const Icon(Icons.login),
              label: const Text('Gabung Sesi'),
            ),
            const SizedBox(height: ManahSpacing.sm),
            TextButton(
              onPressed: () => Navigator.of(context).pop(
                (
                  confirmed: true,
                  bowClass: null,
                  distanceM: widget.defaultDistanceM,
                  targetFaceCm: widget.defaultTargetFaceCm,
                ),
              ),
              child: const Text('Gabung tanpa kelas busur'),
            ),
          ],
        ),
      ),
    );
  }

  List<int> get _faceOptions => {
        if (widget.defaultTargetFaceCm != null) widget.defaultTargetFaceCm!,
        122,
        80,
        60,
        40,
      }.toList();
}
