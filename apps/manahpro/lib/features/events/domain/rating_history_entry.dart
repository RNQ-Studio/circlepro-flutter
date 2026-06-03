class RatingHistoryEntry {
  const RatingHistoryEntry({
    required this.id,
    required this.ratingId,
    required this.userId,
    required this.muBefore,
    required this.muAfter,
    required this.phiBefore,
    required this.phiAfter,
    required this.sigmaBefore,
    required this.sigmaAfter,
    required this.displayBefore,
    required this.displayAfter,
    required this.displayChange,
    this.scoreAchieved,
    this.nps,
    this.placement,
    this.numParticipants,
    this.eventTier,
    this.kEffective,
    required this.isManualOverride,
    this.eventId,
    this.eventName,
    this.divisionName,
    required this.computedAt,
  });

  final String id;
  final String ratingId;
  final int userId;
  final double muBefore;
  final double muAfter;
  final double phiBefore;
  final double phiAfter;
  final double sigmaBefore;
  final double sigmaAfter;
  final double displayBefore;
  final double displayAfter;
  final double displayChange;
  final int? scoreAchieved;
  final double? nps;
  final int? placement;
  final int? numParticipants;
  final String? eventTier;
  final double? kEffective;
  final bool isManualOverride;
  final String? eventId;
  final String? eventName;
  final String? divisionName;
  final DateTime computedAt;
}
