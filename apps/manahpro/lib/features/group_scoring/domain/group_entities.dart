import 'package:equatable/equatable.dart';

import '../../scoring/domain/scoring_enums.dart';

/// A "Latihan Bersama" (group scoring) session — the binder over individual
/// scoring sessions (§1 arsitektur-dan-keputusan.md). It is *not* a new scoring
/// engine; each participant is a normal `scoring_sessions` row that shares this
/// group's `join_code` and round format.
class ScoringGroupEntity extends Equatable {
  const ScoringGroupEntity({
    required this.id,
    required this.joinCode,
    required this.hostUserId,
    required this.distanceCategory,
    required this.distanceM,
    required this.numEnds,
    required this.arrowsPerEnd,
    required this.startedAt,
    this.title,
    this.hostName,
    this.environment = ArcheryEnvironment.outdoor,
    this.targetFaceCm,
    this.targetFaceId,
    this.status = ScoringSessionStatus.inProgress,
    this.participantCount = 0,
    this.completedAt,
    this.participants = const [],
  });

  final String id;
  final String joinCode;
  final int hostUserId;
  final String? hostName;
  final String? title;
  final DistanceCategory distanceCategory;
  final int distanceM;
  final ArcheryEnvironment environment;
  final int? targetFaceCm;
  final String? targetFaceId;
  final int numEnds;
  final int arrowsPerEnd;
  final ScoringSessionStatus status;
  final int participantCount;
  final DateTime startedAt;
  final DateTime? completedAt;
  final List<GroupParticipantEntity> participants;

  int get plannedArrows => numEnds * arrowsPerEnd;

  factory ScoringGroupEntity.fromJson(Map<String, dynamic> json) {
    final host = json['host'] as Map<String, dynamic>?;
    final participantsJson = json['participants'] as List<dynamic>? ?? const [];
    return ScoringGroupEntity(
      id: json['id'] as String? ?? '',
      joinCode: json['join_code'] as String? ?? '',
      hostUserId: (host?['id'] as num?)?.toInt() ?? 0,
      hostName: host?['name'] as String?,
      title: json['title'] as String?,
      distanceCategory:
          DistanceCategory.fromValue(json['distance_category'] as String?),
      distanceM: (json['distance_m'] as num?)?.toInt() ?? 0,
      environment: ArcheryEnvironment.fromValue(json['environment'] as String?),
      targetFaceCm: (json['target_face_cm'] as num?)?.toInt(),
      targetFaceId: json['target_face_id'] as String?,
      numEnds: (json['num_ends'] as num?)?.toInt() ?? 0,
      arrowsPerEnd: (json['arrows_per_end'] as num?)?.toInt() ?? 6,
      status: ScoringSessionStatus.fromValue(json['status'] as String?),
      participantCount: (json['participant_count'] as num?)?.toInt() ?? 0,
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'] as String)
          : DateTime.now(),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      participants: participantsJson
          .map(
              (e) => GroupParticipantEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        joinCode,
        hostUserId,
        title,
        distanceCategory,
        distanceM,
        environment,
        targetFaceCm,
        targetFaceId,
        numEnds,
        arrowsPerEnd,
        status,
        participantCount,
        startedAt,
        completedAt,
        participants,
      ];
}

/// One roster entry of a group. Mirrors the backend `GroupParticipantResource`
/// — an owned or guest `scoring_sessions` row, with cached aggregates.
class GroupParticipantEntity extends Equatable {
  const GroupParticipantEntity({
    required this.id,
    this.userId,
    this.displayName,
    this.guestName,
    this.isGuest = false,
    this.bowClass,
    this.distanceM,
    this.totalScore = 0,
    this.maxPossibleScore,
    this.arrowsShot = 0,
    this.xCount = 0,
    this.tenCount = 0,
    this.status,
  });

  final String id;
  final int? userId;
  final String? displayName;
  final String? guestName;
  final bool isGuest;
  final BowClass? bowClass;
  final int? distanceM;
  final int totalScore;
  final int? maxPossibleScore;
  final int arrowsShot;
  final int xCount;
  final int tenCount;
  final ScoringSessionStatus? status;

  factory GroupParticipantEntity.fromJson(Map<String, dynamic> json) {
    final bowClassValue = json['bow_class'] as String?;
    final statusValue = json['status'] as String?;
    return GroupParticipantEntity(
      id: json['id'] as String? ?? '',
      userId: (json['user_id'] as num?)?.toInt(),
      displayName: json['display_name'] as String?,
      guestName: json['guest_name'] as String?,
      isGuest: json['is_guest'] as bool? ?? false,
      bowClass:
          bowClassValue != null ? BowClass.fromValue(bowClassValue) : null,
      distanceM: (json['distance_m'] as num?)?.toInt(),
      totalScore: (json['total_score'] as num?)?.toInt() ?? 0,
      maxPossibleScore: (json['max_possible_score'] as num?)?.toInt(),
      arrowsShot: (json['arrows_shot'] as num?)?.toInt() ?? 0,
      xCount: (json['x_count'] as num?)?.toInt() ?? 0,
      tenCount: (json['ten_count'] as num?)?.toInt() ?? 0,
      status: statusValue != null
          ? ScoringSessionStatus.fromValue(statusValue)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        displayName,
        guestName,
        isGuest,
        bowClass,
        distanceM,
        totalScore,
        maxPossibleScore,
        arrowsShot,
        xCount,
        tenCount,
        status,
      ];
}
