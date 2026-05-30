import '../domain/scoring_entities.dart';

/// Maps a [ScoringSessionEntity] to the JSON body expected by the backend
/// scoring sync/store endpoints (snake_case, nested ends/arrows).
Map<String, dynamic> scoringSessionToSyncJson(ScoringSessionEntity s) {
  return {
    'id': s.id,
    'client_uuid': s.clientUuid,
    if (s.equipmentProfileId != null) 'equipment_profile_id': s.equipmentProfileId,
    if (s.title != null) 'title': s.title,
    'bow_class': s.bowClass.value,
    'distance_category': s.distanceCategory.value,
    'distance_m': s.distanceM,
    'environment': s.environment.value,
    if (s.targetFaceCm != null) 'target_face_cm': s.targetFaceCm,
    'num_ends': s.numEnds,
    'arrows_per_end': s.arrowsPerEnd,
    'status': s.status.value,
    if (s.notes != null) 'notes': s.notes,
    'source': 'mobile',
    'started_at': s.startedAt.toUtc().toIso8601String(),
    if (s.completedAt != null) 'completed_at': s.completedAt!.toUtc().toIso8601String(),
    'ends': s.ends
        .map((end) => {
              'id': end.id,
              'end_number': end.endNumber,
              'arrows': end.arrows
                  .map((a) => {
                        'id': a.id,
                        'arrow_index': a.arrowIndex,
                        'score_value': a.scoreValue,
                        'is_x': a.isX,
                        'is_miss': a.isMiss,
                      })
                  .toList(),
            })
        .toList(),
  };
}
