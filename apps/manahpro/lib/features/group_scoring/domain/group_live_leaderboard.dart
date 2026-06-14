import 'package:equatable/equatable.dart';

import '../../scoring/domain/scoring_enums.dart';

/// One server-computed, ranked row of the live leaderboard (Sprint 11). Unlike
/// [BoardParticipant] (derived from *this device's* local arrows), these figures
/// are the backend's fair aggregate across **every** device that has synced —
/// the only honest source for a multi-device board (task 11.5). It carries no
/// per-arrow detail; drill-down still reads the local store when present.
class LiveLeaderboardEntry extends Equatable {
  const LiveLeaderboardEntry({
    required this.rank,
    required this.sessionId,
    required this.totalScore,
    required this.xCount,
    required this.tenCount,
    required this.arrowsShot,
    required this.validatedEnds,
    required this.targetEnds,
    required this.comparableTotal,
    required this.isComplete,
    required this.tied,
    required this.isProvisionalLeader,
    this.userId,
    this.isGuest = false,
    this.displayName,
    this.bowClass,
    this.status,
  });

  final int rank;
  final String sessionId;
  final int? userId;
  final bool isGuest;
  final String? displayName;
  final BowClass? bowClass;
  final ScoringSessionStatus? status;
  final int totalScore;
  final int xCount;
  final int tenCount;
  final int arrowsShot;

  /// Rounds this archer has shot to completion (the live frontier per-row).
  final int validatedEnds;
  final int targetEnds;

  /// Honest live figure: total on the number of rounds shared by all racers.
  final int comparableTotal;
  final bool isComplete;

  /// Shares its rank with another row (a genuine SERI on total → X → 10).
  final bool tied;

  /// Sole rank-1 row while the round is still provisional — the UI may label it
  /// "memimpin sementara" (never "winner", never "live race" — task 11.4).
  final bool isProvisionalLeader;

  /// Has any arrow at all — a zero-arrow row shows "—", never a shaming 0.
  bool get hasStarted => arrowsShot > 0;

  factory LiveLeaderboardEntry.fromJson(Map<String, dynamic> json) {
    final bowClassValue = json['bow_class'] as String?;
    final statusValue = json['status'] as String?;
    return LiveLeaderboardEntry(
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      sessionId: json['session_id'] as String? ?? '',
      userId: (json['user_id'] as num?)?.toInt(),
      isGuest: json['is_guest'] as bool? ?? false,
      displayName: json['display_name'] as String?,
      bowClass:
          bowClassValue != null ? BowClass.fromValue(bowClassValue) : null,
      status: statusValue != null
          ? ScoringSessionStatus.fromValue(statusValue)
          : null,
      totalScore: (json['total_score'] as num?)?.toInt() ?? 0,
      xCount: (json['x_count'] as num?)?.toInt() ?? 0,
      tenCount: (json['ten_count'] as num?)?.toInt() ?? 0,
      arrowsShot: (json['arrows_shot'] as num?)?.toInt() ?? 0,
      validatedEnds: (json['validated_ends'] as num?)?.toInt() ?? 0,
      targetEnds: (json['target_ends'] as num?)?.toInt() ?? 0,
      comparableTotal: (json['comparable_total'] as num?)?.toInt() ?? 0,
      isComplete: json['is_complete'] as bool? ?? false,
      tied: json['tied'] as bool? ?? false,
      isProvisionalLeader: json['is_provisional_leader'] as bool? ?? false,
    );
  }

  /// Best display label, falling back to [fallback] for the caller's own row.
  String labelOr(String fallback) => displayName ?? fallback;

  @override
  List<Object?> get props => [
        rank,
        sessionId,
        userId,
        isGuest,
        displayName,
        bowClass,
        status,
        totalScore,
        xCount,
        tenCount,
        arrowsShot,
        validatedEnds,
        targetEnds,
        comparableTotal,
        isComplete,
        tied,
        isProvisionalLeader,
      ];
}

/// A single response from the live leaderboard endpoint (Sprint 11).
///
/// When [unchanged] is true the server short-circuited on the polling cursor:
/// [entries] is empty and the caller keeps its previous board (the cheap, idle
/// path that spends almost no bandwidth — DoD "tidak ada drain saat tak
/// berubah"). When false, [entries] is the fresh fair board.
class LiveLeaderboardSnapshot extends Equatable {
  const LiveLeaderboardSnapshot({
    required this.version,
    required this.unchanged,
    this.entries = const [],
    this.groupStatus,
    this.allCompleted = false,
    this.isProvisional = false,
    this.comparableEnds = 0,
    this.targetEnds = 0,
    this.participantCount = 0,
  });

  final String? version;
  final bool unchanged;
  final List<LiveLeaderboardEntry> entries;

  /// The group's lifecycle (in_progress / completed / abandoned). Drives the
  /// lifecycle-aware poll: once it leaves in_progress the client stops (11.2).
  final ScoringSessionStatus? groupStatus;
  final bool allCompleted;
  final bool isProvisional;
  final int comparableEnds;
  final int targetEnds;
  final int participantCount;

  /// Whether the session is still live and worth polling.
  bool get isLive => groupStatus == ScoringSessionStatus.inProgress;

  /// Parse the full `{ data: { entries }, meta }` ApiResponse envelope.
  factory LiveLeaderboardSnapshot.fromEnvelope(Map<String, dynamic> body) {
    final meta = body['meta'] as Map<String, dynamic>? ?? const {};
    final data = body['data'] as Map<String, dynamic>? ?? const {};
    final unchanged = meta['unchanged'] as bool? ?? false;
    final entriesJson = data['entries'] as List<dynamic>? ?? const [];
    final statusValue = meta['group_status'] as String?;

    return LiveLeaderboardSnapshot(
      version: meta['version'] as String?,
      unchanged: unchanged,
      entries: entriesJson
          .map((e) => LiveLeaderboardEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      groupStatus: statusValue != null
          ? ScoringSessionStatus.fromValue(statusValue)
          : null,
      allCompleted: meta['all_completed'] as bool? ?? false,
      isProvisional: meta['is_provisional'] as bool? ?? false,
      comparableEnds: (meta['comparable_ends'] as num?)?.toInt() ?? 0,
      targetEnds: (meta['target_ends'] as num?)?.toInt() ?? 0,
      participantCount: (meta['participant_count'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        version,
        unchanged,
        entries,
        groupStatus,
        allCompleted,
        isProvisional,
        comparableEnds,
        targetEnds,
        participantCount,
      ];
}
