import '../domain/scoring_entities.dart';
import '../domain/scoring_enums.dart';

/// Maps a [ScoringSessionEntity] to the JSON body expected by the backend
/// scoring sync/store endpoints (snake_case, nested ends/arrows).
Map<String, dynamic> scoringSessionToSyncJson(ScoringSessionEntity s) {
  return {
    'id': s.id,
    'client_uuid': s.clientUuid,
    if (s.equipmentProfileId != null)
      'equipment_profile_id': s.equipmentProfileId,
    if (s.title != null) 'title': s.title,
    'bow_class': s.bowClass.value,
    'distance_category': s.distanceCategory.value,
    'distance_m': s.distanceM,
    'environment': s.environment.value,
    if (s.targetFaceCm != null) 'target_face_cm': s.targetFaceCm,
    if (s.targetFaceId != null) 'target_face_id': s.targetFaceId,
    'num_ends': s.numEnds,
    'arrows_per_end': s.arrowsPerEnd,
    'status': s.status.value,
    if (s.notes != null) 'notes': s.notes,
    'source': 'mobile',
    'started_at': s.startedAt.toUtc().toIso8601String(),
    if (s.completedAt != null)
      'completed_at': s.completedAt!.toUtc().toIso8601String(),
    'ends': s.ends
        .map((end) => {
              'id': end.id,
              'end_number': end.endNumber,
              'is_sighter': end.isSighter,
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

/// Parses a [ScoringSessionEntity] from JSON (network response).
ScoringSessionEntity scoringSessionFromJson(Map<String, dynamic> json) {
  final endsJson = json['ends'] as List<dynamic>? ?? [];
  final ends = endsJson.map((e) {
    final endMap = e as Map<String, dynamic>;
    final arrowsJson = endMap['arrows'] as List<dynamic>? ?? [];
    final arrows = arrowsJson.map((a) {
      final arrowMap = a as Map<String, dynamic>;
      return ArrowScore(
        id: arrowMap['id'] as String? ?? '',
        arrowIndex: arrowMap['arrow_index'] as int? ?? 0,
        scoreValue: arrowMap['score_value'] as int? ?? 0,
        isX: arrowMap['is_x'] as bool? ?? false,
        isMiss: arrowMap['is_miss'] as bool? ?? false,
      );
    }).toList();
    return ScoringEndEntity(
      id: endMap['id'] as String? ?? '',
      endNumber: endMap['end_number'] as int? ?? 0,
      isSighter: endMap['is_sighter'] as bool? ?? false,
      arrows: arrows,
    );
  }).toList();

  return ScoringSessionEntity(
    id: json['id'] as String? ?? '',
    clientUuid: json['client_uuid'] as String? ?? '',
    equipmentProfileId: json['equipment_profile_id'] as String?,
    title: json['title'] as String?,
    bowClass: BowClass.fromValue(json['bow_class'] as String?),
    distanceCategory:
        DistanceCategory.fromValue(json['distance_category'] as String?),
    distanceM: json['distance_m'] as int? ?? 0,
    environment: ArcheryEnvironment.fromValue(json['environment'] as String?),
    targetFaceCm: json['target_face_cm'] as int?,
    targetFaceId: json['target_face_id'] as String?,
    numEnds: json['num_ends'] as int? ?? 0,
    arrowsPerEnd: json['arrows_per_end'] as int? ?? 6,
    status: ScoringSessionStatus.fromValue(json['status'] as String?),
    notes: json['notes'] as String?,
    startedAt: json['started_at'] != null
        ? DateTime.parse(json['started_at'] as String)
        : DateTime.now(),
    completedAt: json['completed_at'] != null
        ? DateTime.parse(json['completed_at'] as String)
        : null,
    isPersonalBest: json['is_personal_best'] as bool? ?? false,
    isSynced: true,
    ends: ends,
    maxPossibleScoreOverride: json['max_possible_score'] as int?,
  );
}
