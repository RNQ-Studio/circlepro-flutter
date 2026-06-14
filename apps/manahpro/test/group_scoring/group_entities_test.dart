import 'package:flutter_test/flutter_test.dart';
import 'package:manahpro/features/group_scoring/domain/group_entities.dart';
import 'package:manahpro/features/scoring/domain/scoring_enums.dart';

void main() {
  group('ScoringGroupEntity.fromJson', () {
    test('parses host, round format, status and nested roster', () {
      final group = ScoringGroupEntity.fromJson({
        'id': '01HZX',
        'join_code': 'AB12CD',
        'host': {'id': 7, 'name': 'Coach Hadi'},
        'title': 'Latihan Sore',
        'distance_category': '50m',
        'distance_m': 50,
        'environment': 'outdoor',
        'target_face_cm': 122,
        'target_face_id': 'tf_1',
        'num_ends': 6,
        'arrows_per_end': 6,
        'status': 'in_progress',
        'participant_count': 2,
        'started_at': '2026-06-17T08:00:00Z',
        'participants': [
          {
            'id': 's1',
            'user_id': 7,
            'is_guest': false,
            'display_name': 'Coach Hadi',
            'bow_class': 'recurve',
            'total_score': 270,
            'arrows_shot': 36,
          },
          {
            'id': 's2',
            'user_id': null,
            'is_guest': true,
            'display_name': 'Andi (tamu)',
            'guest_name': 'Andi (tamu)',
          },
        ],
      });

      expect(group.id, '01HZX');
      expect(group.joinCode, 'AB12CD');
      expect(group.hostUserId, 7);
      expect(group.hostName, 'Coach Hadi');
      expect(group.distanceCategory, DistanceCategory.d50m);
      expect(group.distanceM, 50);
      expect(group.environment, ArcheryEnvironment.outdoor);
      expect(group.numEnds, 6);
      expect(group.arrowsPerEnd, 6);
      expect(group.plannedArrows, 36);
      expect(group.status, ScoringSessionStatus.inProgress);
      expect(group.participantCount, 2);
      expect(group.participants, hasLength(2));
    });

    test('tolerates a lookup payload without a roster', () {
      final group = ScoringGroupEntity.fromJson({
        'id': 'g1',
        'join_code': 'XYZ999',
        'host': {'id': 3, 'name': 'Budi'},
        'distance_category': '70m',
        'distance_m': 70,
        'num_ends': 12,
        'arrows_per_end': 6,
        'status': 'completed',
      });

      expect(group.participants, isEmpty);
      expect(group.status, ScoringSessionStatus.completed);
      expect(group.arrowsPerEnd, 6);
    });
  });

  group('GroupParticipantEntity.fromJson', () {
    test('owned row keeps user_id and bow class', () {
      final p = GroupParticipantEntity.fromJson({
        'id': 's1',
        'user_id': 7,
        'is_guest': false,
        'display_name': 'Coach Hadi',
        'bow_class': 'compound',
        'distance_m': 50,
        'total_score': 280,
        'max_possible_score': 360,
        'arrows_shot': 36,
        'x_count': 5,
        'ten_count': 12,
        'status': 'completed',
      });

      expect(p.userId, 7);
      expect(p.isGuest, isFalse);
      expect(p.bowClass, BowClass.compound);
      expect(p.totalScore, 280);
      expect(p.status, ScoringSessionStatus.completed);
    });

    test('guest row has null user_id and null bow class', () {
      final p = GroupParticipantEntity.fromJson({
        'id': 's2',
        'user_id': null,
        'is_guest': true,
        'guest_name': 'Andi',
        'display_name': 'Andi',
        'bow_class': null,
        'status': null,
      });

      expect(p.userId, isNull);
      expect(p.isGuest, isTrue);
      expect(p.bowClass, isNull);
      expect(p.status, isNull);
      expect(p.totalScore, 0);
    });
  });
}
