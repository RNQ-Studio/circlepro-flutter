import 'package:equatable/equatable.dart';

import '../../scoring/domain/scoring_enums.dart';

/// Lifecycle of a guest-slot claim (mirrors backend `ClaimStatus`, Sprint 13).
/// A `null` from the API means "I have no claim on this slot yet".
enum ClaimStatus {
  pending('pending', 'Menunggu persetujuan host'),
  approved('approved', 'Disetujui'),
  rejected('rejected', 'Ditolak'),
  cancelled('cancelled', 'Dibatalkan');

  const ClaimStatus(this.value, this.label);

  final String value;
  final String label;

  static ClaimStatus? fromValue(String? value) {
    if (value == null) return null;
    for (final s in ClaimStatus.values) {
      if (s.value == value) return s;
    }
    return null;
  }
}

/// A guest slot a code-holder may claim as their own ("Ini Saya" — Sprint 14,
/// task 14.1). Sourced from `GET /groups/{group}/claimable-slots`, it carries
/// the slot's score so the archer recognises it, plus [myClaimStatus] so the
/// app paints the "Menunggu persetujuan host" badge without a second call.
class ClaimableSlot extends Equatable {
  const ClaimableSlot({
    required this.sessionId,
    this.displayName,
    this.startedAt,
    this.distanceCategory,
    this.distanceM,
    this.targetFaceCm,
    this.status,
    this.totalScore = 0,
    this.arrowsShot = 0,
    this.xCount = 0,
    this.tenCount = 0,
    this.myClaimStatus,
    this.myClaimId,
  });

  final String sessionId;
  final String? displayName;
  final DateTime? startedAt;
  final DistanceCategory? distanceCategory;
  final int? distanceM;
  final int? targetFaceCm;
  final ScoringSessionStatus? status;
  final int totalScore;
  final int arrowsShot;
  final int xCount;
  final int tenCount;

  /// This user's own claim on the slot, or null when they have not claimed it.
  final ClaimStatus? myClaimStatus;
  final String? myClaimId;

  /// A claim I already submitted that is still awaiting the host's decision.
  bool get isPendingMine => myClaimStatus == ClaimStatus.pending;

  /// Has any arrow at all — a zero-arrow slot shows "—", never a shaming 0.
  bool get hasStarted => arrowsShot > 0;

  String labelOr(String fallback) =>
      (displayName != null && displayName!.isNotEmpty) ? displayName! : fallback;

  factory ClaimableSlot.fromJson(Map<String, dynamic> json) {
    final distanceValue = json['distance_category'] as String?;
    final statusValue = json['status'] as String?;
    return ClaimableSlot(
      sessionId: json['session_id'] as String? ?? '',
      displayName: json['display_name'] as String?,
      startedAt: json['started_at'] != null
          ? DateTime.tryParse(json['started_at'] as String)
          : null,
      distanceCategory: distanceValue != null
          ? DistanceCategory.fromValue(distanceValue)
          : null,
      distanceM: (json['distance_m'] as num?)?.toInt(),
      targetFaceCm: (json['target_face_cm'] as num?)?.toInt(),
      status: statusValue != null
          ? ScoringSessionStatus.fromValue(statusValue)
          : null,
      totalScore: (json['total_score'] as num?)?.toInt() ?? 0,
      arrowsShot: (json['arrows_shot'] as num?)?.toInt() ?? 0,
      xCount: (json['x_count'] as num?)?.toInt() ?? 0,
      tenCount: (json['ten_count'] as num?)?.toInt() ?? 0,
      myClaimStatus: ClaimStatus.fromValue(json['my_claim_status'] as String?),
      myClaimId: json['my_claim_id'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        sessionId,
        displayName,
        startedAt,
        distanceCategory,
        distanceM,
        targetFaceCm,
        status,
        totalScore,
        arrowsShot,
        xCount,
        tenCount,
        myClaimStatus,
        myClaimId,
      ];
}

/// One claim awaiting a host's decision, as shown in the host inbox (Sprint 14,
/// task 14.3). Sourced from `GET /groups/{group}/claims`; the `slot` block is
/// the rich context (score, distance, when) that lets the host decide from
/// memory rather than a guess (the backend's 13.2 design).
class HostClaim extends Equatable {
  const HostClaim({
    required this.id,
    required this.groupId,
    required this.sessionId,
    required this.status,
    this.statusLabel,
    this.message,
    this.claimantId,
    this.claimantName,
    this.createdAt,
    this.resolvedAt,
    this.slot,
  });

  final String id;
  final String groupId;
  final String sessionId;
  final ClaimStatus status;
  final String? statusLabel;
  final String? message;
  final int? claimantId;
  final String? claimantName;
  final DateTime? createdAt;
  final DateTime? resolvedAt;

  /// Rich slot context for the inbox card (only present when eager-loaded).
  final ClaimSlotContext? slot;

  bool get isPending => status == ClaimStatus.pending;

  factory HostClaim.fromJson(Map<String, dynamic> json) {
    final claimant = json['claimant'] as Map<String, dynamic>?;
    final slotJson = json['slot'] as Map<String, dynamic>?;
    return HostClaim(
      id: json['id'] as String? ?? '',
      groupId: json['group_id'] as String? ?? '',
      sessionId: json['session_id'] as String? ?? '',
      status: ClaimStatus.fromValue(json['status'] as String?) ??
          ClaimStatus.pending,
      statusLabel: json['status_label'] as String?,
      message: json['message'] as String?,
      claimantId: (claimant?['id'] as num?)?.toInt(),
      claimantName: claimant?['name'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      resolvedAt: json['resolved_at'] != null
          ? DateTime.tryParse(json['resolved_at'] as String)
          : null,
      slot: slotJson != null ? ClaimSlotContext.fromJson(slotJson) : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        groupId,
        sessionId,
        status,
        statusLabel,
        message,
        claimantId,
        claimantName,
        createdAt,
        resolvedAt,
        slot,
      ];
}

/// The slot context block carried by a host-inbox claim (backend 13.2).
class ClaimSlotContext extends Equatable {
  const ClaimSlotContext({
    required this.sessionId,
    this.displayName,
    this.startedAt,
    this.distanceCategory,
    this.distanceM,
    this.totalScore = 0,
    this.arrowsShot = 0,
    this.xCount = 0,
    this.tenCount = 0,
    this.isPersonalBest = false,
  });

  final String sessionId;
  final String? displayName;
  final DateTime? startedAt;
  final DistanceCategory? distanceCategory;
  final int? distanceM;
  final int totalScore;
  final int arrowsShot;
  final int xCount;
  final int tenCount;
  final bool isPersonalBest;

  bool get hasStarted => arrowsShot > 0;

  factory ClaimSlotContext.fromJson(Map<String, dynamic> json) {
    final distanceValue = json['distance_category'] as String?;
    return ClaimSlotContext(
      sessionId: json['session_id'] as String? ?? '',
      displayName: json['display_name'] as String?,
      startedAt: json['started_at'] != null
          ? DateTime.tryParse(json['started_at'] as String)
          : null,
      distanceCategory: distanceValue != null
          ? DistanceCategory.fromValue(distanceValue)
          : null,
      distanceM: (json['distance_m'] as num?)?.toInt(),
      totalScore: (json['total_score'] as num?)?.toInt() ?? 0,
      arrowsShot: (json['arrows_shot'] as num?)?.toInt() ?? 0,
      xCount: (json['x_count'] as num?)?.toInt() ?? 0,
      tenCount: (json['ten_count'] as num?)?.toInt() ?? 0,
      isPersonalBest: json['is_personal_best'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
        sessionId,
        displayName,
        startedAt,
        distanceCategory,
        distanceM,
        totalScore,
        arrowsShot,
        xCount,
        tenCount,
        isPersonalBest,
      ];
}
