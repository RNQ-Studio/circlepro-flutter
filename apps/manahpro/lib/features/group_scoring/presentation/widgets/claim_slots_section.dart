import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/group_claim.dart';
import '../group_scoring_providers.dart';
import 'claim_slot_sheet.dart';

/// The "Ini Saya — klaim slotmu" section shown on the deep-link landing (Sprint
/// 14, tasks 14.1/14.2). It lists the group's guest slots, highlighted, each
/// with a big "Ini Saya" CTA; a slot the user has already claimed shows the
/// "Menunggu persetujuan host" badge instead. This is what closes the loop Pak
/// Budi fell through — the shared result card now lands him on his slot.
class ClaimSlotsSection extends ConsumerWidget {
  const ClaimSlotsSection({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(claimableSlotsProvider(groupId));
    final theme = Theme.of(context);

    return async.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(ManahSpacing.base),
        child: Center(child: CircularProgressIndicator()),
      ),
      // A non-member who cannot reach the slots (or is offline) simply sees no
      // claim section — the join/other actions still stand.
      error: (e, _) => const SizedBox.shrink(),
      data: (slots) {
        if (slots.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.front_hand,
                    size: 18, color: ManahColors.brand),
                const SizedBox(width: ManahSpacing.xs),
                Text(
                  'Ini kamu? Klaim slotmu',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: ManahSpacing.xs),
            Text(
              'Slot tamu di sesi ini. Ketuk "Ini Saya" pada namamu — skornya '
              'jadi milikmu setelah host menyetujui.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.textTheme.bodySmall?.color),
            ),
            const SizedBox(height: ManahSpacing.sm),
            for (final slot in slots)
              Padding(
                padding: const EdgeInsets.only(bottom: ManahSpacing.sm),
                child: _ClaimSlotCard(groupId: groupId, slot: slot),
              ),
          ],
        );
      },
    );
  }
}

class _ClaimSlotCard extends ConsumerStatefulWidget {
  const _ClaimSlotCard({required this.groupId, required this.slot});

  final String groupId;
  final ClaimableSlot slot;

  @override
  ConsumerState<_ClaimSlotCard> createState() => _ClaimSlotCardState();
}

class _ClaimSlotCardState extends ConsumerState<_ClaimSlotCard> {
  bool _busy = false;

  Future<void> _claim() async {
    final choice = await showClaimSlotSheet(context, slot: widget.slot);
    if (choice == null || !choice.confirmed || !mounted) return;

    setState(() => _busy = true);
    try {
      await ref.read(groupScoringRepositoryProvider).submitClaim(
            widget.groupId,
            widget.slot.sessionId,
            message: choice.message,
          );
      ref.invalidate(claimableSlotsProvider(widget.groupId));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Klaim diajukan — menunggu persetujuan host.'),
          backgroundColor: ManahColors.success,
        ),
      );
    } catch (e) {
      if (mounted) setState(() => _busy = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengajukan klaim. Periksa koneksi lalu coba lagi.'),
        ),
      );
    }
  }

  Future<void> _cancel() async {
    final claimId = widget.slot.myClaimId;
    if (claimId == null) return;
    setState(() => _busy = true);
    try {
      await ref.read(groupScoringRepositoryProvider).cancelClaim(claimId);
      ref.invalidate(claimableSlotsProvider(widget.groupId));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Klaim dibatalkan.')),
      );
    } catch (e) {
      if (mounted) setState(() => _busy = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membatalkan klaim.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final slot = widget.slot;
    final name = slot.labelOr('Slot tamu');
    final scoreText = slot.hasStarted ? '${slot.totalScore}' : '—';
    final pending = slot.isPendingMine;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ManahRadius.md),
        side: BorderSide(
          // Highlight the guest slots — "slot tamu tersorot" (narrative 14.1).
          color: pending
              ? ManahColors.amberDeep.withValues(alpha: 0.5)
              : ManahColors.brand.withValues(alpha: 0.35),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(ManahSpacing.base),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: ManahColors.brandSurface,
              child: Text(
                name.isNotEmpty ? name.characters.first.toUpperCase() : '?',
                style: const TextStyle(
                    color: ManahColors.brand, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: ManahSpacing.base),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    'Total $scoreText · ${slot.arrowsShot} panah',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: ManahColors.mediumGrey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: ManahSpacing.sm),
            if (_busy)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else if (pending)
              _PendingBadge(onCancel: _cancel)
            else
              FilledButton(
                onPressed: _claim,
                child: const Text('Ini Saya'),
              ),
          ],
        ),
      ),
    );
  }
}

/// The "Menunggu persetujuan host" badge for a slot the user already claimed
/// (task 14.2), with a discreet way to withdraw.
class _PendingBadge extends StatelessWidget {
  const _PendingBadge({required this.onCancel});

  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: ManahColors.amberDeep.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(ManahRadius.full),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.hourglass_top,
                  size: 12, color: ManahColors.amberDeep),
              SizedBox(width: 4),
              Text(
                'Menunggu host',
                style: TextStyle(
                    color: ManahColors.amberDeep,
                    fontSize: 11,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: onCancel,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text('Batalkan', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }
}
