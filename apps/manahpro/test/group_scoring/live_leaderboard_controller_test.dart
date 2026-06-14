import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:manahpro/features/group_scoring/domain/group_entities.dart';
import 'package:manahpro/features/group_scoring/domain/group_live_leaderboard.dart';
import 'package:manahpro/features/group_scoring/domain/group_scoring_repository.dart';
import 'package:manahpro/features/group_scoring/presentation/group_scoring_providers.dart';
import 'package:manahpro/features/scoring/domain/scoring_enums.dart';

class _MockRepo extends Mock implements GroupScoringRepository {}

LiveLeaderboardEntry _entry(String id, int total, {bool leader = false}) =>
    LiveLeaderboardEntry(
      rank: leader ? 1 : 2,
      sessionId: id,
      totalScore: total,
      xCount: 0,
      tenCount: 0,
      arrowsShot: 9,
      validatedEnds: 3,
      targetEnds: 6,
      comparableTotal: total,
      isComplete: false,
      tied: false,
      isProvisionalLeader: leader,
    );

LiveLeaderboardSnapshot _board(
  List<LiveLeaderboardEntry> entries, {
  required String version,
  ScoringSessionStatus status = ScoringSessionStatus.inProgress,
  bool allCompleted = false,
}) =>
    LiveLeaderboardSnapshot(
      version: version,
      unchanged: false,
      entries: entries,
      groupStatus: status,
      allCompleted: allCompleted,
    );

/// Sprint 11 — the lifecycle-aware poller is the heart of the sprint, so its
/// timing behaviour is exercised under [FakeAsync]: it must poll on a cadence,
/// re-send the version cursor, keep the board on an unchanged reply, and — the
/// battery promise — STOP the instant the group is finished or the app is
/// backgrounded.
void main() {
  late _MockRepo repo;

  ProviderContainer containerWith() {
    final c = ProviderContainer(
      overrides: [groupScoringRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(c.dispose);
    return c;
  }

  setUp(() => repo = _MockRepo());

  test('polls on a cadence, re-sends the version, and stops when completed',
      () {
    fakeAsync((async) {
      final responses = <LiveLeaderboardSnapshot>[
        _board([_entry('s1', 30, leader: true)], version: 'v1'),
        const LiveLeaderboardSnapshot(version: 'v1', unchanged: true),
        _board(
          [_entry('s1', 30, leader: true), _entry('s2', 20)],
          version: 'v2',
          status: ScoringSessionStatus.completed,
          allCompleted: true,
        ),
      ];
      final sentVersions = <String?>[];
      when(() => repo.fetchLeaderboard(any(), version: any(named: 'version')))
          .thenAnswer((invocation) async {
        sentVersions.add(invocation.namedArguments[#version] as String?);
        return responses.removeAt(0);
      });

      final container = containerWith();
      final sub = container.listen(
        liveLeaderboardControllerProvider('g1'),
        (_, __) {},
      );
      addTearDown(sub.close);
      async.flushMicrotasks();

      // Initial fetch (no cursor) renders the fair board.
      var state =
          container.read(liveLeaderboardControllerProvider('g1')).value!;
      expect(sentVersions, [null]);
      expect(state.entries, hasLength(1));
      expect(state.version, 'v1');
      expect(state.isLive, isTrue);
      final firstUpdatedAt = state.updatedAt;

      // After 5s it polls again, re-sending the last cursor; an unchanged reply
      // keeps the board (and its updatedAt) — only the freshness clock moves.
      async.elapse(const Duration(seconds: 5));
      async.flushMicrotasks();
      state = container.read(liveLeaderboardControllerProvider('g1')).value!;
      expect(sentVersions, [null, 'v1']);
      expect(state.entries, hasLength(1));
      expect(state.updatedAt, firstUpdatedAt);
      expect(state.lastCheckedAt, isNotNull);

      // Next poll returns the finished board → the poller stops.
      async.elapse(const Duration(seconds: 5));
      async.flushMicrotasks();
      state = container.read(liveLeaderboardControllerProvider('g1')).value!;
      expect(sentVersions, [null, 'v1', 'v1']);
      expect(state.entries, hasLength(2));
      expect(state.isLive, isFalse);

      // No further polling once completed — even after a long idle.
      async.elapse(const Duration(seconds: 30));
      async.flushMicrotasks();
      expect(sentVersions, [null, 'v1', 'v1']);
    });
  });

  test('pauses while backgrounded and resumes (polling once) on return', () {
    fakeAsync((async) {
      when(() => repo.fetchLeaderboard(any(), version: any(named: 'version')))
          .thenAnswer(
        (_) async => _board([_entry('s1', 30, leader: true)], version: 'v1'),
      );

      final container = containerWith();
      final sub = container.listen(
        liveLeaderboardControllerProvider('g1'),
        (_, __) {},
      );
      addTearDown(sub.close);
      async.flushMicrotasks();

      final notifier =
          container.read(liveLeaderboardControllerProvider('g1').notifier);
      verify(() => repo.fetchLeaderboard(any(), version: any(named: 'version')))
          .called(1);

      // Backgrounded: the timer is cancelled, so no polling happens.
      notifier.setAppActive(false);
      async.elapse(const Duration(seconds: 20));
      async.flushMicrotasks();
      verifyNever(
          () => repo.fetchLeaderboard(any(), version: any(named: 'version')));

      // Foregrounded again: it polls immediately, then resumes the cadence.
      notifier.setAppActive(true);
      async.flushMicrotasks();
      async.elapse(const Duration(seconds: 5));
      async.flushMicrotasks();
      verify(() => repo.fetchLeaderboard(any(), version: any(named: 'version')))
          .called(2);
    });
  });

  test('offline at open falls back to the cached lifecycle', () {
    fakeAsync((async) {
      when(() => repo.fetchLeaderboard(any(), version: any(named: 'version')))
          .thenThrow(Exception('offline'));
      when(() => repo.getGroup('g1')).thenAnswer(
        (_) async => ScoringGroupEntity(
          id: 'g1',
          joinCode: 'AB12CD',
          hostUserId: 1,
          distanceCategory: DistanceCategory.d50m,
          distanceM: 50,
          numEnds: 6,
          arrowsPerEnd: 6,
          startedAt: DateTime(2026),
        ),
      );

      final container = containerWith();
      final sub = container.listen(
        liveLeaderboardControllerProvider('g1'),
        (_, __) {},
      );
      addTearDown(sub.close);
      async.flushMicrotasks();

      final state =
          container.read(liveLeaderboardControllerProvider('g1')).value!;
      expect(state.offline, isTrue);
      expect(state.entries, isEmpty);
      // Lifecycle learned from cache so the screen still knows it's live.
      expect(state.groupStatus, ScoringSessionStatus.inProgress);
    });
  });
}
