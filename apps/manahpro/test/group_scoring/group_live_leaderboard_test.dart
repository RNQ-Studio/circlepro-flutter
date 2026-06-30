import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:manahpro/features/group_scoring/data/group_scoring_repository_impl.dart';
import 'package:manahpro/features/group_scoring/data/local/group_scoring_local_data_source.dart';
import 'package:manahpro/features/group_scoring/data/remote/group_scoring_remote_data_source.dart';
import 'package:manahpro/features/group_scoring/domain/group_live_leaderboard.dart';
import 'package:manahpro/features/scoring/domain/scoring_enums.dart';

class _MockRemote extends Mock implements GroupScoringRemoteDataSource {}

class _MockLocal extends Mock implements GroupScoringLocalDataSource {}

/// Sprint 11 — parsing of the live leaderboard envelope and the repository
/// wiring that feeds the lifecycle-aware poller. These are the bug-prone seams:
/// the `unchanged` short-circuit, the lifecycle status that stops polling, and
/// the version cursor that must round-trip unchanged.
void main() {
  group('LiveLeaderboardSnapshot.fromEnvelope', () {
    test('parses a full fair board with lifecycle + meta', () {
      final snapshot = LiveLeaderboardSnapshot.fromEnvelope({
        'data': {
          'entries': [
            {
              'rank': 1,
              'session_id': 'sessA',
              'user_id': 7,
              'is_guest': false,
              'display_name': 'Andi',
              'bow_class': 'recurve',
              'status': 'in_progress',
              'total_score': 54,
              'x_count': 2,
              'ten_count': 3,
              'arrows_shot': 9,
              'validated_ends': 3,
              'target_ends': 6,
              'comparable_total': 54,
              'is_complete': false,
              'tied': false,
              'is_provisional_leader': true,
              'is_improvement_leader': true,
              'skill_insight': {
                'baseline': {
                  'has_baseline': true,
                  'sessions_count': 3,
                  'average_score': 42.0,
                  'best_score': 50,
                  'delta_vs_average': 12.0,
                  'delta_vs_best': 4,
                  'label': '+12 dari rata-ratamu',
                },
                'end_trend': [
                  {'end_number': 1, 'total': 27, 'is_sighter': false},
                  {'end_number': 2, 'total': 27, 'is_sighter': false},
                ],
                'callout': 'Paling membaik sore ini.',
              },
            },
            {
              'rank': 2,
              'session_id': 'sessB',
              'is_guest': true,
              'display_name': 'Tamu Budi',
              'total_score': 40,
              'x_count': 0,
              'ten_count': 1,
              'arrows_shot': 9,
              'validated_ends': 3,
              'target_ends': 6,
              'comparable_total': 40,
              'is_complete': false,
              'tied': false,
              'is_provisional_leader': false,
            },
          ],
        },
        'meta': {
          'version': '2-1718000000000-in_progress',
          'group_status': 'in_progress',
          'all_completed': false,
          'is_provisional': true,
          'comparable_ends': 3,
          'target_ends': 6,
          'participant_count': 2,
        },
      });

      expect(snapshot.unchanged, isFalse);
      expect(snapshot.version, '2-1718000000000-in_progress');
      expect(snapshot.groupStatus, ScoringSessionStatus.inProgress);
      expect(snapshot.isLive, isTrue);
      expect(snapshot.allCompleted, isFalse);
      expect(snapshot.comparableEnds, 3);
      expect(snapshot.participantCount, 2);
      expect(snapshot.entries, hasLength(2));

      final leader = snapshot.entries.first;
      expect(leader.sessionId, 'sessA');
      expect(leader.displayName, 'Andi');
      expect(leader.bowClass, BowClass.recurve);
      expect(leader.totalScore, 54);
      expect(leader.isProvisionalLeader, isTrue);
      expect(leader.isImprovementLeader, isTrue);
      expect(leader.hasStarted, isTrue);
      expect(leader.skillInsight?.baseline.hasBaseline, isTrue);
      expect(leader.skillInsight?.baseline.deltaVsAverage, 12);
      expect(
          leader.skillInsight?.endTrend.map((e) => e.total).toList(), [27, 27]);
      expect(leader.skillInsight?.callout, 'Paling membaik sore ini.');

      final guest = snapshot.entries[1];
      expect(guest.isGuest, isTrue);
      expect(guest.userId, isNull);
    });

    test('an unchanged reply is an empty, cheap payload (the idle poll)', () {
      final snapshot = LiveLeaderboardSnapshot.fromEnvelope({
        'data': {'entries': <dynamic>[]},
        'meta': {
          'version': '2-1718000000000-in_progress',
          'unchanged': true,
        },
      });

      expect(snapshot.unchanged, isTrue);
      expect(snapshot.entries, isEmpty);
      expect(snapshot.version, '2-1718000000000-in_progress');
      // The unchanged short-circuit carries no group_status; the caller keeps
      // the lifecycle it already knows.
      expect(snapshot.groupStatus, isNull);
    });

    test('reads a completed lifecycle so the poller can stop', () {
      final snapshot = LiveLeaderboardSnapshot.fromEnvelope({
        'data': {'entries': <dynamic>[]},
        'meta': {
          'version': '1-1718000009999-completed',
          'group_status': 'completed',
          'all_completed': true,
        },
      });

      expect(snapshot.groupStatus, ScoringSessionStatus.completed);
      expect(snapshot.isLive, isFalse);
      expect(snapshot.allCompleted, isTrue);
    });

    test('a zero-arrow entry has not started (shows "—", never a 0)', () {
      final entry = LiveLeaderboardEntry.fromJson({
        'rank': 3,
        'session_id': 'sessC',
        'total_score': 0,
        'arrows_shot': 0,
      });
      expect(entry.hasStarted, isFalse);
      expect(entry.labelOr('Saya'), 'Saya');
    });
  });

  group('GroupScoringRepositoryImpl.fetchLeaderboard', () {
    late _MockRemote remote;
    late _MockLocal local;
    late GroupScoringRepositoryImpl repository;

    setUp(() {
      remote = _MockRemote();
      local = _MockLocal();
      repository = GroupScoringRepositoryImpl(remote, local);
    });

    test('round-trips the version cursor and parses the envelope', () async {
      when(() => remote.getLeaderboard('g1', version: 'v-old')).thenAnswer(
        (_) async => {
          'data': {
            'entries': [
              {
                'rank': 1,
                'session_id': 's1',
                'total_score': 30,
                'arrows_shot': 3,
                'validated_ends': 1,
              },
            ],
          },
          'meta': {
            'version': 'v-new',
            'group_status': 'in_progress',
          },
        },
      );

      final snapshot =
          await repository.fetchLeaderboard('g1', version: 'v-old');

      expect(snapshot.version, 'v-new');
      expect(snapshot.entries.single.sessionId, 's1');
      expect(snapshot.isLive, isTrue);
      verify(() => remote.getLeaderboard('g1', version: 'v-old')).called(1);
    });
  });
}
