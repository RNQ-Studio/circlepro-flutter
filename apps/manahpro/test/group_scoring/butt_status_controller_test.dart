import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manahpro/features/group_scoring/domain/group_entities.dart';
import 'package:manahpro/features/group_scoring/domain/group_scoring_repository.dart';
import 'package:manahpro/features/group_scoring/presentation/group_scoring_providers.dart';
import 'package:manahpro/features/scoring/domain/scoring_enums.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements GroupScoringRepository {}

GroupButtStatusEnvelope _status(
  List<GroupButtEntity> butts, {
  required String version,
  ScoringSessionStatus status = ScoringSessionStatus.inProgress,
}) =>
    GroupButtStatusEnvelope(
      butts: butts,
      version: version,
      groupStatus: status,
      participantCount: 2,
      buttCount: butts.length,
    );

GroupButtEntity _butt(int targetButt, int endProgress) => GroupButtEntity(
      targetButt: targetButt,
      participantCount: 2,
      completedCount: 0,
      submittedCount: 1,
      pendingCount: 1,
      endProgress: endProgress,
      maxEndProgress: endProgress,
      currentEnd: endProgress + 1,
      targetEnds: 6,
      isComplete: false,
      totalScore: 120,
      laggingByEnds: 0,
      isLagging: false,
    );

void main() {
  late _MockRepo repo;

  ProviderContainer containerWith() {
    final container = ProviderContainer(
      overrides: [groupScoringRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() => repo = _MockRepo());

  test('polls with version cursor and keeps board on unchanged replies', () {
    fakeAsync((async) {
      final responses = <GroupButtStatusEnvelope>[
        _status([_butt(1, 2)], version: 'v1'),
        const GroupButtStatusEnvelope(
          butts: [],
          version: 'v1',
          unchanged: true,
          groupStatus: ScoringSessionStatus.inProgress,
        ),
        _status(
          [_butt(1, 6)],
          version: 'v2',
          status: ScoringSessionStatus.completed,
        ),
      ];
      final sentVersions = <String?>[];
      when(() => repo.fetchButts(any(), version: any(named: 'version')))
          .thenAnswer((invocation) async {
        sentVersions.add(invocation.namedArguments[#version] as String?);
        return responses.removeAt(0);
      });

      final container = containerWith();
      final sub = container.listen(
        buttStatusControllerProvider('g1'),
        (_, __) {},
      );
      addTearDown(sub.close);
      async.flushMicrotasks();

      var state = container.read(buttStatusControllerProvider('g1')).value!;
      expect(sentVersions, [null]);
      expect(state.butts.single.endProgress, 2);
      expect(state.version, 'v1');
      final firstUpdatedAt = state.updatedAt;

      async.elapse(const Duration(seconds: 5));
      async.flushMicrotasks();
      state = container.read(buttStatusControllerProvider('g1')).value!;
      expect(sentVersions, [null, 'v1']);
      expect(state.butts.single.endProgress, 2);
      expect(state.updatedAt, firstUpdatedAt);

      async.elapse(const Duration(seconds: 5));
      async.flushMicrotasks();
      state = container.read(buttStatusControllerProvider('g1')).value!;
      expect(sentVersions, [null, 'v1', 'v1']);
      expect(state.butts.single.endProgress, 6);
      expect(state.isLive, isFalse);
    });
  });

  test('builds an offline butt board from cached roster metadata', () {
    fakeAsync((async) {
      when(() => repo.fetchButts(any(), version: any(named: 'version')))
          .thenThrow(Exception('offline'));
      when(() => repo.getGroup('g1')).thenAnswer(
        (_) async => ScoringGroupEntity(
          id: 'g1',
          joinCode: 'ABC123',
          hostUserId: 1,
          distanceCategory: DistanceCategory.d20m,
          distanceM: 18,
          numEnds: 6,
          arrowsPerEnd: 3,
          startedAt: DateTime(2026, 6, 28),
          participants: const [
            GroupParticipantEntity(
              id: 'p1',
              displayName: 'Alya',
              targetButt: 1,
              targetLetter: 'A',
              arrowsShot: 6,
              totalScore: 52,
              status: ScoringSessionStatus.inProgress,
            ),
            GroupParticipantEntity(
              id: 'p2',
              displayName: 'Bima',
              targetButt: 2,
              targetLetter: 'A',
              arrowsShot: 0,
              totalScore: 0,
              status: ScoringSessionStatus.inProgress,
            ),
          ],
        ),
      );

      final container = containerWith();
      final sub = container.listen(
        buttStatusControllerProvider('g1'),
        (_, __) {},
      );
      addTearDown(sub.close);
      async.flushMicrotasks();

      final state = container.read(buttStatusControllerProvider('g1')).value!;
      expect(state.offline, isTrue);
      expect(state.participantCount, 2);
      expect(state.buttCount, 2);
      expect(state.butts.map((b) => b.targetButt), [1, 2]);
      expect(state.butts.first.endProgress, 2);
      expect(state.butts.last.isLagging, isTrue);
    });
  });
}
