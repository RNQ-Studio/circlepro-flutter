import '../domain/board_participant_entity.dart';

/// Maps a [BoardParticipant] to one item of the group sync payload expected by
/// `POST /v1/scoring/groups/{group}/sync` (Sprint 03 contract). The round
/// format is inherited from the group server-side, so only identity, status and
/// the nested ends/arrows are sent. `name` is included only for a guest, which
/// lets an offline-created guest row be minted on first sync.
Map<String, dynamic> boardParticipantToSyncJson(BoardParticipant p) {
  return {
    'id': p.id,
    'client_uuid': p.clientUuid,
    if (p.guestName != null) 'name': p.guestName,
    if (p.bowClass != null) 'bow_class': p.bowClass!.value,
    if (p.distanceM != null) 'distance_m': p.distanceM,
    if (p.targetFaceCm != null) 'target_face_cm': p.targetFaceCm,
    if (p.targetButt != null) 'target_butt': p.targetButt,
    if (p.targetLetter != null) 'target_letter': p.targetLetter,
    'status': p.status.value,
    if (p.completedAt != null)
      'completed_at': p.completedAt!.toUtc().toIso8601String(),
    // Only ends that were actually shot are sent; the server replaces all ends
    // with this set (last-write-wins, idempotent).
    'ends': p.ends
        .where((end) => end.arrows.isNotEmpty)
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
