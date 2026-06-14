import 'package:flutter_test/flutter_test.dart';
import 'package:manahpro/features/group_scoring/domain/board_participant_entity.dart';
import 'package:manahpro/features/scoring/domain/scoring_entities.dart';

/// Build an end of plain-valued arrows (enough for these round-status checks).
ScoringEndEntity _end(int number, List<int> values) {
  return ScoringEndEntity(
    id: 'e$number',
    endNumber: number,
    arrows: [
      for (var i = 0; i < values.length; i++)
        ArrowScore(id: 'a$number$i', arrowIndex: i, scoreValue: values[i]),
    ],
  );
}

BoardParticipant _p(String id, List<ScoringEndEntity> ends) =>
    BoardParticipant(id: id, clientUuid: 'u$id', userId: 1, ends: ends);

void main() {
  group('boardRoundIsSaved (task 6.2 correction gating)', () {
    test('false for an empty board', () {
      expect(boardRoundIsSaved(const [], 1), isFalse);
    });

    test('true once every participant has arrows for the round', () {
      final board = [
        _p('1', [
          _end(1, [10, 9, 8])
        ]),
        _p('2', [
          _end(1, [7, 6, 5])
        ]),
      ];
      expect(boardRoundIsSaved(board, 1), isTrue);
    });

    test('false while the round is still the live frontier (one missing)', () {
      final board = [
        _p('1', [
          _end(1, [10, 9, 8])
        ]),
        _p('2', const []), // hasn't been scored for end 1 yet
      ];
      expect(boardRoundIsSaved(board, 1), isFalse);
    });

    test('a late-joined player keeps an old round un-saveable (noted gap)', () {
      // Player 2 joined after round 1 was recorded — they have round 2 only.
      final board = [
        _p('1', [
          _end(1, [10, 9, 8]),
          _end(2, [9, 9, 9])
        ]),
        _p('2', [
          _end(2, [8, 8, 8])
        ]),
      ];
      expect(boardRoundIsSaved(board, 2), isTrue);
      expect(boardRoundIsSaved(board, 1), isFalse);
    });
  });

  group('BoardParticipant.endsShot (roster running progress, task 6.4)', () {
    test('counts only rounds that actually have arrows', () {
      final p = _p('1', [
        _end(1, [10, 10, 10]),
        const ScoringEndEntity(id: 'e2', endNumber: 2), // not shot yet
        _end(3, [9, 9, 9]),
      ]);
      expect(p.endsShot, 2);
      expect(p.totalScore, 30 + 27);
    });

    test('zero for a freshly added participant', () {
      expect(_p('1', const []).endsShot, 0);
    });
  });
}
