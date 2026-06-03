import '../domain/rating_history_entry.dart';

RatingHistoryEntry ratingHistoryEntryFromJson(Map<String, dynamic> json) {
  return RatingHistoryEntry(
    id: json['id'] as String,
    ratingId: json['rating_id'] as String? ?? '',
    userId: json['user_id'] as int,
    muBefore: (json['mu_before'] as num?)?.toDouble() ?? 1500.0,
    muAfter: (json['mu_after'] as num?)?.toDouble() ?? 1500.0,
    phiBefore: (json['phi_before'] as num?)?.toDouble() ?? 350.0,
    phiAfter: (json['phi_after'] as num?)?.toDouble() ?? 350.0,
    sigmaBefore: (json['sigma_before'] as num?)?.toDouble() ?? 0.06,
    sigmaAfter: (json['sigma_after'] as num?)?.toDouble() ?? 0.06,
    displayBefore: (json['display_before'] as num?)?.toDouble() ?? 800.0,
    displayAfter: (json['display_after'] as num?)?.toDouble() ?? 800.0,
    displayChange: (json['display_change'] as num?)?.toDouble() ?? 0.0,
    scoreAchieved: json['score_achieved'] as int?,
    nps: (json['nps'] as num?)?.toDouble(),
    placement: json['placement'] as int?,
    numParticipants: json['num_participants'] as int?,
    eventTier: json['event_tier'] as String?,
    kEffective: (json['k_effective'] as num?)?.toDouble(),
    isManualOverride: json['is_manual_override'] as bool? ?? false,
    eventId: json['event_id'] as String?,
    eventName: json['event_name'] as String?,
    divisionName: json['division_name'] as String?,
    computedAt: DateTime.parse(json['computed_at'] as String),
  );
}
