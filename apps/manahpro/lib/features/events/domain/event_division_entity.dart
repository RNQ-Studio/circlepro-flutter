import 'package:equatable/equatable.dart';
import '../../scoring/domain/scoring_enums.dart';
import 'event_enums.dart';

class EventDivisionEntity extends Equatable {
  const EventDivisionEntity({
    required this.id,
    required this.eventId,
    required this.bowClass,
    required this.gender,
    required this.ageGroup,
    required this.distanceCategory,
    required this.distanceM,
    required this.numArrows,
    required this.maxScore,
    required this.entryFee,
    this.capacity,
    required this.numParticipants,
    this.sofAvgRating,
    required this.ratingStatus,
    this.ratedAt,
  });

  final String id;
  final String eventId;
  final BowClass bowClass;
  final Gender gender;
  final AgeGroup ageGroup;
  final DistanceCategory distanceCategory;
  final int distanceM;
  final int numArrows;
  final int maxScore;
  final int entryFee; // In IDR (e.g. 150000)
  final int? capacity;
  final int numParticipants;
  final double? sofAvgRating;
  final String ratingStatus;
  final DateTime? ratedAt;

  String get displayName =>
      '${bowClass.label} - ${ageGroup.label} ${distanceCategory.label} (${gender.label})';

  @override
  List<Object?> get props => [
        id,
        eventId,
        bowClass,
        gender,
        ageGroup,
        distanceCategory,
        distanceM,
        numArrows,
        maxScore,
        entryFee,
        capacity,
        numParticipants,
        sofAvgRating,
        ratingStatus,
        ratedAt,
      ];
}
