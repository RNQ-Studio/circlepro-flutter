import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_text_styles.dart';
import '../../../../theme/manah_tokens.dart';
import '../../domain/group_entities.dart';
import '../group_scoring_providers.dart';
import '../group_scoring_routes.dart';

class ButtStatusDashboardScreen extends ConsumerStatefulWidget {
  const ButtStatusDashboardScreen({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState<ButtStatusDashboardScreen> createState() =>
      _ButtStatusDashboardScreenState();
}

class _ButtStatusDashboardScreenState
    extends ConsumerState<ButtStatusDashboardScreen> {
  AppLifecycleListener? _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onStateChange: (state) {
        ref
            .read(buttStatusControllerProvider(widget.groupId).notifier)
            .setAppActive(state == AppLifecycleState.resumed);
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
        title: const Text('Monitor Bantalan'),
        actions: [
          IconButton(
            tooltip: 'Pilih bantalan',
            icon: const Icon(Icons.adjust),
            onPressed: () =>
                context.push(GroupScoringRoutes.butts(widget.groupId)),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _StatusError(message: '$e'),
        data: (state) => RefreshIndicator(
          onRefresh: () => ref
              .read(buttStatusControllerProvider(widget.groupId).notifier)
              .refreshNow(),
          child: ListView(
            padding: const EdgeInsets.all(ManahSpacing.base),
            children: [
              _MonitorHeader(state: state),
              const SizedBox(height: ManahSpacing.base),
              if (state.butts.isEmpty)
                const _EmptyMonitor()
              else
                for (final butt in [...state.butts]..sort((a, b) {
                    if (a.isLagging != b.isLagging) {
                      return a.isLagging ? -1 : 1;
                    }
                    return (a.targetButt ?? 9999).compareTo(
                      b.targetButt ?? 9999,
                    );
                  }))
                  Padding(
                    padding: const EdgeInsets.only(bottom: ManahSpacing.sm),
                    child: _MonitorRow(
                      butt: butt,
                      onOpen: butt.targetButt == null
                          ? null
                          : () => context.push(
                                GroupScoringRoutes.buttBoard(
                                  widget.groupId,
                                  butt.targetButt!,
                                ),
                              ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonitorHeader extends StatelessWidget {
  const _MonitorHeader({required this.state});

  final ButtStatusState state;

  @override
  Widget build(BuildContext context) {
    final color =
        state.laggingCount > 0 ? ManahColors.amberDeep : ManahColors.success;
    return Container(
      padding: const EdgeInsets.all(ManahSpacing.base),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ManahRadius.md),
      ),
      child: Row(
        children: [
          Icon(
            state.laggingCount > 0
                ? Icons.warning_amber_rounded
                : Icons.check_circle_outline,
            color: color,
          ),
          const SizedBox(width: ManahSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.laggingCount > 0
                      ? '${state.laggingCount} bantalan tertinggal'
                      : 'Semua bantalan seirama',
                  style: ManahTextStyles.bodyM.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                Text(
                  state.offline
                      ? 'Mode offline, mencoba sinkron lagi.'
                      : '${state.participantCount} peserta · ${state.buttCount} bantalan',
                  style: ManahTextStyles.bodyS.copyWith(
                    color: ManahColors.mediumGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MonitorRow extends StatelessWidget {
  const _MonitorRow({required this.butt, required this.onOpen});

  final GroupButtEntity butt;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = butt.isLagging ? ManahColors.amberDeep : ManahColors.brand;
    final progress =
        butt.targetEnds == 0 ? 0.0 : butt.endProgress / butt.targetEnds;

    return InkWell(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(ManahRadius.md),
      child: Container(
        padding: const EdgeInsets.all(ManahSpacing.base),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ManahRadius.md),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.12)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 56,
              child: Column(
                children: [
                  Text(
                    butt.targetButt?.toString() ?? '-',
                    style: ManahTextStyles.h2.copyWith(color: color),
                  ),
                  Text(
                    butt.progressLabel,
                    style: ManahTextStyles.bodyS.copyWith(
                      color: ManahColors.mediumGrey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: ManahSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          butt.scorer?.name ?? 'Belum ada skorer',
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Text(
                        '${butt.pendingCount} menunggu',
                        style: ManahTextStyles.bodyS.copyWith(color: color),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    minHeight: 5,
                    borderRadius: BorderRadius.circular(ManahRadius.full),
                    value: progress.clamp(0.0, 1.0),
                    color: color,
                    backgroundColor: color.withValues(alpha: 0.12),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${butt.participantCount} peserta · total ${butt.totalScore}',
                    style: ManahTextStyles.bodyS.copyWith(
                      color: ManahColors.mediumGrey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: ManahSpacing.sm),
            Icon(Icons.chevron_right, color: onOpen == null ? null : color),
          ],
        ),
      ),
    );
  }
}

class _EmptyMonitor extends StatelessWidget {
  const _EmptyMonitor();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: ManahSpacing.xl),
      child: Text(
        'Belum ada data bantalan.',
        textAlign: TextAlign.center,
        style: ManahTextStyles.bodyM.copyWith(color: ManahColors.mediumGrey),
      ),
    );
  }
}

class _StatusError extends StatelessWidget {
  const _StatusError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ManahSpacing.xl),
        child: Text('Gagal memuat monitor.\n$message',
            textAlign: TextAlign.center),
      ),
    );
  }
}
