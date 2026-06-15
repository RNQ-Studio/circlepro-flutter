import 'package:flutter_test/flutter_test.dart';
import 'package:manahpro/features/group_scoring/presentation/claim_notification_routing.dart';

/// Sprint 14 (task 14.4) — the pure mapping from a claim notification to the
/// screen it opens. Routing is by **type**, not the bare link, so the same group
/// id sends the host to their inbox but the claimant to their session.
void main() {
  group('groupClaimNotificationRoute', () {
    test('submitted → host inbox', () {
      final route = groupClaimNotificationRoute('group_claim_submitted', {
        'group_id': 'grp123',
        'session_id': 'sess1',
        'claim_id': 'clm1',
        'join_code': 'ABC234',
      });
      expect(route, '/group-scoring/grp123/claims');
    });

    test('approved → the skill-onboarding success screen (Sprint 15.3)', () {
      final route = groupClaimNotificationRoute('group_claim_approved', {
        'group_id': 'grp123',
        'session_id': 'sess1',
        'join_code': 'ABC234',
      });
      expect(route, '/group-scoring/grp123/claim-success/sess1');
    });

    test('approved without a session id falls back to the session detail', () {
      final route = groupClaimNotificationRoute('group_claim_approved', {
        'group_id': 'grp123',
        'join_code': 'ABC234',
      });
      expect(route, '/group-scoring/grp123');
    });

    test('rejected → back to the join preview to retry', () {
      final route = groupClaimNotificationRoute('group_claim_rejected', {
        'group_id': 'grp123',
        'join_code': 'ABC234',
      });
      expect(route, '/group-scoring/preview/ABC234');
    });

    test('rejected without a code falls back to the session detail', () {
      final route = groupClaimNotificationRoute('group_claim_rejected', {
        'group_id': 'grp123',
      });
      expect(route, '/group-scoring/grp123');
    });

    test('a non-claim type returns null (caller keeps its default)', () {
      expect(groupClaimNotificationRoute('new_follower', {'x': 'y'}), isNull);
      expect(groupClaimNotificationRoute(null, null), isNull);
    });

    test('a missing group id returns null rather than a broken route', () {
      expect(
        groupClaimNotificationRoute('group_claim_submitted', {'foo': 'bar'}),
        isNull,
      );
    });
  });
}
