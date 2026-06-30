import 'package:flutter_test/flutter_test.dart';
import 'package:manahpro/features/group_scoring/domain/board_participant_entity.dart';
import 'package:manahpro/features/group_scoring/domain/group_leaderboard.dart';
import 'package:manahpro/features/scoring/domain/scoring_entities.dart';

/// One arrow spec: a value, optionally flagged X or Miss.
typedef _A = ({int value, bool isX, bool isMiss});

_A _v(int value) => (value: value, isX: false, isMiss: false);
_A _x() => (value: 10, isX: true, isMiss: false);

ScoringEndEntity _end(
  int number,
  List<_A> arrows, {
  bool isSighter = false,
}) {
  return ScoringEndEntity(
    id: 'e$number',
    endNumber: number,
    isSighter: isSighter,
    arrows: [
      for (var i = 0; i < arrows.length; i++)
        ArrowScore(
          id: 'a$number$i',
          arrowIndex: i,
          scoreValue: arrows[i].isMiss ? 0 : arrows[i].value,
          isX: arrows[i].isX,
          isMiss: arrows[i].isMiss,
        ),
    ],
  );
}

BoardParticipant _p(String id, List<ScoringEndEntity> ends, {String? name}) =>
    BoardParticipant(
      id: id,
      clientUuid: 'u$id',
      userId: name == null ? 1 : null,
      guestName: name,
      ends: ends,
    );

void main() {
  group('buildGroupLeaderboard — fair ranking (task 7.1, K4)', () {
    test('orders by total descending', () {
      final board = [
        _p('low', [
          _end(1, [_v(5), _v(5), _v(5)])
        ]),
        _p('high', [
          _end(1, [_v(10), _v(10), _v(10)])
        ]),
        _p('mid', [
          _end(1, [_v(8), _v(8), _v(8)])
        ]),
      ];
      final lb = buildGroupLeaderboard(
          participants: board, numEnds: 1, arrowsPerEnd: 3);
      expect(lb.entries.map((e) => e.participant.id).toList(),
          ['high', 'mid', 'low']);
      expect(lb.entries.map((e) => e.rank).toList(), [1, 2, 3]);
    });

    test('tie-break by X count then 10 count (no time)', () {
      // Same total (30); 'a' has more X, 'b' has a plain 10, 'c' none special.
      final board = [
        _p('c', [
          _end(1, [_v(10), _v(10), _v(10)])
        ]),
        _p('a', [
          _end(1, [_x(), _x(), _v(10)])
        ]),
        _p('b', [
          _end(1, [_x(), _v(10), _v(10)])
        ]),
      ];
      final lb = buildGroupLeaderboard(
          participants: board, numEnds: 1, arrowsPerEnd: 3);
      expect(lb.entries.map((e) => e.participant.id).toList(), ['a', 'b', 'c']);
    });

    test('a genuine tie shares a rank (standard 1-2-2-4)', () {
      final board = [
        _p('a', [
          _end(1, [_v(9), _v(9), _v(9)])
        ]),
        _p('b', [
          _end(1, [_v(9), _v(9), _v(9)])
        ]),
        _p('c', [
          _end(1, [_v(1), _v(1), _v(1)])
        ]),
      ];
      final lb = buildGroupLeaderboard(
          participants: board, numEnds: 1, arrowsPerEnd: 3);
      expect(lb.entries.map((e) => e.rank).toList(), [1, 1, 3]);
    });

    test('empty board → empty, not complete, not in progress leader', () {
      final lb = buildGroupLeaderboard(
          participants: const [], numEnds: 6, arrowsPerEnd: 6);
      expect(lb.entries, isEmpty);
      expect(lb.isComplete, isFalse);
      expect(lb.leader, isNull);
    });
  });

  group('DNF-friendliness (task 7.4)', () {
    test('isComplete only when every planned arrow is shot', () {
      final board = [
        _p('done', [
          _end(1, [_v(10), _v(10), _v(10)]),
          _end(2, [_v(9), _v(9), _v(9)]),
        ]),
        _p('dnf', [
          _end(1, [_v(8), _v(8), _v(8)]),
        ]),
      ];
      final lb = buildGroupLeaderboard(
          participants: board, numEnds: 2, arrowsPerEnd: 3);
      final done = lb.entries.firstWhere((e) => e.participant.id == 'done');
      final dnf = lb.entries.firstWhere((e) => e.participant.id == 'dnf');
      expect(done.isComplete, isTrue);
      expect(dnf.isComplete, isFalse);
      expect(dnf.hasStarted, isTrue);
    });

    test('a zero-arrow archer has not started (shows "—", never 0)', () {
      final board = [
        _p('present', [
          _end(1, [_v(10), _v(10), _v(10)])
        ]),
        _p('noshow', const []),
      ];
      final lb = buildGroupLeaderboard(
          participants: board, numEnds: 1, arrowsPerEnd: 3);
      final noshow = lb.entries.firstWhere((e) => e.participant.id == 'noshow');
      expect(noshow.hasStarted, isFalse);
      expect(noshow.isComplete, isFalse);
    });

    test('board in progress until everyone finishes', () {
      final board = [
        _p('done', [
          _end(1, [_v(10), _v(10), _v(10)])
        ]),
        _p('dnf', const []),
      ];
      final lb = buildGroupLeaderboard(
          participants: board, numEnds: 1, arrowsPerEnd: 3);
      expect(lb.inProgress, isTrue);
      expect(lb.isComplete, isFalse);
    });

    test('board complete once all finish', () {
      final board = [
        _p('a', [
          _end(1, [_v(10), _v(10), _v(10)])
        ]),
        _p('b', [
          _end(1, [_v(9), _v(9), _v(9)])
        ]),
      ];
      final lb = buildGroupLeaderboard(
          participants: board, numEnds: 1, arrowsPerEnd: 3);
      expect(lb.isComplete, isTrue);
      expect(lb.inProgress, isFalse);
    });
  });

  group('progress label (task 7.1)', () {
    test('roundsShot tracks the furthest archer', () {
      final board = [
        _p('a', [
          _end(1, [_v(10), _v(10), _v(10)]),
          _end(2, [_v(9), _v(9), _v(9)]),
        ]),
        _p('b', [
          _end(1, [_v(8), _v(8), _v(8)]),
        ]),
      ];
      final lb = buildGroupLeaderboard(
          participants: board, numEnds: 6, arrowsPerEnd: 3);
      expect(lb.roundsShot, 2);
      expect(lb.numEnds, 6);
      expect(lb.leader?.participant.id, 'a');
    });

    test(
        'sighter rounds stay on the detail but are excluded from rank and completion',
        () {
      final board = [
        _p('warmup-winner', [
          _end(1, [_v(10), _v(10), _v(10)], isSighter: true),
          _end(2, [_v(7), _v(7), _v(7)]),
        ]),
        _p('score-winner', [
          _end(1, [_v(0), _v(0), _v(0)], isSighter: true),
          _end(2, [_v(9), _v(9), _v(9)]),
        ]),
      ];

      final lb = buildGroupLeaderboard(
        participants: board,
        numEnds: 1,
        arrowsPerEnd: 3,
      );

      expect(lb.entries.first.participant.id, 'score-winner');
      expect(lb.entries.first.participant.totalScore, 27);
      expect(lb.entries.last.participant.totalScore, 21);
      expect(lb.isComplete, isTrue);
      expect(lb.roundsShot, 1);
      expect(board.first.ends, hasLength(2));
    });
  });
}
