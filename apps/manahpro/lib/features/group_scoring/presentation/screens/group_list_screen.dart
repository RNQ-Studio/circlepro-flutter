import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_tokens.dart';
import '../../../scoring/domain/scoring_enums.dart';
import '../../domain/group_entities.dart';
import '../group_scoring_providers.dart';
import '../group_scoring_routes.dart';

/// Entry point for Latihan Bersama: the groups the user hosts or joined
/// (local-first, refreshed online — task 4.5). Tapping a group opens the host
/// board (Sprint 05) to score the roster end-by-end.
class GroupListScreen extends ConsumerWidget {
  const GroupListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(groupsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan Bersama'),
        actions: [
          IconButton(
            tooltip: 'Gabung dengan kode',
            onPressed: () => context.push(GroupScoringRoutes.joinByCode),
            icon: const Icon(Icons.login),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(GroupScoringRoutes.create),
        icon: const Icon(Icons.add),
        label: const Text('Buat Sesi'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(groupsListProvider),
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) =>
              _ErrorState(onRetry: () => ref.invalidate(groupsListProvider)),
          data: (groups) {
            if (groups.isEmpty) return const _EmptyState();
            return ListView.separated(
              padding: const EdgeInsets.all(ManahSpacing.base),
              itemCount: groups.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: ManahSpacing.sm),
              itemBuilder: (context, i) => _GroupCard(group: groups[i]),
            );
          },
        ),
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.group});

  final ScoringGroupEntity group;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ManahRadius.md),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        // Open the session hub (Sprint 06): roster, running scores, share &
        // quick-add — the board is one tap further in.
        onTap: () => context.push(GroupScoringRoutes.detail(group.id)),
        title: Text(
          group.title?.isNotEmpty == true ? group.title! : 'Latihan Bersama',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${group.roundPresetLabel ?? '${group.distanceM} m'} · '
          '${group.countedEndCount}×${group.arrowsPerEnd} · '
          '${group.participantCount} peserta',
        ),
        leading: CircleAvatar(
          backgroundColor: ManahColors.brandSurface,
          child: Text(
            group.joinCode.isNotEmpty ? group.joinCode.substring(0, 1) : '?',
            style: const TextStyle(
                color: ManahColors.brand, fontWeight: FontWeight.bold),
          ),
        ),
        trailing: _StatusChip(status: group.status),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final ScoringSessionStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      ScoringSessionStatus.inProgress => ('Berlangsung', ManahColors.brand),
      ScoringSessionStatus.completed => ('Selesai', ManahColors.amberDeep),
      ScoringSessionStatus.abandoned => ('Dibatalkan', ManahColors.error),
    };
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: ManahSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(ManahRadius.full),
      ),
      child: Text(
        label,
        style:
            TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      // ListView (not Center) keeps RefreshIndicator pull-to-refresh working.
      padding: const EdgeInsets.all(ManahSpacing.xl),
      children: [
        const SizedBox(height: ManahSpacing.xxl),
        Icon(Icons.groups_outlined, size: 64, color: theme.disabledColor),
        const SizedBox(height: ManahSpacing.base),
        Text(
          'Belum ada Latihan Bersama',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: ManahSpacing.sm),
        Text(
          'Buat sesi, bagikan kodenya, dan catat skor satu papan bersama teman-teman.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.textTheme.bodySmall?.color),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(ManahSpacing.xl),
      children: [
        const SizedBox(height: ManahSpacing.xxl),
        const Icon(Icons.cloud_off, size: 64, color: Colors.grey),
        const SizedBox(height: ManahSpacing.base),
        const Text('Gagal memuat sesi.', textAlign: TextAlign.center),
        const SizedBox(height: ManahSpacing.base),
        Center(
          child: OutlinedButton(
              onPressed: onRetry, child: const Text('Coba Lagi')),
        ),
      ],
    );
  }
}
