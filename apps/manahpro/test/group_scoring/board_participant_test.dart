import 'package:flutter_test/flutter_test.dart';
import 'package:manahpro/features/group_scoring/data/board_participant_mapper.dart';
import 'package:manahpro/features/group_scoring/domain/board_participant_entity.dart';
import 'package:manahpro/features/scoring/domain/scoring_entities.dart';
import 'package:manahpro/features/scoring/domain/scoring_enums.dart';

/// Build an end of arrows from a compact list. `'X'` = inner-10, `'M'` = miss,
/// otherwise the integer value.
ScoringEndEntity _end(int number, List<Object> values) {
  final arrows = <ArrowScore>[];
  for (var i = 0; i < values.length; i++) {
    final v = values[i];
    if (v == 'X') {
      arrows.add(ArrowScore(
          id: 'a$number$i', arrowIndex: i, scoreValue: 10, isX: true));
    } else if (v == 'M') {
      arrows.add(ArrowScore(
          id: 'a$number$i', arrowIndex: i, scoreValue: 0, isMiss: true));
    } else {
      arrows.add(
          ArrowScore(id: 'a$number$i', arrowIndex: i, scoreValue: v as int));
    }
  }
  return ScoringEndEntity(id: 'e$number', endNumber: number, arrows: arrows);
}

void main() {
  group('BoardParticipant', () {
    test('derives aggregates from ends (X/10/total/arrows)', () {
      final p = BoardParticipant(
        id: 's1',
        clientUuid: 'u1',
        userId: 7,
        displayName: 'Coach Hadi',
        bowClass: BowClass.recurve,
        ends: [
          _end(1, [10, 'X', 9]),
          _end(2, [8, 7, 'M']),
        ],
      );

      expect(p.totalScore, 10 + 10 + 9 + 8 + 7 + 0);
      expect(p.arrowsShot, 6);
      expect(p.xCount, 1); // only the 'X'
      expect(p.tenCount, 2); // the plain 10 and the X both count as ten
    });

    test('guest is identified by null user_id + guest name (task 5.2)', () {
      const guest = BoardParticipant(
        id: 's2',
        clientUuid: 'u2',
        guestName: 'Andi',
      );
      const owned = BoardParticipant(
        id: 's1',
        clientUuid: 'u1',
        userId: 7,
        displayName: 'Coach Hadi',
      );

      expect(guest.isGuest, isTrue);
      expect(owned.isGuest, isFalse);
    });

    test('labelOr prefers guest name, then display name, then fallback', () {
      const guest =
          BoardParticipant(id: 's2', clientUuid: 'u2', guestName: 'Andi');
      const owned = BoardParticipant(
          id: 's1', clientUuid: 'u1', userId: 7, displayName: 'Coach Hadi');
      const bare = BoardParticipant(id: 's3', clientUuid: 'u3', userId: 9);

      expect(guest.labelOr('Saya'), 'Andi');
      expect(owned.labelOr('Saya'), 'Coach Hadi');
      expect(bare.labelOr('Saya'), 'Saya');
    });

    test('arrowsForEnd returns the matching end, empty otherwise', () {
      final p = BoardParticipant(
        id: 's1',
        clientUuid: 'u1',
        ends: [
          _end(1, [9, 9, 9])
        ],
      );

      expect(p.arrowsForEnd(1), hasLength(3));
      expect(p.arrowsForEnd(2), isEmpty);
    });
  });

  group('boardParticipantToSyncJson', () {
    test('guest row carries name (so it can be minted) + nested ends', () {
      final p = BoardParticipant(
        id: 's2',
        clientUuid: 'u2',
        guestName: 'Andi',
        status: ScoringSessionStatus.inProgress,
        ends: [
          _end(1, [10, 'X', 'M'])
        ],
      );

      final json = boardParticipantToSyncJson(p);

      expect(json['id'], 's2');
      expect(json['client_uuid'], 'u2');
      expect(json['name'], 'Andi');
      expect(json.containsKey('bow_class'), isFalse); // guest, no bow class
      expect(json['status'], 'in_progress');

      final ends = json['ends'] as List<dynamic>;
      expect(ends, hasLength(1));
      final arrows = (ends.first as Map)['arrows'] as List<dynamic>;
      expect(arrows, hasLength(3));
      expect((arrows[1] as Map)['is_x'], isTrue);
      expect((arrows[1] as Map)['score_value'], 10);
      expect((arrows[2] as Map)['is_miss'], isTrue);
      expect((arrows[2] as Map)['score_value'], 0);
    });

    test('owned row sends bow_class and no name', () {
      final p = BoardParticipant(
        id: 's1',
        clientUuid: 'u1',
        userId: 7,
        bowClass: BowClass.compound,
        status: ScoringSessionStatus.completed,
        completedAt: DateTime.utc(2026, 6, 18, 9),
        ends: [
          _end(1, [10, 10, 10])
        ],
      );

      final json = boardParticipantToSyncJson(p);

      expect(json.containsKey('name'), isFalse);
      expect(json['bow_class'], 'compound');
      expect(json['status'], 'completed');
      expect(json['completed_at'], '2026-06-18T09:00:00.000Z');
    });

    test('empty (unshot) ends are dropped from the payload', () {
      final p = BoardParticipant(
        id: 's1',
        clientUuid: 'u1',
        userId: 7,
        ends: [
          _end(1, [9, 9, 9]),
          const ScoringEndEntity(id: 'e2', endNumber: 2), // not shot yet
        ],
      );

      final ends = boardParticipantToSyncJson(p)['ends'] as List<dynamic>;
      expect(ends, hasLength(1));
      expect((ends.first as Map)['end_number'], 1);
    });
  });
}
