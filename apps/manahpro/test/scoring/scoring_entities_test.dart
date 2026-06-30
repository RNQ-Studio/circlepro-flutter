import 'package:flutter_test/flutter_test.dart';
import 'package:manahpro/features/scoring/domain/scoring_entities.dart';
import 'package:manahpro/features/scoring/domain/scoring_enums.dart';
import 'package:manahpro/features/scoring/utils/ulid.dart';

ArrowScore _arrow(int index, int value,
    {bool isX = false, bool isMiss = false}) {
  return ArrowScore(
    id: Ids.ulid(),
    arrowIndex: index,
    scoreValue: isMiss ? 0 : value,
    isX: isX,
    isMiss: isMiss,
  );
}

ScoringSessionEntity _session(
  List<List<ArrowScore>> ends, {
  int? arrowsPerEnd,
  Set<int> sighterEnds = const {},
}) {
  return ScoringSessionEntity(
    id: Ids.ulid(),
    clientUuid: Ids.uuid(),
    bowClass: BowClass.recurve,
    distanceCategory: DistanceCategory.d70m,
    distanceM: 70,
    numEnds: ends.length,
    arrowsPerEnd: arrowsPerEnd ?? (ends.isEmpty ? 0 : ends.first.length),
    startedAt: DateTime(2026, 6, 1),
    ends: [
      for (var i = 0; i < ends.length; i++)
        ScoringEndEntity(
          id: Ids.ulid(),
          endNumber: i + 1,
          isSighter: sighterEnds.contains(i + 1),
          arrows: ends[i],
        ),
    ],
  );
}

void main() {
  group('Arrow display', () {
    test('X, M and numeric labels', () {
      expect(_arrow(0, 10, isX: true).displayValue, 'X');
      expect(_arrow(0, 0, isMiss: true).displayValue, 'M');
      expect(_arrow(0, 9).displayValue, '9');
    });

    test('X and 10 both count as ten', () {
      expect(_arrow(0, 10, isX: true).isTen, isTrue);
      expect(_arrow(0, 10).isTen, isTrue);
      expect(_arrow(0, 9).isTen, isFalse);
    });
  });

  group('Session aggregates', () {
    test('computes total, counts, average and max from arrows', () {
      // End 1: X(10), 10, 9 = 29 | End 2: 8, 8, M = 16 → total 45
      final session = _session([
        [_arrow(0, 10, isX: true), _arrow(1, 10), _arrow(2, 9)],
        [_arrow(0, 8), _arrow(1, 8), _arrow(2, 0, isMiss: true)],
      ]);

      expect(session.totalScore, 45);
      expect(session.arrowsShot, 6);
      expect(session.xCount, 1);
      expect(session.tenCount, 2); // X + the plain 10
      expect(session.missCount, 1);
      expect(session.maxPossibleScore, 60); // 2 ends * 3 arrows * 10
      expect(session.avgPerArrow, closeTo(7.5, 0.001));
      expect(session.ends.first.endTotal, 29);
      expect(session.isComplete, isTrue);
    });

    test('partial session reports not complete and null average when empty',
        () {
      final empty = _session([[], []], arrowsPerEnd: 3);
      expect(empty.arrowsShot, 0);
      expect(empty.avgPerArrow, isNull);
      expect(empty.isComplete, isFalse);
    });

    test(
        'sighter ends stay visible but do not count toward aggregates or PB format',
        () {
      final session = _session(
        [
          [_arrow(0, 10, isX: true), _arrow(1, 10), _arrow(2, 10)],
          [_arrow(0, 8), _arrow(1, 8), _arrow(2, 8)],
          [_arrow(0, 7), _arrow(1, 7), _arrow(2, 7)],
        ],
        sighterEnds: {1},
      );

      expect(session.sighterEnds.map((e) => e.endNumber), [1]);
      expect(session.countedEnds.map((e) => e.endNumber), [2, 3]);
      expect(session.totalScore, 45);
      expect(session.arrowsShot, 6);
      expect(session.xCount, 0);
      expect(session.tenCount, 0);
      expect(session.maxPossibleScore, 60);
      expect(session.plannedArrows, 6);
      expect(session.isComplete, isTrue);
    });
  });

  group('Enums', () {
    test('DistanceCategory.fromMeters picks the nearest', () {
      expect(DistanceCategory.fromMeters(72), DistanceCategory.d70m);
      expect(DistanceCategory.fromMeters(18), DistanceCategory.d20m);
      expect(DistanceCategory.fromMeters(33), DistanceCategory.d30m);
    });

    test('fromValue round-trips wire values', () {
      expect(BowClass.fromValue('compound'), BowClass.compound);
      expect(ScoringSessionStatus.fromValue('completed'),
          ScoringSessionStatus.completed);
    });
  });

  group('Ids', () {
    test('ULID is 26 chars and UUID is RFC-4122 shaped', () {
      expect(Ids.ulid().length, 26);
      expect(
        RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$')
            .hasMatch(Ids.uuid()),
        isTrue,
      );
    });
  });
}
