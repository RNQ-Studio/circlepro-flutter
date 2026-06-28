import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:features_shared/features_shared.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/api/manah_api.dart';
import '../../scoring/domain/scoring_entities.dart';
import '../../scoring/domain/scoring_enums.dart';
import '../../scoring/presentation/scoring_providers.dart';
import '../data/group_scoring_repository_impl.dart';
import '../data/local/group_scoring_local_data_source.dart';
import '../data/pending_join_store.dart';
import '../data/remote/group_scoring_remote_data_source.dart';
import '../domain/board_participant_entity.dart';
import '../domain/group_claim.dart';
import '../domain/group_entities.dart';
import '../domain/group_live_leaderboard.dart';
import '../domain/group_scoring_repository.dart';

part 'group_scoring_providers.g.dart';

@Riverpod(keepAlive: true)
GroupScoringRemoteDataSource _groupRemoteDataSource(Ref ref) {
  return GroupScoringRemoteDataSource(ref.watch(manahDioProvider));
}

@Riverpod(keepAlive: true)
GroupScoringLocalDataSource _groupLocalDataSource(Ref ref) {
  // Reuse the shared scoring Drift DB (Sprint 04 decision, task 4.2).
  return GroupScoringLocalDataSource(ref.watch(scoringDatabaseProvider));
}

@Riverpod(keepAlive: true)
GroupScoringRepository groupScoringRepository(Ref ref) {
  return GroupScoringRepositoryImpl(
    ref.watch(_groupRemoteDataSourceProvider),
    ref.watch(_groupLocalDataSourceProvider),
  );
}

/// Groups the user hosts or participates in (local-first, refreshed online).
@riverpod
Future<List<ScoringGroupEntity>> groupsList(Ref ref) {
  return ref.watch(groupScoringRepositoryProvider).getGroups();
}

/// A single group with its roster (local-first, refreshed online).
@riverpod
Future<ScoringGroupEntity?> groupDetail(Ref ref, String groupId) {
  return ref.watch(groupScoringRepositoryProvider).getGroup(groupId);
}

/// Preview a group by its join code before joining (online-only lookup, full
/// round format — Sprint 09, tasks 9.2/9.6). Every entry point (deep link, QR,
/// typed code) funnels through this so the join preview is identical.
@riverpod
Future<ScoringGroupEntity> joinPreview(Ref ref, String joinCode) {
  return ref.watch(groupScoringRepositoryProvider).lookup(joinCode);
}

/// Persists a pending join code across an unauthenticated gap so a deferred deep
/// link resumes after register/login (Sprint 09, task 9.4).
@Riverpod(keepAlive: true)
PendingJoinStore pendingJoinStore(Ref ref) {
  return PendingJoinStore(ref.watch(storageServiceProvider));
}

// ─── Claim ("Ini Saya") — Sprint 14, Phase 2 ───────────────────────────────

/// Guest slots of a group a code-holder may claim (task 14.1). Online-only —
/// the deep-link landing needs the live truth; each slot carries this user's own
/// claim status so the badge ("Menunggu persetujuan host") needs no extra call.
@riverpod
Future<List<ClaimableSlot>> claimableSlots(Ref ref, String groupId) {
  return ref.watch(groupScoringRepositoryProvider).claimableSlots(groupId);
}

/// The host inbox of claims to review for a group (task 14.3).
@riverpod
Future<List<HostClaim>> hostClaims(Ref ref, String groupId) {
  return ref.watch(groupScoringRepositoryProvider).hostClaims(groupId);
}

/// Immutable state of the host board: the group (round format) plus its
/// participants with locally-stored ends.
class HostBoardState extends Equatable {
  const HostBoardState({required this.group, required this.participants});

  final ScoringGroupEntity group;
  final List<BoardParticipant> participants;

  /// Participants whose latest local write hasn't reached the server yet.
  int get pendingSyncCount => participants.where((p) => !p.isSynced).length;

  HostBoardState copyWith({List<BoardParticipant>? participants}) {
    return HostBoardState(
      group: group,
      participants: participants ?? this.participants,
    );
  }

  @override
  List<Object?> get props => [group, participants];
}

/// Drives the host board (Sprint 05): loads the group + participants, adds
/// guests, and saves each round offline-first (the repository persists locally
/// then syncs in the background). The screen only ever talks to this notifier.
@riverpod
class HostBoardController extends _$HostBoardController {
  @override
  Future<HostBoardState> build(String groupId) async {
    final repo = ref.watch(groupScoringRepositoryProvider);
    final group = await repo.getGroup(groupId);
    if (group == null) {
      throw StateError('Sesi tidak ditemukan');
    }
    final participants = await repo.loadBoard(group);
    return HostBoardState(group: group, participants: participants);
  }

  /// Add a guest by name (minimal add — Sprint 05).
  Future<void> addGuest(String name) async {
    final current = state.value;
    if (current == null) return;
    final repo = ref.read(groupScoringRepositoryProvider);
    final participants = await repo.addGuest(current.group, name);
    state = AsyncData(current.copyWith(participants: participants));
  }

  /// Quick-add several guests at once (Sprint 06, task 6.1) — one batch, one
  /// background sync. Blank names are ignored downstream.
  Future<void> addGuests(List<String> names) async {
    final current = state.value;
    if (current == null) return;
    final repo = ref.read(groupScoringRepositoryProvider);
    final participants = await repo.addGuests(current.group, names);
    state = AsyncData(current.copyWith(participants: participants));
  }

  /// Persist one round across the given participants (keyed by session id),
  /// offline-first. Never throws on a dead network — the save lands locally.
  /// [sync] may be false to defer the background push (self-scoring saves each
  /// arrow crash-safe and only pushes once the end is complete).
  Future<void> saveEnd(
    int endNumber,
    Map<String, List<ArrowScore>> arrowsByParticipantId, {
    bool sync = true,
  }) async {
    final current = state.value;
    if (current == null) return;
    final repo = ref.read(groupScoringRepositoryProvider);
    final participants = await repo.saveEnd(
      group: current.group,
      endNumber: endNumber,
      arrowsByParticipantId: arrowsByParticipantId,
      sync: sync,
    );
    state = AsyncData(current.copyWith(participants: participants));
  }

  /// Leave the session by removing my own row (Sprint 10, task 10.5). Removes it
  /// on the server and locally, then drops it from the board state.
  Future<void> leave(String sessionId) async {
    final current = state.value;
    if (current == null) return;
    final repo = ref.read(groupScoringRepositoryProvider);
    await repo.leaveGroup(current.group.id, sessionId);
    final participants = await repo.loadBoard(current.group);
    state = AsyncData(current.copyWith(participants: participants));
    ref.invalidate(groupsListProvider);
  }

  /// Manually retry syncing unsynced rows (e.g. when signal returns), then
  /// refresh the board from local storage.
  Future<void> syncNow() async {
    final current = state.value;
    if (current == null) return;
    final repo = ref.read(groupScoringRepositoryProvider);
    await repo.syncBoard(current.group);
    final participants = await repo.loadBoard(current.group);
    state = AsyncData(current.copyWith(participants: participants));
  }
}

/// Immutable state of the live, server-polled leaderboard (Sprint 11). It holds
/// the last fair board fetched from the backend (the multi-device truth) plus
/// the polling cursor and freshness so the screen can show "diperbarui X dtk
/// lalu" without over-promising a "live race" (task 11.4).
class LiveLeaderboardState extends Equatable {
  const LiveLeaderboardState({
    this.entries = const [],
    this.version,
    this.groupStatus,
    this.allCompleted = false,
    this.isProvisional = false,
    this.comparableEnds = 0,
    this.targetEnds = 0,
    this.updatedAt,
    this.lastCheckedAt,
    this.offline = false,
  });

  /// The server-computed ranked rows (already fair: total → X → 10, K4).
  final List<LiveLeaderboardEntry> entries;

  /// The polling cursor last seen; re-sent so an idle poll returns empty.
  final String? version;

  /// Group lifecycle — once it leaves in_progress the poll stops (task 11.2).
  final ScoringSessionStatus? groupStatus;
  final bool allCompleted;
  final bool isProvisional;
  final int comparableEnds;
  final int targetEnds;

  /// When the board last actually changed — drives the freshness indicator.
  final DateTime? updatedAt;

  /// When the server was last polled (changed or not).
  final DateTime? lastCheckedAt;

  /// The last poll failed; the screen shows the offline local board instead.
  final bool offline;

  /// Still live and worth polling.
  bool get isLive => groupStatus == ScoringSessionStatus.inProgress;

  /// The current frontier: the furthest round any racer has validated.
  int get roundsShot =>
      entries.fold(0, (m, e) => e.validatedEnds > m ? e.validatedEnds : m);

  LiveLeaderboardState copyWith({
    List<LiveLeaderboardEntry>? entries,
    String? version,
    ScoringSessionStatus? groupStatus,
    bool? allCompleted,
    bool? isProvisional,
    int? comparableEnds,
    int? targetEnds,
    DateTime? updatedAt,
    DateTime? lastCheckedAt,
    bool? offline,
  }) {
    return LiveLeaderboardState(
      entries: entries ?? this.entries,
      version: version ?? this.version,
      groupStatus: groupStatus ?? this.groupStatus,
      allCompleted: allCompleted ?? this.allCompleted,
      isProvisional: isProvisional ?? this.isProvisional,
      comparableEnds: comparableEnds ?? this.comparableEnds,
      targetEnds: targetEnds ?? this.targetEnds,
      updatedAt: updatedAt ?? this.updatedAt,
      lastCheckedAt: lastCheckedAt ?? this.lastCheckedAt,
      offline: offline ?? this.offline,
    );
  }

  @override
  List<Object?> get props => [
        entries,
        version,
        groupStatus,
        allCompleted,
        isProvisional,
        comparableEnds,
        targetEnds,
        updatedAt,
        lastCheckedAt,
        offline,
      ];
}

/// Lifecycle-aware live leaderboard poller (Sprint 11, tasks 11.1/11.2).
///
/// It polls the server leaderboard every [pollInterval] **only while** the live
/// screen is mounted (the provider auto-disposes on pop) and the session is
/// `in_progress`; it stops the moment the group is finished/abandoned (even by
/// another device) or the app is backgrounded (task 11.2). Each poll re-sends
/// the last [version] so the server can short-circuit to an empty payload when
/// nothing changed — no battery/bandwidth drain when idle (DoD). A failed poll
/// is non-fatal: the screen falls back to the offline local board and the poll
/// keeps retrying until signal returns.
@riverpod
class LiveLeaderboardController extends _$LiveLeaderboardController {
  Timer? _timer;
  bool _appPaused = false;

  static const Duration pollInterval = Duration(seconds: 5);

  @override
  Future<LiveLeaderboardState> build(String groupId) async {
    ref.onDispose(() {
      _timer?.cancel();
      _timer = null;
    });

    final repo = ref.read(groupScoringRepositoryProvider);
    LiveLeaderboardState initial;
    try {
      final snapshot = await repo.fetchLeaderboard(groupId);
      initial = _merge(const LiveLeaderboardState(), snapshot, DateTime.now());
    } catch (_) {
      // Offline at open: learn the lifecycle from cache so we still know whether
      // to keep polling, and let the screen render the local board meanwhile.
      final group = await repo.getGroup(groupId);
      initial = LiveLeaderboardState(
        groupStatus: group?.status,
        offline: true,
        lastCheckedAt: DateTime.now(),
      );
    }

    _syncTimer(initial);
    return initial;
  }

  /// Fold a fresh server snapshot into the running state. An `unchanged` reply
  /// keeps the previous board (and its `updatedAt`) — only the freshness clock
  /// moves, so an idle session never re-paints stale "updated now".
  LiveLeaderboardState _merge(
    LiveLeaderboardState previous,
    LiveLeaderboardSnapshot snapshot,
    DateTime now,
  ) {
    if (snapshot.unchanged) {
      return previous.copyWith(
        version: snapshot.version,
        lastCheckedAt: now,
        offline: false,
      );
    }
    return LiveLeaderboardState(
      entries: snapshot.entries,
      version: snapshot.version,
      groupStatus: snapshot.groupStatus ?? previous.groupStatus,
      allCompleted: snapshot.allCompleted,
      isProvisional: snapshot.isProvisional,
      comparableEnds: snapshot.comparableEnds,
      targetEnds: snapshot.targetEnds,
      updatedAt: now,
      lastCheckedAt: now,
    );
  }

  /// Start the timer when live & foregrounded; cancel it otherwise.
  void _syncTimer(LiveLeaderboardState state) {
    if (state.isLive && !_appPaused) {
      _timer ??= Timer.periodic(pollInterval, (_) => _poll());
    } else {
      _timer?.cancel();
      _timer = null;
    }
  }

  Future<void> _poll() async {
    final current = state.value;
    if (current == null) return;
    if (!current.isLive) {
      _syncTimer(current);
      return;
    }
    final repo = ref.read(groupScoringRepositoryProvider);
    try {
      final snapshot =
          await repo.fetchLeaderboard(groupId, version: current.version);
      final next = _merge(current, snapshot, DateTime.now());
      state = AsyncData(next);
      _syncTimer(next);
    } catch (_) {
      // Flaky field signal — keep the last board, flag offline, retry next tick.
      state = AsyncData(current.copyWith(
        offline: true,
        lastCheckedAt: DateTime.now(),
      ));
    }
  }

  /// Pull-to-refresh / manual retry: force a full fetch (no cursor) so the board
  /// is guaranteed fresh, then resume the timer as appropriate.
  Future<void> refreshNow() async {
    final repo = ref.read(groupScoringRepositoryProvider);
    final base = state.value ?? const LiveLeaderboardState();
    try {
      final snapshot = await repo.fetchLeaderboard(groupId);
      final next = _merge(base, snapshot, DateTime.now());
      state = AsyncData(next);
      _syncTimer(next);
    } catch (_) {
      state = AsyncData(base.copyWith(
        offline: true,
        lastCheckedAt: DateTime.now(),
      ));
    }
  }

  /// Pause polling when the app is backgrounded, resume (and poll once) when it
  /// returns — the screen wires this to an [AppLifecycleListener] (task 11.2).
  void setAppActive(bool active) {
    _appPaused = !active;
    final current = state.value;
    if (current == null) return;
    _syncTimer(current);
    if (active && current.isLive) {
      unawaited(_poll());
    }
  }
}

/// Compact per-bantalan monitor state (Sprint 19). It deliberately mirrors the
/// live leaderboard cursor contract: a stable [version] means the next poll can
/// be cheap, while [butts] keeps the last visible board when the backend replies
/// unchanged.
class ButtStatusState extends Equatable {
  const ButtStatusState({
    this.butts = const [],
    this.version,
    this.groupStatus,
    this.participantCount = 0,
    this.buttCount = 0,
    this.updatedAt,
    this.lastCheckedAt,
    this.offline = false,
  });

  final List<GroupButtEntity> butts;
  final String? version;
  final ScoringSessionStatus? groupStatus;
  final int participantCount;
  final int buttCount;
  final DateTime? updatedAt;
  final DateTime? lastCheckedAt;
  final bool offline;

  bool get isLive => groupStatus == ScoringSessionStatus.inProgress;

  int get laggingCount => butts.where((b) => b.isLagging).length;

  ButtStatusState copyWith({
    List<GroupButtEntity>? butts,
    String? version,
    ScoringSessionStatus? groupStatus,
    int? participantCount,
    int? buttCount,
    DateTime? updatedAt,
    DateTime? lastCheckedAt,
    bool? offline,
  }) {
    return ButtStatusState(
      butts: butts ?? this.butts,
      version: version ?? this.version,
      groupStatus: groupStatus ?? this.groupStatus,
      participantCount: participantCount ?? this.participantCount,
      buttCount: buttCount ?? this.buttCount,
      updatedAt: updatedAt ?? this.updatedAt,
      lastCheckedAt: lastCheckedAt ?? this.lastCheckedAt,
      offline: offline ?? this.offline,
    );
  }

  @override
  List<Object?> get props => [
        butts,
        version,
        groupStatus,
        participantCount,
        buttCount,
        updatedAt,
        lastCheckedAt,
        offline,
      ];
}

@riverpod
class ButtStatusController extends _$ButtStatusController {
  Timer? _timer;
  bool _appPaused = false;

  static const Duration pollInterval = Duration(seconds: 5);

  @override
  Future<ButtStatusState> build(String groupId) async {
    ref.onDispose(() {
      _timer?.cancel();
      _timer = null;
    });

    final repo = ref.read(groupScoringRepositoryProvider);
    ButtStatusState initial;
    try {
      final envelope = await repo.fetchButts(groupId);
      initial = _merge(const ButtStatusState(), envelope, DateTime.now());
    } catch (_) {
      final group = await repo.getGroup(groupId);
      initial = _cachedStateFromGroup(group, DateTime.now());
    }

    _syncTimer(initial);
    return initial;
  }

  ButtStatusState _cachedStateFromGroup(
    ScoringGroupEntity? group,
    DateTime now,
  ) {
    if (group == null) {
      return ButtStatusState(offline: true, lastCheckedAt: now);
    }

    final grouped = <int?, List<GroupParticipantEntity>>{};
    for (final participant in group.participants) {
      grouped.putIfAbsent(participant.targetButt, () => []).add(participant);
    }

    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        if (a == null) return 1;
        if (b == null) return -1;
        return a.compareTo(b);
      });

    final drafts = [
      for (final key in sortedKeys)
        _CachedButtDraft.fromParticipants(
          targetButt: key,
          participants: grouped[key]!,
          group: group,
        ),
    ];
    final maxProgress =
        drafts.where((draft) => draft.targetButt != null).fold<int>(
              0,
              (max, draft) => draft.endProgress > max ? draft.endProgress : max,
            );

    final butts = [
      for (final draft in drafts) draft.toEntity(maxProgress),
    ];

    return ButtStatusState(
      butts: butts,
      groupStatus: group.status,
      participantCount: group.participants.length,
      buttCount: grouped.keys.whereType<int>().length,
      lastCheckedAt: now,
      offline: true,
    );
  }

  ButtStatusState _merge(
    ButtStatusState previous,
    GroupButtStatusEnvelope envelope,
    DateTime now,
  ) {
    if (envelope.unchanged) {
      return previous.copyWith(
        version: envelope.version,
        lastCheckedAt: now,
        offline: false,
      );
    }
    return ButtStatusState(
      butts: envelope.butts,
      version: envelope.version,
      groupStatus: envelope.groupStatus ?? previous.groupStatus,
      participantCount: envelope.participantCount,
      buttCount: envelope.buttCount,
      updatedAt: now,
      lastCheckedAt: now,
    );
  }

  void _syncTimer(ButtStatusState status) {
    if (status.isLive && !_appPaused) {
      _timer ??= Timer.periodic(pollInterval, (_) => _poll());
    } else {
      _timer?.cancel();
      _timer = null;
    }
  }

  Future<void> _poll() async {
    final current = state.value;
    if (current == null) return;
    if (!current.isLive) {
      _syncTimer(current);
      return;
    }

    final repo = ref.read(groupScoringRepositoryProvider);
    try {
      final envelope = await repo.fetchButts(groupId, version: current.version);
      final next = _merge(current, envelope, DateTime.now());
      state = AsyncData(next);
      _syncTimer(next);
    } catch (_) {
      state = AsyncData(current.copyWith(
        offline: true,
        lastCheckedAt: DateTime.now(),
      ));
    }
  }

  Future<void> refreshNow() async {
    final repo = ref.read(groupScoringRepositoryProvider);
    final base = state.value ?? const ButtStatusState();
    try {
      final envelope = await repo.fetchButts(groupId);
      final next = _merge(base, envelope, DateTime.now());
      state = AsyncData(next);
      _syncTimer(next);
    } catch (_) {
      state = AsyncData(base.copyWith(
        offline: true,
        lastCheckedAt: DateTime.now(),
      ));
    }
  }

  Future<void> claimButt(int targetButt) async {
    final repo = ref.read(groupScoringRepositoryProvider);
    await repo.claimButt(groupId, targetButt);
    await refreshNow();
  }

  void setAppActive(bool active) {
    _appPaused = !active;
    final current = state.value;
    if (current == null) return;
    _syncTimer(current);
    if (active && current.isLive) {
      unawaited(_poll());
    }
  }
}

class _CachedButtDraft {
  const _CachedButtDraft({
    required this.targetButt,
    required this.participantCount,
    required this.completedCount,
    required this.submittedCount,
    required this.endProgress,
    required this.maxEndProgress,
    required this.targetEnds,
    required this.totalScore,
    required this.participants,
  });

  final int? targetButt;
  final int participantCount;
  final int completedCount;
  final int submittedCount;
  final int endProgress;
  final int maxEndProgress;
  final int targetEnds;
  final int totalScore;
  final List<GroupParticipantEntity> participants;

  factory _CachedButtDraft.fromParticipants({
    required int? targetButt,
    required List<GroupParticipantEntity> participants,
    required ScoringGroupEntity group,
  }) {
    final arrowsPerEnd = group.arrowsPerEnd <= 0 ? 1 : group.arrowsPerEnd;
    final progress = [
      for (final participant in participants)
        participant.arrowsShot ~/ arrowsPerEnd,
    ];
    final endProgress =
        progress.isEmpty ? 0 : progress.reduce((a, b) => a < b ? a : b);
    final maxEndProgress =
        progress.isEmpty ? 0 : progress.reduce((a, b) => a > b ? a : b);
    final completedCount = participants
        .where((p) => p.status == ScoringSessionStatus.completed)
        .length;
    final allComplete =
        participants.isNotEmpty && completedCount == participants.length;
    final submittedCount = allComplete
        ? participants.length
        : progress.where((value) => value > endProgress).length;

    return _CachedButtDraft(
      targetButt: targetButt,
      participantCount: participants.length,
      completedCount: completedCount,
      submittedCount: submittedCount,
      endProgress: endProgress,
      maxEndProgress: maxEndProgress,
      targetEnds: group.numEnds,
      totalScore: participants.fold<int>(
        0,
        (sum, participant) => sum + participant.totalScore,
      ),
      participants: participants,
    );
  }

  GroupButtEntity toEntity(int globalMaxProgress) {
    final complete = participantCount > 0 && completedCount == participantCount;
    final rawLag = globalMaxProgress - endProgress;
    final laggingByEnds = targetButt == null || rawLag < 0 ? 0 : rawLag;
    final pendingCount = participantCount - submittedCount;
    final currentEnd = targetEnds <= 0 || complete
        ? null
        : (endProgress + 1 > targetEnds ? targetEnds : endProgress + 1);

    return GroupButtEntity(
      targetButt: targetButt,
      participantCount: participantCount,
      completedCount: completedCount,
      submittedCount: submittedCount,
      pendingCount: pendingCount < 0 ? 0 : pendingCount,
      endProgress: endProgress,
      maxEndProgress: maxEndProgress,
      currentEnd: currentEnd,
      targetEnds: targetEnds,
      isComplete: complete,
      totalScore: totalScore,
      laggingByEnds: laggingByEnds,
      isLagging: laggingByEnds >= 2,
      participants: participants,
    );
  }
}
