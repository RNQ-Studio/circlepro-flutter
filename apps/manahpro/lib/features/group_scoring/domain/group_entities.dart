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
    this.distanceCategory,
    this.distanceM,
    this.targetFaceCm,
    this.targetButt,
    this.targetLetter,
    this.lastScoredByUserId,
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
  final DistanceCategory? distanceCategory;
  final int? distanceM;
  final int? targetFaceCm;
  final int? targetButt;
  final String? targetLetter;
  final int? lastScoredByUserId;
  final int totalScore;
  final int? maxPossibleScore;
  final int arrowsShot;
  final int xCount;
  final int tenCount;
  final ScoringSessionStatus? status;

  String get targetLabel {
    if (targetButt == null) return '-';
    final letter = targetLetter?.trim();
    return letter == null || letter.isEmpty
        ? '$targetButt'
        : '$targetButt$letter';
  }

  String get distanceLabel {
    final distance = distanceM;
    if (distance == null) return '-';
    final face = targetFaceCm;
    return face == null ? '$distance m' : '$distance m / $face cm';
  }

  factory GroupParticipantEntity.fromJson(Map<String, dynamic> json) {
    final bowClassValue = json['bow_class'] as String?;
    final distanceCategoryValue = json['distance_category'] as String?;
    final statusValue = json['status'] as String?;
    return GroupParticipantEntity(
      id: json['id'] as String? ?? '',
      userId: (json['user_id'] as num?)?.toInt(),
      displayName: json['display_name'] as String?,
      guestName: json['guest_name'] as String?,
      isGuest: json['is_guest'] as bool? ?? false,
      bowClass:
          bowClassValue != null ? BowClass.fromValue(bowClassValue) : null,
      distanceCategory: distanceCategoryValue != null
          ? DistanceCategory.fromValue(distanceCategoryValue)
          : null,
      distanceM: (json['distance_m'] as num?)?.toInt(),
      targetFaceCm: (json['target_face_cm'] as num?)?.toInt(),
      targetButt: (json['target_butt'] as num?)?.toInt(),
      targetLetter: json['target_letter'] as String?,
      lastScoredByUserId: (json['last_scored_by_user_id'] as num?)?.toInt(),
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
        distanceCategory,
        distanceM,
        targetFaceCm,
        targetButt,
        targetLetter,
        lastScoredByUserId,
        totalScore,
        maxPossibleScore,
        arrowsShot,
        xCount,
        tenCount,
        status,
      ];
}

class GroupScorerEntity extends Equatable {
  const GroupScorerEntity({
    required this.id,
    required this.userId,
    required this.targetButt,
    required this.assignmentType,
    this.name,
  });

  final String id;
  final int userId;
  final int targetButt;
  final String assignmentType;
  final String? name;

  factory GroupScorerEntity.fromJson(Map<String, dynamic> json) {
    final scorer = json['scorer'] as Map<String, dynamic>?;
    return GroupScorerEntity(
      id: json['id'] as String? ?? '',
      userId: (json['user_id'] as num?)?.toInt() ??
          (scorer?['id'] as num?)?.toInt() ??
          0,
      targetButt: (json['target_butt'] as num?)?.toInt() ?? 0,
      assignmentType: json['assignment_type'] as String? ?? 'assigned',
      name: scorer?['name'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, userId, targetButt, assignmentType, name];
}

class GroupButtEntity extends Equatable {
  const GroupButtEntity({
    required this.targetButt,
    required this.participantCount,
    required this.completedCount,
    required this.submittedCount,
    required this.pendingCount,
    required this.endProgress,
    required this.maxEndProgress,
    required this.targetEnds,
    required this.isComplete,
    required this.totalScore,
    required this.laggingByEnds,
    required this.isLagging,
    this.currentEnd,
    this.scorer,
    this.participants = const [],
  });

  final int? targetButt;
  final int participantCount;
  final int completedCount;
  final int submittedCount;
  final int pendingCount;
  final int endProgress;
  final int maxEndProgress;
  final int? currentEnd;
  final int targetEnds;
  final bool isComplete;
  final int totalScore;
  final int laggingByEnds;
  final bool isLagging;
  final GroupScorerEntity? scorer;
  final List<GroupParticipantEntity> participants;

  String get label =>
      targetButt == null ? 'Belum dipetakan' : 'Bantalan $targetButt';

  String get progressLabel => '$endProgress/$targetEnds';

  bool get canClaim => targetButt != null && scorer == null;

  factory GroupButtEntity.fromJson(Map<String, dynamic> json) {
    final scorerJson = json['scorer'] as Map<String, dynamic>?;
    final participantsJson = json['participants'] as List<dynamic>? ?? const [];
    return GroupButtEntity(
      targetButt: (json['target_butt'] as num?)?.toInt(),
      participantCount: (json['participant_count'] as num?)?.toInt() ?? 0,
      completedCount: (json['completed_count'] as num?)?.toInt() ?? 0,
      submittedCount: (json['submitted_count'] as num?)?.toInt() ?? 0,
      pendingCount: (json['pending_count'] as num?)?.toInt() ?? 0,
      endProgress: (json['end_progress'] as num?)?.toInt() ?? 0,
      maxEndProgress: (json['max_end_progress'] as num?)?.toInt() ?? 0,
      currentEnd: (json['current_end'] as num?)?.toInt(),
      targetEnds: (json['target_ends'] as num?)?.toInt() ?? 0,
      isComplete: json['is_complete'] as bool? ?? false,
      totalScore: (json['total_score'] as num?)?.toInt() ?? 0,
      laggingByEnds: (json['lagging_by_ends'] as num?)?.toInt() ?? 0,
      isLagging: json['is_lagging'] as bool? ?? false,
      scorer:
          scorerJson == null ? null : GroupScorerEntity.fromJson(scorerJson),
      participants: participantsJson
          .map(
              (e) => GroupParticipantEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        targetButt,
        participantCount,
        completedCount,
        submittedCount,
        pendingCount,
        endProgress,
        maxEndProgress,
        currentEnd,
        targetEnds,
        isComplete,
        totalScore,
        laggingByEnds,
        isLagging,
        scorer,
        participants,
      ];
}

class GroupButtStatusEnvelope extends Equatable {
  const GroupButtStatusEnvelope({
    required this.butts,
    this.version,
    this.groupStatus,
    this.unchanged = false,
    this.participantCount = 0,
    this.buttCount = 0,
  });

  final List<GroupButtEntity> butts;
  final String? version;
  final ScoringSessionStatus? groupStatus;
  final bool unchanged;
  final int participantCount;
  final int buttCount;

  factory GroupButtStatusEnvelope.fromEnvelope(Map<String, dynamic> body) {
    final meta = body['meta'] as Map<String, dynamic>? ?? const {};
    final data = body['data'] as Map<String, dynamic>? ?? const {};
    final buttsJson = data['butts'] as List<dynamic>? ?? const [];
    final statusValue = meta['group_status'] as String?;
    return GroupButtStatusEnvelope(
      butts: buttsJson
          .map((e) => GroupButtEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      version: meta['version'] as String?,
      groupStatus: statusValue == null
          ? null
          : ScoringSessionStatus.fromValue(statusValue),
      unchanged: meta['unchanged'] as bool? ?? false,
      participantCount: (meta['participant_count'] as num?)?.toInt() ?? 0,
      buttCount: (meta['butt_count'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        butts,
        version,
        groupStatus,
        unchanged,
        participantCount,
        buttCount,
      ];
}
