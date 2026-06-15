import 'package:flutter_test/flutter_test.dart';
import 'package:manahpro/features/group_scoring/domain/claim_success_summary.dart';

/// Sprint 15.3 — the pure parse of the approved-claim notification payload into
/// the skill-onboarding numbers the success screen renders.
void main() {
  group('ClaimSuccessSummary.fromNotificationData', () {
    test('parses the approved-claim payload', () {
      final s = ClaimSuccessSummary.fromNotificationData({
        'group_title': 'Sesi Sore Klub Rajawali',
        'total_score': 487,
        'arrows_shot': 60,
        'avg_per_arrow': 8.1,
        'is_personal_best': true,
      });

      expect(s.groupTitle, 'Sesi Sore Klub Rajawali');
      expect(s.totalScore, 487);
      expect(s.arrowsShot, 60);
      expect(s.avgPerArrow, 8.1);
      expect(s.isPersonalBest, isTrue);
      expect(s.hasNumbers, isTrue);
    });

    test('coerces an integer average from JSON', () {
      final s = ClaimSuccessSummary.fromNotificationData({
        'total_score': 27,
        'arrows_shot': 3,
        'avg_per_arrow': 9, // JSON may carry a bare int
      });
      expect(s.avgPerArrow, 9.0);
    });

    test('a null payload degrades to an empty welcome', () {
      final s = ClaimSuccessSummary.fromNotificationData(null);
      expect(s.hasNumbers, isFalse);
      expect(s.isPersonalBest, isFalse);
      expect(s.totalScore, isNull);
    });

    test('a claimed-but-empty slot has no numbers to show off', () {
      final s = ClaimSuccessSummary.fromNotificationData({
        'group_title': 'Latihan Pagi',
        'total_score': 0,
        'arrows_shot': 0,
        'is_personal_best': false,
      });
      expect(s.hasNumbers, isFalse);
      expect(s.groupTitle, 'Latihan Pagi');
    });
  });
}
