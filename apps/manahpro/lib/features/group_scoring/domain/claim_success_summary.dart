/// The skill-onboarding numbers that ride along an approved-claim notification
/// (Sprint 15.3). The backend (`group_claim_approved` payload) attaches the
/// freshly-owned session's headline figures so the success screen can welcome a
/// new pendata archer — "PB pertamamu: 487!" — without a second round-trip.
///
/// Pure & parsed from the notification `data` map so it is fully unit testable.
class ClaimSuccessSummary {
  const ClaimSuccessSummary({
    this.groupTitle,
    this.totalScore,
    this.arrowsShot,
    this.avgPerArrow,
    this.isPersonalBest = false,
  });

  final String? groupTitle;
  final int? totalScore;
  final int? arrowsShot;
  final double? avgPerArrow;
  final bool isPersonalBest;

  /// True when the session carried real, scored arrows — enough to celebrate a
  /// total and an average. A claimed-but-empty slot has nothing to show off, so
  /// the screen falls back to a plain warm welcome.
  bool get hasNumbers =>
      totalScore != null && arrowsShot != null && arrowsShot! > 0;

  factory ClaimSuccessSummary.fromNotificationData(Map<String, dynamic>? data) {
    if (data == null) return const ClaimSuccessSummary();
    return ClaimSuccessSummary(
      groupTitle: data['group_title'] as String?,
      totalScore: (data['total_score'] as num?)?.toInt(),
      arrowsShot: (data['arrows_shot'] as num?)?.toInt(),
      avgPerArrow: (data['avg_per_arrow'] as num?)?.toDouble(),
      isPersonalBest: data['is_personal_best'] as bool? ?? false,
    );
  }
}
