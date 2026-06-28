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
            'distance_category': '50m',
            'distance_m': 50,
            'target_face_cm': 122,
            'target_butt': 1,
            'target_letter': 'A',
            'last_scored_by_user_id': 11,
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
      expect(group.participants.first.targetLabel, '1A');
      expect(group.participants.first.distanceLabel, '50 m / 122 cm');
      expect(group.participants.first.lastScoredByUserId, 11);
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
        'distance_category': '50m',
        'distance_m': 50,
        'target_face_cm': 122,
        'target_butt': 2,
        'target_letter': 'B',
        'last_scored_by_user_id': 9,
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
      expect(p.distanceCategory, DistanceCategory.d50m);
      expect(p.targetFaceCm, 122);
      expect(p.targetButt, 2);
      expect(p.targetLetter, 'B');
      expect(p.targetLabel, '2B');
      expect(p.distanceLabel, '50 m / 122 cm');
      expect(p.lastScoredByUserId, 9);
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

  group('GroupButtStatusEnvelope.fromEnvelope', () {
    test('parses per-butt scorer, progress and participant metadata', () {
      final envelope = GroupButtStatusEnvelope.fromEnvelope({
        'data': {
          'butts': [
            {
              'target_butt': 3,
              'label': 'Bantalan 3',
              'participant_count': 2,
              'completed_count': 1,
              'submitted_count': 1,
              'pending_count': 1,
              'end_progress': 4,
              'max_end_progress': 6,
              'current_end': 5,
              'target_ends': 6,
              'total_score': 512,
              'is_complete': false,
              'lagging_by_ends': 2,
              'is_lagging': true,
              'scorer': {
                'id': 'gs1',
                'user_id': 99,
                'target_butt': 3,
                'assignment_type': 'claimed',
                'scorer': {'id': 99, 'name': 'Skorer A'},
              },
              'participants': [
                {
                  'id': 's1',
                  'display_name': 'Archer A',
                  'target_butt': 3,
                  'target_letter': 'A',
                  'distance_m': 50,
                  'target_face_cm': 122,
                  'arrows_shot': 24,
                },
              ],
            },
          ],
        },
        'meta': {
          'version': '2-100-in_progress',
          'group_status': 'in_progress',
          'participant_count': 2,
          'butt_count': 1,
        },
      });

      expect(envelope.version, '2-100-in_progress');
      expect(envelope.groupStatus, ScoringSessionStatus.inProgress);
      expect(envelope.unchanged, isFalse);
      expect(envelope.butts, hasLength(1));
      final butt = envelope.butts.single;
      expect(butt.targetButt, 3);
      expect(butt.label, 'Bantalan 3');
      expect(butt.scorer?.name, 'Skorer A');
      expect(butt.isLagging, isTrue);
      expect(butt.progressLabel, '4/6');
      expect(butt.participants.single.targetLabel, '3A');
    });

    test('keeps previous state when backend says unchanged', () {
      final envelope = GroupButtStatusEnvelope.fromEnvelope({
        'data': {'butts': []},
        'meta': {'version': 'v1', 'unchanged': true},
      });

      expect(envelope.unchanged, isTrue);
      expect(envelope.butts, isEmpty);
      expect(envelope.version, 'v1');
    });
  });
}
