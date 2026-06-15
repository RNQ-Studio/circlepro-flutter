import 'group_scoring_routes.dart';

/// Maps a Latihan Bersama claim notification to the screen it should open
/// (Sprint 14, task 14.4). The backend sends three claim types, each with a
/// deep-link `data` payload `{type, group_id, session_id, claim_id, join_code}`
/// (Sprint 13, §5 Fase 2). Routing is by **type**, not just the bare link, so a
/// single `manahpro://groups/<id>` can still send the host to their inbox but
/// the claimant to their session.
///
/// Pure & side-effect free so it is fully unit testable. Returns the route path
/// to push, or null when the notification is not a claim (the caller leaves its
/// default behaviour untouched).
String? groupClaimNotificationRoute(String? type, Map<String, dynamic>? data) {
  if (type == null || data == null) return null;

  final groupId = data['group_id'] as String?;
  final joinCode = data['join_code'] as String?;
  final sessionId = data['session_id'] as String?;

  switch (type) {
    case 'group_claim_submitted':
      // → host inbox to approve/reject.
      return groupId == null ? null : GroupScoringRoutes.claims(groupId);
    case 'group_claim_approved':
      // → the skill-onboarding success screen for the claimant's session, now
      // theirs (Sprint 15.3). Falls back to the session detail when no session
      // id rode along (older payloads).
      if (groupId == null) return null;
      return sessionId != null && sessionId.isNotEmpty
          ? GroupScoringRoutes.claimSuccess(groupId, sessionId)
          : GroupScoringRoutes.detail(groupId);
    case 'group_claim_rejected':
      // → back to the join preview so they can try again on the right slot;
      // fall back to the session detail when no code rode along.
      if (joinCode != null && joinCode.isNotEmpty) {
        return GroupScoringRoutes.joinPreview(joinCode);
      }
      return groupId == null ? null : GroupScoringRoutes.detail(groupId);
    default:
      return null;
  }
}
