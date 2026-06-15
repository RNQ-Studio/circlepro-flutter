import 'package:flutter_test/flutter_test.dart';
import 'package:manahpro/features/group_scoring/domain/group_social_board.dart';
import 'package:manahpro/features/scoring/domain/scoring_enums.dart';

SocialBoardRow _row(
  String id, {
  BowClass? bow,
  bool started = true,
}) =>
    (sessionId: id, bowClass: bow, started: started);

void main() {
  group('bowClassesOnBoard', () {
    test('returns present classes in canonical BowClass.values order', () {
      final rows = [
        _row('a', bow: BowClass.compound),
        _row('b', bow: BowClass.recurve),
        _row('c', bow: BowClass.compound),
        _row('d', bow: BowClass.horsebow),
      ];
      // recurve precedes compound precedes horsebow in the enum declaration.
      expect(bowClassesOnBoard(rows),
          [BowClass.recurve, BowClass.compound, BowClass.horsebow]);
    });

    test('ignores rows with unknown class and de-duplicates', () {
      final rows = [
        _row('a', bow: BowClass.recurve),
        _row('b'),
        _row('c', bow: BowClass.recurve),
      ];
      expect(bowClassesOnBoard(rows), [BowClass.recurve]);
    });

    test('empty board → empty', () {
      expect(bowClassesOnBoard(const []), isEmpty);
    });
  });

  group('classLeaderSessionIds — anti "juara dari 1" (task 12.3)', () {
    test('a lone archer in a class wins no star', () {
      final rows = [
        _row('compound1', bow: BowClass.compound),
        _row('recurve1', bow: BowClass.recurve),
        _row('recurve2', bow: BowClass.recurve),
      ];
      final leaders = classLeaderSessionIds(rows);
      // Compound has only one archer → no star; recurve has two → top wins.
      expect(leaders, {'recurve1'});
    });

    test('first row (best rank) of each ≥2 class wins, order-sensitive', () {
      // Rows are passed in rank order (best first).
      final rows = [
        _row('r_top', bow: BowClass.recurve),
        _row('c_top', bow: BowClass.compound),
        _row('r_2', bow: BowClass.recurve),
        _row('c_2', bow: BowClass.compound),
      ];
      expect(classLeaderSessionIds(rows), {'r_top', 'c_top'});
    });

    test('a not-started archer does not count toward the ≥2 rule', () {
      final rows = [
        _row('a', bow: BowClass.recurve),
        _row('b', bow: BowClass.recurve, started: false),
      ];
      // Only one *started* recurve → no star.
      expect(classLeaderSessionIds(rows), isEmpty);
    });

    test('unknown-class rows never win a star', () {
      final rows = [
        _row('a'),
        _row('b'),
      ];
      expect(classLeaderSessionIds(rows), isEmpty);
    });
  });

  group('filterRowsByClass', () {
    final rows = [
      _row('a', bow: BowClass.recurve),
      _row('b', bow: BowClass.compound),
      _row('c', bow: BowClass.recurve),
    ];

    test('null filter returns all rows unchanged', () {
      expect(filterRowsByClass(rows, null, (r) => r.bowClass), rows);
    });

    test('keeps only the selected class, preserving order', () {
      final filtered =
          filterRowsByClass(rows, BowClass.recurve, (r) => r.bowClass);
      expect(filtered.map((r) => r.sessionId), ['a', 'c']);
    });
  });
}
