import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_text_styles.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/group_claim.dart';
import '../group_scoring_providers.dart';

/// Host claim inbox (Sprint 14, task 14.3) — the screen where Coach Hadi decides
/// from memory, not a guess. Each card carries the slot's score, distance and
/// when it was shot (the backend's rich `slot` block, 13.2), the claimant's name
/// and optional note; pending claims approve/reject in one tap.
class ClaimInboxScreen extends ConsumerWidget {
  const ClaimInboxScreen({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(hostClaimsProvider(groupId));

    return Scaffold(
      appBar: AppBar(title: const Text('Klaim Masuk')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _InboxError(message: '$e'),
        data: (claims) {
          if (claims.isEmpty) return const _EmptyInbox();
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(hostClaimsProvider(groupId)),
            child: ListView.separated(
              padding: const EdgeInsets.all(ManahSpacing.base),
              itemCount: claims.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: ManahSpacing.sm),
              itemBuilder: (_, i) =>
                  _ClaimCard(groupId: groupId, claim: claims[i]),
            ),
          );
        },
      ),
    );
  }
}

class _ClaimCard extends ConsumerStatefulWidget {
  const _ClaimCard({required this.groupId, required this.claim});

  final String groupId;
  final HostClaim claim;

  @override
  ConsumerState<_ClaimCard> createState() => _ClaimCardState();
}

class _ClaimCardState extends ConsumerState<_ClaimCard> {
  bool _busy = false;

  Future<void> _resolve({required bool approve}) async {
    setState(() => _busy = true);
    try {
      await ref
          .read(groupScoringRepositoryProvider)
          .resolveClaim(widget.claim.id, approve: approve);
      // The board, leaderboard and inbox all shift when ownership transfers.
      ref.invalidate(hostClaimsProvider(widget.groupId));
      ref.invalidate(hostBoardControllerProvider(widget.groupId));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(approve ? 'Klaim disetujui.' : 'Klaim ditolak.'),
          backgroundColor:
              approve ? ManahColors.success : ManahColors.mediumGrey,
        ),
      );
    } catch (e) {
      if (mounted) setState(() => _busy = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memproses klaim. Coba lagi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final claim = widget.claim;
    final slot = claim.slot;
    final claimant = claim.claimantName ?? 'Pemanah';
    final slotName = slot?.displayName ?? 'Slot tamu';

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ManahRadius.md),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(ManahSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: claimant,
                          style:
                              const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ' mengklaim '),
                        TextSpan(
                          text: '"$slotName"',
                          style:
                              const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!claim.isPending) _StatusChip(status: claim.status),
              ],
            ),
            if (slot != null) ...[
              const SizedBox(height: ManahSpacing.sm),
              _SlotRecap(slot: slot),
            ],
            if (claim.message != null && claim.message!.isNotEmpty) ...[
              const SizedBox(height: ManahSpacing.sm),
              Container(
                padding: const EdgeInsets.all(ManahSpacing.sm),
                decoration: BoxDecoration(
                  color: ManahColors.mediumGrey.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(ManahRadius.sm),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.chat_bubble_outline,
                        size: 14, color: ManahColors.mediumGrey),
                    const SizedBox(width: ManahSpacing.xs),
                    Expanded(
                      child: Text(
                        claim.message!,
                        style: ManahTextStyles.bodyS
                            .copyWith(color: ManahColors.mediumGrey),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (claim.isPending) ...[
              const SizedBox(height: ManahSpacing.base),
              if (_busy)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(ManahSpacing.xs),
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _resolve(approve: false),
                        icon: const Icon(Icons.close, size: 18),
                        label: const Text('Tolak'),
                      ),
                    ),
                    const SizedBox(width: ManahSpacing.sm),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => _resolve(approve: true),
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text('Setujui'),
                      ),
                    ),
                  ],
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SlotRecap extends StatelessWidget {
  const _SlotRecap({required this.slot});

  final ClaimSlotContext slot;

  @override
  Widget build(BuildContext context) {
    final scoreText = slot.hasStarted ? '${slot.totalScore}' : '—';
    final distance = slot.distanceM != null ? '${slot.distanceM} m · ' : '';
    return Container(
      padding: const EdgeInsets.all(ManahSpacing.sm),
      decoration: BoxDecoration(
        color: ManahColors.brandSurface,
        borderRadius: BorderRadius.circular(ManahRadius.sm),
      ),
      child: Row(
        children: [
          const Icon(Icons.sports_score, size: 18, color: ManahColors.brand),
          const SizedBox(width: ManahSpacing.sm),
          Expanded(
            child: Text(
              '$distance${slot.arrowsShot} panah · X ${slot.xCount} · 10 ${slot.tenCount}',
              style: ManahTextStyles.bodyS
                  .copyWith(color: ManahColors.mediumGrey),
            ),
          ),
          Text(
            'Total $scoreText',
            style: ManahTextStyles.bodyM.copyWith(
                color: ManahColors.brand, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final ClaimStatus status;

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      ClaimStatus.approved => (ManahColors.success, 'Disetujui'),
      ClaimStatus.rejected => (ManahColors.error, 'Ditolak'),
      ClaimStatus.cancelled => (ManahColors.mediumGrey, 'Dibatalkan'),
      ClaimStatus.pending => (ManahColors.amberDeep, 'Menunggu'),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(ManahRadius.full),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _EmptyInbox extends StatelessWidget {
  const _EmptyInbox();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      children: [
        const SizedBox(height: 120),
        Icon(Icons.inbox_outlined, size: 64, color: theme.disabledColor),
        const SizedBox(height: ManahSpacing.base),
        Text(
          'Belum ada klaim',
          textAlign: TextAlign.center,
          style:
              theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: ManahSpacing.sm),
        Text(
          'Saat pemanah mengklaim slot tamunya lewat "Ini Saya", '
          'klaimnya muncul di sini untuk kamu setujui.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.textTheme.bodySmall?.color),
        ),
      ],
    );
  }
}

class _InboxError extends StatelessWidget {
  const _InboxError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ManahSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: ManahColors.error),
            const SizedBox(height: ManahSpacing.base),
            Text('Gagal memuat klaim.\n$message', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
