import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_text_styles.dart';
import '../../../../theme/manah_tokens.dart';
import '../../../scoring/domain/scoring_entities.dart';
import '../../domain/group_entities.dart';
import '../../domain/group_leaderboard.dart';
import '../group_scoring_providers.dart';
import '../group_scoring_routes.dart';

/// Session leaderboard (Sprint 07) — the closing act of the walking skeleton.
///
/// It ranks the board *fairly* (task 7.1: total → X → 10, no time tiebreak —
/// the whistle is honoured so the order is honest), labels the leader "memimpin
/// sementara · N/M rambahan" while the session is still in flight, and lets the
/// host tap any row to **drill into that archer's round-by-round detail** (task
/// 7.3 — the quiet referee that ends "salah ketik" disputes).
///
/// There is **no live polling** here (that is Phase 1, Sprint 11). It watches
/// [hostBoardControllerProvider], so it refreshes the instant a round is saved,
/// and offers **pull-to-refresh** to retry sync + reload from local storage
/// (task 7.2). From here the host shares the DNF-friendly result card.
class GroupLeaderboardScreen extends ConsumerWidget {
  const GroupLeaderboardScreen({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(hostBoardControllerProvider(groupId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Papan Peringkat'),
        actions: [
          IconButton(
            tooltip: 'Bagikan kartu hasil',
            icon: const Icon(Icons.ios_share),
            onPressed: async.hasValue
                ? () => context.push(GroupScoringRoutes.resultCard(groupId))
                : null,
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _LeaderboardError(message: '$e'),
        data: (state) {
          final leaderboard = buildGroupLeaderboard(
            participants: state.participants,
            numEnds: state.group.numEnds,
            arrowsPerEnd: state.group.arrowsPerEnd,
          );
          return RefreshIndicator(
            onRefresh: () => ref
                .read(hostBoardControllerProvider(groupId).notifier)
                .syncNow(),
            child: leaderboard.entries.isEmpty
                ? const _EmptyLeaderboard()
                : ListView(
                    padding: const EdgeInsets.all(ManahSpacing.base),
                    children: [
                      _ProgressBanner(leaderboard: leaderboard),
                      const SizedBox(height: ManahSpacing.base),
                      for (final entry in leaderboard.entries)
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: ManahSpacing.sm),
                          child: _LeaderboardRow(
                            entry: entry,
                            group: state.group,
                            onTap: () => _showDrillDown(
                              context,
                              state.group,
                              entry,
                            ),
                          ),
                        ),
                      const SizedBox(height: ManahSpacing.base),
                      FilledButton.icon(
                        onPressed: () => context
                            .push(GroupScoringRoutes.resultCard(groupId)),
                        icon: const Icon(Icons.ios_share),
                        label: const Text('Bagikan Kartu Hasil'),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  void _showDrillDown(
    BuildContext context,
    ScoringGroupEntity group,
    GroupLeaderboardEntry entry,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _DrillDownSheet(group: group, entry: entry),
    );
  }
}

/// Whistle-aware progress banner (task 7.1) — "memimpin sementara · N/M
/// rambahan" while in flight, or a calm "Sesi selesai" once everyone's done.
class _ProgressBanner extends StatelessWidget {
  const _ProgressBanner({required this.leaderboard});

  final GroupLeaderboard leaderboard;

  @override
  Widget build(BuildContext context) {
    final inProgress = leaderboard.inProgress;
    final leader = leaderboard.leader;
    final leaderName = leader?.participant.labelOr('Saya') ?? '—';
    final color = inProgress ? ManahColors.amberDeep : ManahColors.success;
    return Container(
      padding: const EdgeInsets.all(ManahSpacing.base),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(ManahRadius.md),
      ),
      child: Row(
        children: [
          Icon(inProgress ? Icons.timelapse : Icons.emoji_events, color: color),
          const SizedBox(width: ManahSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  inProgress
                      ? '$leaderName memimpin sementara'
                      : '$leaderName juara sesi',
                  style: ManahTextStyles.bodyM
                      .copyWith(fontWeight: FontWeight.bold, color: color),
                ),
                Text(
                  inProgress
                      ? '${leaderboard.roundsShot}/${leaderboard.numEnds} rambahan · papan masih berjalan'
                      : 'Semua rambahan tuntas · urutan final',
                  style: ManahTextStyles.bodyS
                      .copyWith(color: ManahColors.mediumGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({
    required this.entry,
    required this.group,
    required this.onTap,
  });

  final GroupLeaderboardEntry entry;
  final ScoringGroupEntity group;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = entry.participant;
    final name = p.labelOr('Saya');
    final podium = entry.rank <= 3;

    // DNF-friendly score (task 7.4): never a shaming 0.
    final String scoreText;
    final String? statusText;
    if (!entry.hasStarted) {
      scoreText = '—';
      statusText = 'belum mulai';
    } else if (!entry.isComplete) {
      scoreText = '${p.totalScore}';
      statusText = 'belum selesai · ${p.endsShot}/${group.numEnds}';
    } else {
      scoreText = '${p.totalScore}';
      statusText = null;
    }

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ManahRadius.md),
        side: BorderSide(
          color: podium
              ? ManahColors.brand.withValues(alpha: 0.4)
              : theme.dividerColor.withValues(alpha: 0.12),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: _RankBadge(rank: entry.rank),
        title: Row(
          children: [
            Flexible(
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: ManahSpacing.xs),
            if (p.isGuest) _Tag(label: 'Tamu', color: ManahColors.mediumGrey),
          ],
        ),
        subtitle: Text(
          statusText ??
              'X ${p.xCount} · 10 ${p.tenCount} · ${p.arrowsShot} panah',
          style: ManahTextStyles.bodyS.copyWith(
            color: statusText != null
                ? ManahColors.amberDeep
                : ManahColors.mediumGrey,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              scoreText,
              style: ManahTextStyles.h3.copyWith(
                color: entry.hasStarted
                    ? ManahColors.brand
                    : ManahColors.mediumGrey,
              ),
            ),
            const Icon(Icons.chevron_right,
                size: 16, color: ManahColors.mediumGrey),
          ],
        ),
      ),
    );
  }
}

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    final medal = switch (rank) {
      1 => '🥇',
      2 => '🥈',
      3 => '🥉',
      _ => null,
    };
    if (medal != null) {
      return SizedBox(
        width: 40,
        child: Center(child: Text(medal, style: const TextStyle(fontSize: 24))),
      );
    }
    return SizedBox(
      width: 40,
      child: Center(
        child: Text(
          '$rank',
          style: ManahTextStyles.h3.copyWith(color: ManahColors.mediumGrey),
        ),
      ),
    );
  }
}

/// Round-by-round breakdown for one archer (task 7.3) — the transparency that
/// settles "salah ketik" disputes on the spot.
class _DrillDownSheet extends StatelessWidget {
  const _DrillDownSheet({required this.group, required this.entry});

  final ScoringGroupEntity group;
  final GroupLeaderboardEntry entry;

  @override
  Widget build(BuildContext context) {
    final p = entry.participant;
    final name = p.labelOr('Saya');
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            ManahSpacing.base, 0, ManahSpacing.base, ManahSpacing.base),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: ManahTextStyles.h3,
                  ),
                ),
                Text(
                  'Total ${p.totalScore}',
                  style: ManahTextStyles.h3.copyWith(color: ManahColors.brand),
                ),
              ],
            ),
            Text(
              'X ${p.xCount} · 10 ${p.tenCount} · ${p.arrowsShot} panah'
              '${entry.isComplete ? '' : ' · belum selesai'}',
              style:
                  ManahTextStyles.bodyS.copyWith(color: ManahColors.mediumGrey),
            ),
            const SizedBox(height: ManahSpacing.base),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (var end = 1; end <= group.numEnds; end++)
                    _EndRow(
                      endNumber: end,
                      arrows: p.arrowsForEnd(end),
                      arrowsPerEnd: group.arrowsPerEnd,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EndRow extends StatelessWidget {
  const _EndRow({
    required this.endNumber,
    required this.arrows,
    required this.arrowsPerEnd,
  });

  final int endNumber;
  final List<ArrowScore> arrows;
  final int arrowsPerEnd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shot = arrows.isNotEmpty;
    final endTotal = arrows.fold<int>(0, (s, a) => s + a.scoreValue);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: Text(
              'R$endNumber',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                if (!shot)
                  Text(
                    'belum ditembak',
                    style: ManahTextStyles.bodyS
                        .copyWith(color: ManahColors.mediumGrey),
                  )
                else
                  for (final a in arrows)
                    Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: (theme.brightness == Brightness.dark
                            ? Colors.grey[900]
                            : Colors.grey[100]),
                        borderRadius: BorderRadius.circular(ManahRadius.sm),
                      ),
                      child: Text(
                        a.displayValue,
                        style: ManahTextStyles.number.copyWith(
                          fontSize: 14,
                          color: ManahColors.forScore(
                            a.scoreValue,
                            isX: a.isX,
                            isMiss: a.isMiss,
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ),
          const SizedBox(width: ManahSpacing.sm),
          SizedBox(
            width: 32,
            child: Text(
              shot ? '$endTotal' : '—',
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(ManahRadius.full),
      ),
      child: Text(
        label,
        style:
            TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _EmptyLeaderboard extends StatelessWidget {
  const _EmptyLeaderboard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      // Keep it scrollable so pull-to-refresh still works when empty.
      children: [
        const SizedBox(height: 120),
        Icon(Icons.leaderboard_outlined, size: 64, color: theme.disabledColor),
        const SizedBox(height: ManahSpacing.base),
        Text(
          'Papan peringkat masih kosong',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: ManahSpacing.sm),
        Text(
          'Tambahkan pemain dan catat rambahan untuk melihat peringkat.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.textTheme.bodySmall?.color),
        ),
      ],
    );
  }
}

class _LeaderboardError extends StatelessWidget {
  const _LeaderboardError({required this.message});

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
            Text('Gagal memuat papan peringkat.\n$message',
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
