import 'package:flutter/material.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/group_claim.dart';

/// Result of the "Ini Saya" claim sheet. [confirmed] is false when dismissed.
typedef ClaimChoice = ({bool confirmed, String? message});

/// The "Ini Saya" sheet (Sprint 14, task 14.2): a signed-in archer confirms a
/// guest slot is theirs and optionally leaves a note so the host recognises them
/// ("Aku yang di bantalan 3"). It only collects intent — the caller submits the
/// claim and shows the "Menunggu persetujuan host" badge. Returns the choice, or
/// null when the sheet is dismissed.
Future<ClaimChoice?> showClaimSlotSheet(
  BuildContext context, {
  required ClaimableSlot slot,
}) {
  return showModalBottomSheet<ClaimChoice>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: _ClaimSlotSheet(slot: slot),
    ),
  );
}

class _ClaimSlotSheet extends StatefulWidget {
  const _ClaimSlotSheet({required this.slot});

  final ClaimableSlot slot;

  @override
  State<_ClaimSlotSheet> createState() => _ClaimSlotSheetState();
}

class _ClaimSlotSheetState extends State<_ClaimSlotSheet> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final slot = widget.slot;
    final name = slot.labelOr('Slot tamu');
    final scoreText = slot.hasStarted ? '${slot.totalScore}' : '—';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            ManahSpacing.base, 0, ManahSpacing.base, ManahSpacing.base),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Klaim slot ini?',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: ManahSpacing.xs),
            Text(
              'Skor "$name" akan menjadi milikmu setelah disetujui host. '
              'PB & statistikmu ikut diperbarui.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.textTheme.bodySmall?.color),
            ),
            const SizedBox(height: ManahSpacing.base),
            // Slot recap so the archer is sure it is the right one.
            Container(
              padding: const EdgeInsets.all(ManahSpacing.base),
              decoration: BoxDecoration(
                color: ManahColors.brandSurface,
                borderRadius: BorderRadius.circular(ManahRadius.md),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child:
                        Icon(Icons.person_outline, color: ManahColors.brand),
                  ),
                  const SizedBox(width: ManahSpacing.base),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),
                        if (slot.distanceM != null)
                          Text(
                            '${slot.distanceM} m · ${slot.arrowsShot} panah',
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: ManahColors.mediumGrey),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    scoreText,
                    style: theme.textTheme.titleLarge?.copyWith(
                        color: ManahColors.brand,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: ManahSpacing.base),
            TextField(
              controller: _messageController,
              maxLength: 200,
              minLines: 1,
              maxLines: 3,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Pesan untuk host (opsional)',
                hintText: 'Mis. "Aku yang di bantalan 3"',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: ManahSpacing.sm),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(
                (confirmed: true, message: _messageController.text.trim()),
              ),
              icon: const Icon(Icons.front_hand),
              label: const Text('Ini Saya'),
            ),
          ],
        ),
      ),
    );
  }
}
