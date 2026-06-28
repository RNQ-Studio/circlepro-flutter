import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_text_styles.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/group_entities.dart';
import '../group_scoring_providers.dart';
import '../group_scoring_routes.dart';

class ButtPickerScreen extends ConsumerStatefulWidget {
  const ButtPickerScreen({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState<ButtPickerScreen> createState() => _ButtPickerScreenState();
}

class _ButtPickerScreenState extends ConsumerState<ButtPickerScreen> {
  AppLifecycleListener? _lifecycle;
  int? _busyButt;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onStateChange: (state) {
        final active = state == AppLifecycleState.resumed;
        ref
            .read(buttStatusControllerProvider(widget.groupId).notifier)
            .setAppActive(active);
      },
    );
  }

  @override
  void dispose() {
    _lifecycle?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(buttStatusControllerProvider(widget.groupId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Bantalan'),
        actions: [
          IconButton(
            tooltip: 'Monitor bantalan',
            icon: const Icon(Icons.speed_outlined),
            onPressed: () =>
                context.push(GroupScoringRoutes.buttStatus(widget.groupId)),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ButtError(message: '$e'),
        data: (state) => RefreshIndicator(
          onRefresh: () => ref
              .read(buttStatusControllerProvider(widget.groupId).notifier)
              .refreshNow(),
          child: state.butts.isEmpty
              ? const _EmptyButts()
              : ListView(
                  padding: const EdgeInsets.all(ManahSpacing.base),
                  children: [
                    _ButtSummary(state: state),
                    const SizedBox(height: ManahSpacing.base),
                    for (final butt in state.butts)
                      Padding(
                        padding: const EdgeInsets.only(bottom: ManahSpacing.sm),
                        child: _ButtCard(
                          butt: butt,
                          busy: _busyButt == butt.targetButt,
                          onOpen: butt.targetButt == null
                              ? null
                              : () => context.push(
                                    GroupScoringRoutes.buttBoard(
                                      widget.groupId,
                                      butt.targetButt!,
                                    ),
                                  ),
                          onClaim: butt.canClaim
                              ? () => _claimButt(butt.targetButt!)
                              : null,
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _claimButt(int targetButt) async {
    setState(() => _busyButt = targetButt);
    try {
      await ref
          .read(buttStatusControllerProvider(widget.groupId).notifier)
          .claimButt(targetButt);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bantalan $targetButt diklaim.'),
          backgroundColor: ManahColors.success,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bantalan sudah diklaim atau koneksi terputus.'),
          backgroundColor: ManahColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _busyButt = null);
    }
  }
}

class _ButtSummary extends StatelessWidget {
  const _ButtSummary({required this.state});

  final ButtStatusState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ManahSpacing.base),
      decoration: BoxDecoration(
        color: ManahColors.brandSurface,
        borderRadius: BorderRadius.circular(ManahRadius.md),
      ),
      child: Row(
        children: [
          _SummaryStat(label: 'Bantalan', value: '${state.buttCount}'),
          _SummaryStat(label: 'Peserta', value: '${state.participantCount}'),
          _SummaryStat(label: 'Tertinggal', value: '${state.laggingCount}'),
          Icon(
            state.offline ? Icons.cloud_off : Icons.cloud_done_outlined,
            color: state.offline ? ManahColors.amberDeep : ManahColors.brand,
          ),
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: ManahTextStyles.h3),
          Text(
            label,
            style: ManahTextStyles.bodyS.copyWith(
              color: ManahColors.mediumGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class _ButtCard extends StatelessWidget {
  const _ButtCard({
    required this.butt,
    required this.busy,
    required this.onOpen,
    required this.onClaim,
  });

  final GroupButtEntity butt;
  final bool busy;
  final VoidCallback? onOpen;
  final VoidCallback? onClaim;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress =
        butt.targetEnds == 0 ? 0.0 : butt.endProgress / butt.targetEnds;
    final accent = butt.isLagging ? ManahColors.amberDeep : ManahColors.brand;

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
                CircleAvatar(
                  backgroundColor: accent.withValues(alpha: 0.12),
                  child: Icon(Icons.adjust, color: accent),
                ),
                const SizedBox(width: ManahSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        butt.label,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        butt.scorer?.name == null
                            ? 'Belum ada skorer'
                            : 'Skorer: ${butt.scorer!.name}',
                        style: ManahTextStyles.bodyS.copyWith(
                          color: ManahColors.mediumGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                _ProgressPill(label: butt.progressLabel, color: accent),
              ],
            ),
            const SizedBox(height: ManahSpacing.sm),
            LinearProgressIndicator(
              minHeight: 6,
              borderRadius: BorderRadius.circular(ManahRadius.full),
              value: progress.clamp(0.0, 1.0),
              color: accent,
              backgroundColor: accent.withValues(alpha: 0.12),
            ),
            const SizedBox(height: ManahSpacing.sm),
            Wrap(
              spacing: ManahSpacing.xs,
              runSpacing: ManahSpacing.xs,
              children: [
                _MetaChip(
                  icon: Icons.groups_2_outlined,
                  label: '${butt.participantCount} peserta',
                ),
                _MetaChip(
                  icon: Icons.check_circle_outline,
                  label: '${butt.completedCount} selesai',
                ),
                if (butt.isLagging)
                  _MetaChip(
                    icon: Icons.warning_amber_rounded,
                    label: 'Tertinggal ${butt.laggingByEnds} rambahan',
                    color: ManahColors.amberDeep,
                  ),
              ],
            ),
            if (butt.participants.isNotEmpty) ...[
              const SizedBox(height: ManahSpacing.sm),
              Text(
                butt.participants
                    .take(4)
                    .map((p) =>
                        '${p.targetLabel} ${p.displayName ?? p.guestName ?? 'Pemanah'}')
                    .join(' · '),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: ManahTextStyles.bodyS.copyWith(
                  color: ManahColors.mediumGrey,
                ),
              ),
            ],
            const SizedBox(height: ManahSpacing.base),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onClaim == null || busy ? null : onClaim,
                    icon: busy
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.how_to_reg, size: 18),
                    label: Text(butt.scorer == null ? 'Klaim' : 'Terklaim'),
                  ),
                ),
                const SizedBox(width: ManahSpacing.sm),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onOpen,
                    icon: const Icon(Icons.edit_note, size: 18),
                    label: const Text('Catat'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressPill extends StatelessWidget {
  const _ProgressPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(ManahRadius.full),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    this.color = ManahColors.mediumGrey,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ManahRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyButts extends StatelessWidget {
  const _EmptyButts();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(ManahSpacing.xl),
      children: [
        Icon(Icons.adjust, size: 64, color: Theme.of(context).disabledColor),
        const SizedBox(height: ManahSpacing.base),
        Text(
          'Belum ada bantalan',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: ManahSpacing.sm),
        Text(
          'Bagi peserta ke bantalan dulu, lalu skorer bisa klaim bantalan masing-masing.',
          textAlign: TextAlign.center,
          style: ManahTextStyles.bodyM.copyWith(color: ManahColors.mediumGrey),
        ),
      ],
    );
  }
}

class _ButtError extends StatelessWidget {
  const _ButtError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ManahSpacing.xl),
        child: Text('Gagal memuat bantalan.\n$message',
            textAlign: TextAlign.center),
      ),
    );
  }
}
