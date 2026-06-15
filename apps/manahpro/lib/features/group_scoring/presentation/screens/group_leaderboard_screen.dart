import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_text_styles.dart';
import '../../../../theme/manah_tokens.dart';
import '../../../scoring/domain/scoring_entities.dart';
import '../../../scoring/domain/scoring_enums.dart';
import '../../domain/board_participant_entity.dart';
import '../../domain/group_entities.dart';
import '../../domain/group_leaderboard.dart';
import '../../domain/group_live_leaderboard.dart';
import '../../domain/group_social_board.dart';
import '../group_scoring_providers.dart';
import '../group_scoring_routes.dart';

/// Session leaderboard — fair ranking + drill-down + share (Sprint 07), now
/// **live across devices** (Sprint 11).
///
/// The visible board comes from the server's fair aggregate ([liveLeaderboard
/// ControllerProvider]) so a score typed on another phone appears here within a
/// few seconds (task 11.5). Polling is **frugal & lifecycle-aware**: it runs
/// only while this screen is mounted and the session is `in_progress`, re-sends
/// the last `version` so an idle poll costs an empty payload, and stops the
/// moment the group is finished or the app is backgrounded (tasks 11.1/11.2).
///
/// We set honest expectations (task 11.4): the header says "papan diperbarui
/// otomatis · diperbarui X dtk lalu" — never a "live race". When the network is
/// down it falls back to the **offline local board** (Sprint 07) so the host
/// recording end-by-end never loses their view. Tapping a row drills into that
/// archer's round-by-round detail when this device holds it.
class GroupLeaderboardScreen extends ConsumerStatefulWidget {
  const GroupLeaderboardScreen({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState<GroupLeaderboardScreen> createState() =>
      _GroupLeaderboardScreenState();
}

class _GroupLeaderboardScreenState
    extends ConsumerState<GroupLeaderboardScreen> {
  late final AppLifecycleListener _lifecycle;

  /// Active bow-class chip filter (null = "Semua"). Local view state only — it
  /// never changes the fair ordering, just what the screen paints (task 12.2).
  BowClass? _classFilter;

  @override
  void initState() {
    super.initState();
    // Pause the poll when the app leaves the foreground, resume on return — the
    // field shouldn't drain a battery polling a screen no one is looking at.
    _lifecycle = AppLifecycleListener(onStateChange: _onAppLifecycle);
  }

  void _onAppLifecycle(AppLifecycleState state) {
    ref
        .read(liveLeaderboardControllerProvider(widget.groupId).notifier)
        .setAppActive(state == AppLifecycleState.resumed);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupId = widget.groupId;
    final localAsync = ref.watch(hostBoardControllerProvider(groupId));
    // Keep the poller mounted (it auto-disposes when this screen pops).
    final liveAsync = ref.watch(liveLeaderboardControllerProvider(groupId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Papan Peringkat'),
        actions: [
          IconButton(
            tooltip: 'Bagikan kartu hasil',
            icon: const Icon(Icons.ios_share),
            onPressed: localAsync.hasValue
                ? () => context.push(GroupScoringRoutes.resultCard(groupId))
                : null,
          ),
        ],
      ),
      body: localAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _LeaderboardError(message: '$e'),
        data: (local) {
          final live = liveAsync.value;
          // Prefer the server's fair multi-device board; fall back to the local
          // board only when the server is unreachable and we have nothing yet.
          final useLocal =
              live == null || (live.offline && live.entries.isEmpty);
          final board = useLocal
              ? _RenderBoard.fromLocal(local)
              : _RenderBoard.fromLive(live, local.group.numEnds);

          final localById = {for (final p in local.participants) p.id: p};

          // ★ "tertinggi di kelasmu" is computed over the *whole* board (before
          // any chip filter) and only for classes with ≥2 archers — so the mark
          // stays meaningful even while looking at a single-class view (12.3).
          final classLeaders =
              classLeaderSessionIds(board.rows.map((r) => r.social));
          final availableClasses =
              bowClassesOnBoard(board.rows.map((r) => r.social));
          final visibleRows =
              filterRowsByClass(board.rows, _classFilter, (r) => r.bowClass);

          return RefreshIndicator(
            onRefresh: () async {
              // Pull-to-refresh retries both layers: push local rows, then force
              // a fresh server board.
              await ref
                  .read(hostBoardControllerProvider(groupId).notifier)
                  .syncNow();
              await ref
                  .read(liveLeaderboardControllerProvider(groupId).notifier)
                  .refreshNow();
            },
            child: board.rows.isEmpty
                ? const _EmptyLeaderboard()
                : ListView(
                    padding: const EdgeInsets.all(ManahSpacing.base),
                    children: [
                      _FreshnessBar(board: board),
                      const SizedBox(height: ManahSpacing.sm),
                      _ProgressBanner(board: board),
                      if (availableClasses.length >= 2) ...[
                        const SizedBox(height: ManahSpacing.sm),
                        _ClassFilterChips(
                          classes: availableClasses,
                          selected: _classFilter,
                          onSelected: (c) => setState(() => _classFilter = c),
                        ),
                      ],
                      const SizedBox(height: ManahSpacing.base),
                      for (final row in visibleRows)
                        Padding(
                          key: ValueKey(row.sessionId),
                          padding:
                              const EdgeInsets.only(bottom: ManahSpacing.sm),
                          child: _AnimatedRankSlot(
                            rank: row.rank,
                            child: _LeaderboardRow(
                              row: row,
                              group: local.group,
                              isClassLeader:
                                  classLeaders.contains(row.sessionId),
                              onTap: () => _showDrillDown(
                                context,
                                local.group,
                                row,
                                localById[row.sessionId],
                              ),
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
    _BoardRow row,
    BoardParticipant? local,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => local != null && local.ends.isNotEmpty
          ? _DrillDownSheet(group: group, participant: local)
          : _AggregateSheet(group: group, row: row),
    );
  }
}

/// A render-ready leaderboard row, sourced from either the server's fair board
/// (live, multi-device) or the offline local board — the screen renders both the
/// same way so the view never depends on which layer answered.
class _BoardRow {
  const _BoardRow({
    required this.rank,
    required this.sessionId,
    required this.name,
    required this.isGuest,
    required this.totalScore,
    required this.xCount,
    required this.tenCount,
    required this.arrowsShot,
    required this.endsShot,
    required this.isComplete,
    this.bowClass,
    this.isProvisionalLeader = false,
  });

  final int rank;
  final String sessionId;
  final String name;
  final bool isGuest;
  final BowClass? bowClass;
  final int totalScore;
  final int xCount;
  final int tenCount;
  final int arrowsShot;
  final int endsShot;
  final bool isComplete;
  final bool isProvisionalLeader;

  bool get hasStarted => arrowsShot > 0;

  /// Adapts this row to the shape the pure social-board helpers reason about.
  SocialBoardRow get social =>
      (sessionId: sessionId, bowClass: bowClass, started: hasStarted);

  factory _BoardRow.fromLive(LiveLeaderboardEntry e) => _BoardRow(
        rank: e.rank,
        sessionId: e.sessionId,
        name: e.labelOr('Saya'),
        isGuest: e.isGuest,
        bowClass: e.bowClass,
        totalScore: e.totalScore,
        xCount: e.xCount,
        tenCount: e.tenCount,
        arrowsShot: e.arrowsShot,
        endsShot: e.validatedEnds,
        isComplete: e.isComplete,
        isProvisionalLeader: e.isProvisionalLeader,
      );

  factory _BoardRow.fromLocal(GroupLeaderboardEntry e) => _BoardRow(
        rank: e.rank,
        sessionId: e.participant.id,
        name: e.participant.labelOr('Saya'),
        isGuest: e.participant.isGuest,
        bowClass: e.participant.bowClass,
        totalScore: e.participant.totalScore,
        xCount: e.participant.xCount,
        tenCount: e.participant.tenCount,
        arrowsShot: e.participant.arrowsShot,
        endsShot: e.participant.endsShot,
        isComplete: e.isComplete,
      );
}

/// What the screen paints: ranked [rows] plus the whistle-aware progress and the
/// freshness/offline flags. Built from the server live state or the local board.
class _RenderBoard {
  const _RenderBoard({
    required this.rows,
    required this.numEnds,
    required this.roundsShot,
    required this.allCompleted,
    required this.offline,
    this.updatedAt,
  });

  final List<_BoardRow> rows;
  final int numEnds;
  final int roundsShot;
  final bool allCompleted;
  final bool offline;
  final DateTime? updatedAt;

  bool get inProgress => !allCompleted;

  String get leaderName => rows.isEmpty ? '—' : rows.first.name;

  factory _RenderBoard.fromLive(LiveLeaderboardState live, int numEnds) {
    return _RenderBoard(
      rows: [for (final e in live.entries) _BoardRow.fromLive(e)],
      numEnds: numEnds,
      roundsShot: live.roundsShot,
      allCompleted: live.allCompleted,
      offline: live.offline,
      updatedAt: live.updatedAt,
    );
  }

  factory _RenderBoard.fromLocal(HostBoardState local) {
    final lb = buildGroupLeaderboard(
      participants: local.participants,
      numEnds: local.group.numEnds,
      arrowsPerEnd: local.group.arrowsPerEnd,
    );
    return _RenderBoard(
      rows: [for (final e in lb.entries) _BoardRow.fromLocal(e)],
      numEnds: lb.numEnds,
      roundsShot: lb.roundsShot,
      allCompleted: lb.isComplete,
      offline: true,
    );
  }
}

/// Sets honest expectations (task 11.4): "papan diperbarui otomatis · diperbarui
/// X dtk lalu" — deliberately not "live race". Falls back to an offline notice
/// when we're showing the local board.
class _FreshnessBar extends StatelessWidget {
  const _FreshnessBar({required this.board});

  final _RenderBoard board;

  @override
  Widget build(BuildContext context) {
    final offline = board.offline;
    final color = offline ? ManahColors.mediumGrey : ManahColors.brand;
    final icon = offline ? Icons.cloud_off_outlined : Icons.autorenew;
    final text = offline
        ? 'Mode offline · menampilkan papan dari perangkat ini'
        : board.updatedAt != null
            ? 'Papan diperbarui otomatis · ${_ago(board.updatedAt!)}'
            : 'Papan diperbarui otomatis';

    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: ManahSpacing.xs),
        Expanded(
          child: Text(
            text,
            style: ManahTextStyles.bodyS.copyWith(color: color),
          ),
        ),
      ],
    );
  }

  static String _ago(DateTime t) {
    final seconds = DateTime.now().difference(t).inSeconds;
    if (seconds < 5) return 'baru saja';
    if (seconds < 60) return '$seconds dtk lalu';
    final minutes = seconds ~/ 60;
    if (minutes < 60) return '$minutes mnt lalu';
    return '${minutes ~/ 60} jam lalu';
  }
}

/// Whistle-aware progress banner (task 7.1) — "memimpin sementara · N/M
/// rambahan" while in flight, or a calm "Sesi selesai" once everyone's done.
class _ProgressBanner extends StatelessWidget {
  const _ProgressBanner({required this.board});

  final _RenderBoard board;

  @override
  Widget build(BuildContext context) {
    final inProgress = board.inProgress;
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
                      ? '${board.leaderName} memimpin sementara'
                      : '${board.leaderName} juara sesi',
                  style: ManahTextStyles.bodyM
                      .copyWith(fontWeight: FontWeight.bold, color: color),
                ),
                Text(
                  inProgress
                      ? '${board.roundsShot}/${board.numEnds} rambahan · papan masih berjalan'
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
    required this.row,
    required this.group,
    required this.isClassLeader,
    required this.onTap,
  });

  final _BoardRow row;
  final ScoringGroupEntity group;

  /// ★ "tertinggi di kelasmu" — only set when this row's class has ≥2 archers
  /// (task 12.3); otherwise we never crown a "juara dari 1".
  final bool isClassLeader;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final podium = row.rank <= 3;

    // DNF-friendly score (task 7.4): never a shaming 0.
    final String scoreText;
    final String? statusText;
    if (!row.hasStarted) {
      scoreText = '—';
      statusText = 'belum mulai';
    } else if (!row.isComplete) {
      scoreText = '${row.totalScore}';
      statusText = 'belum selesai · ${row.endsShot}/${group.numEnds}';
    } else {
      scoreText = '${row.totalScore}';
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
        leading: _RankBadge(rank: row.rank),
        // Wrap (not Row) so the class badge + ★ + Tamu/Memimpin tags fold to a
        // second line on narrow phones instead of overflowing (12.1).
        title: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: ManahSpacing.xs,
          runSpacing: 2,
          children: [
            Text(
              row.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (isClassLeader)
              const Tooltip(
                message: 'Tertinggi di kelasnya',
                child: Text('★', style: TextStyle(color: ManahColors.amber)),
              ),
            if (row.bowClass != null)
              _Tag(label: row.bowClass!.label, color: ManahColors.brand),
            if (row.isGuest) _Tag(label: 'Tamu', color: ManahColors.mediumGrey),
            if (row.isProvisionalLeader)
              _Tag(label: 'Memimpin', color: ManahColors.amberDeep),
          ],
        ),
        subtitle: Text(
          statusText ??
              'X ${row.xCount} · 10 ${row.tenCount} · ${row.arrowsShot} panah',
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
                color:
                    row.hasStarted ? ManahColors.brand : ManahColors.mediumGrey,
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
/// settles "salah ketik" disputes on the spot. Only available for rows this
/// device recorded; a row scored on another phone shows the aggregate sheet.
class _DrillDownSheet extends StatelessWidget {
  const _DrillDownSheet({required this.group, required this.participant});

  final ScoringGroupEntity group;
  final BoardParticipant participant;

  @override
  Widget build(BuildContext context) {
    final p = participant;
    final name = p.labelOr('Saya');
    final isComplete =
        group.plannedArrows > 0 && p.arrowsShot >= group.plannedArrows;
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
                Expanded(child: Text(name, style: ManahTextStyles.h3)),
                Text(
                  'Total ${p.totalScore}',
                  style: ManahTextStyles.h3.copyWith(color: ManahColors.brand),
                ),
              ],
            ),
            Text(
              'X ${p.xCount} · 10 ${p.tenCount} · ${p.arrowsShot} panah'
              '${isComplete ? '' : ' · belum selesai'}',
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

/// Aggregate-only sheet for a row whose per-arrow detail lives on another device
/// (Sprint 11). We show the honest totals and say where the detail is, rather
/// than pretend we have arrows we never recorded.
class _AggregateSheet extends StatelessWidget {
  const _AggregateSheet({required this.group, required this.row});

  final ScoringGroupEntity group;
  final _BoardRow row;

  @override
  Widget build(BuildContext context) {
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
                Expanded(child: Text(row.name, style: ManahTextStyles.h3)),
                Text(
                  row.hasStarted ? 'Total ${row.totalScore}' : '—',
                  style: ManahTextStyles.h3.copyWith(color: ManahColors.brand),
                ),
              ],
            ),
            Text(
              'X ${row.xCount} · 10 ${row.tenCount} · ${row.arrowsShot} panah'
              '${row.isComplete ? '' : ' · ${row.endsShot}/${group.numEnds} rambahan'}',
              style:
                  ManahTextStyles.bodyS.copyWith(color: ManahColors.mediumGrey),
            ),
            const SizedBox(height: ManahSpacing.base),
            Container(
              padding: const EdgeInsets.all(ManahSpacing.base),
              decoration: BoxDecoration(
                color: ManahColors.mediumGrey.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(ManahRadius.md),
              ),
              child: Row(
                children: [
                  const Icon(Icons.devices_other,
                      size: 18, color: ManahColors.mediumGrey),
                  const SizedBox(width: ManahSpacing.sm),
                  Expanded(
                    child: Text(
                      'Rincian per-rambahan dicatat di perangkat pemanah ini.',
                      style: ManahTextStyles.bodyS
                          .copyWith(color: ManahColors.mediumGrey),
                    ),
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

/// Bow-class chip filter (task 12.2). One **single** board for everyone — the
/// chips only narrow the *view*, never the ranking. Built from a facet list
/// ([classes]) so Fase 3 can drop distance/bantalan chips in beside these
/// without touching row rendering.
class _ClassFilterChips extends StatelessWidget {
  const _ClassFilterChips({
    required this.classes,
    required this.selected,
    required this.onSelected,
  });

  final List<BowClass> classes;
  final BowClass? selected;
  final ValueChanged<BowClass?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _chip(label: 'Semua', isSelected: selected == null, value: null),
          for (final c in classes)
            _chip(label: c.label, isSelected: selected == c, value: c),
        ],
      ),
    );
  }

  Widget _chip({
    required String label,
    required bool isSelected,
    required BowClass? value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: ManahSpacing.xs),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        // Re-tapping the active class clears back to "Semua".
        onSelected: (_) => onSelected(isSelected ? null : value),
      ),
    );
  }
}

/// Settles a row into its slot with a gentle slide+fade whenever its [rank]
/// changes (task 12.5). The ordering is already fair (Sprint 03), so the motion
/// is honest — it just shows the change rather than snapping. Keyed by rank so a
/// new rank restarts the tween; otherwise it's a no-cost static row (60fps).
class _AnimatedRankSlot extends StatelessWidget {
  const _AnimatedRankSlot({required this.rank, required this.child});

  final int rank;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(rank),
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      child: child,
      builder: (context, t, child) => Transform.translate(
        offset: Offset(0, (1 - t) * 6),
        child: Opacity(opacity: 0.4 + 0.6 * t, child: child),
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
