import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:manahpro/features/group_scoring/data/group_scoring_repository_impl.dart';
import 'package:manahpro/features/group_scoring/data/local/group_scoring_local_data_source.dart';
import 'package:manahpro/features/group_scoring/data/remote/group_scoring_remote_data_source.dart';
import 'package:manahpro/features/group_scoring/domain/group_entities.dart';
import 'package:manahpro/features/scoring/domain/scoring_enums.dart';

class MockRemote extends Mock implements GroupScoringRemoteDataSource {}

class MockLocal extends Mock implements GroupScoringLocalDataSource {}

/// Sprint 10 — self-join & leave repository orchestration. The repository wires
/// the (online) join/leave to the local cache so the joined member can score
/// offline-first and a left member's row stops showing on the board.
void main() {
  late MockRemote remote;
  late MockLocal local;
  late GroupScoringRepositoryImpl repository;

  Map<String, dynamic> groupJson(String id) => {
        'id': id,
        'join_code': 'AB12CD',
        'host': {'id': 9, 'name': 'Coach Hadi'},
        'distance_category': '50m',
        'distance_m': 50,
        'num_ends': 6,
        'arrows_per_end': 6,
        'status': 'in_progress',
        'started_at': '2026-06-23T08:00:00Z',
        'participants': [
          {
            'id': 'sess1',
            'user_id': 42,
            'is_guest': false,
            'bow_class': 'recurve'
          },
        ],
      };

  setUpAll(() {
    registerFallbackValue(
      ScoringGroupEntity(
        id: 'x',
        joinCode: 'X',
        hostUserId: 1,
        distanceCategory: DistanceCategory.d50m,
        distanceM: 50,
        numEnds: 6,
        arrowsPerEnd: 6,
        startedAt: DateTime(2026),
      ),
    );
  });

  setUp(() {
    remote = MockRemote();
    local = MockLocal();
    repository = GroupScoringRepositoryImpl(remote, local);
    when(() => local.upsertGroupWithRoster(any())).thenAnswer((_) async {});
    when(() => local.removeLocalParticipant(any(), any()))
        .thenAnswer((_) async {});
  });

  group('joinGroup', () {
    test('posts bow class and distance override, then refreshes the cache',
        () async {
      when(() => remote.joinGroup('g1', any()))
          .thenAnswer((_) async => {'id': 'sess1', 'user_id': 42});
      when(() => remote.getGroup('g1'))
          .thenAnswer((_) async => groupJson('g1'));

      final sessionId = await repository.joinGroup(
        'g1',
        bowClass: BowClass.recurve,
        distanceM: 30,
        targetFaceCm: 80,
      );

      expect(sessionId, 'sess1');
      final captured = verify(() => remote.joinGroup('g1', captureAny()))
          .captured
          .single as Map<String, dynamic>;
      expect(captured['bow_class'], 'recurve');
      expect(captured['distance_m'], 30);
      expect(captured['target_face_cm'], 80);
      // The roster is refreshed so loadBoard can seed the self row locally.
      verify(() => remote.getGroup('g1')).called(1);
      verify(() => local.upsertGroupWithRoster(any())).called(1);
    });

    test('omits bow class when none is picked (K8: optional)', () async {
      when(() => remote.joinGroup('g1', any()))
          .thenAnswer((_) async => {'id': 'sess1'});
      when(() => remote.getGroup('g1'))
          .thenAnswer((_) async => groupJson('g1'));

      await repository.joinGroup('g1');

      final captured = verify(() => remote.joinGroup('g1', captureAny()))
          .captured
          .single as Map<String, dynamic>;
      expect(captured.containsKey('bow_class'), isFalse);
    });
  });

  group('leaveGroup', () {
    test('deletes on the server then clears the local copy', () async {
      when(() => remote.leaveGroup('g1', 'sess1')).thenAnswer((_) async {});

      await repository.leaveGroup('g1', 'sess1');

      verify(() => remote.leaveGroup('g1', 'sess1')).called(1);
      verify(() => local.removeLocalParticipant('g1', 'sess1')).called(1);
    });

    test('does not clear local if the server delete fails', () async {
      when(() => remote.leaveGroup('g1', 'sess1'))
          .thenThrow(Exception('offline'));

      await expectLater(
        repository.leaveGroup('g1', 'sess1'),
        throwsA(isA<Exception>()),
      );
      verifyNever(() => local.removeLocalParticipant(any(), any()));
    });
  });
}
