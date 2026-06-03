import '../domain/event_leaderboard_entry.dart';

EventLeaderboardEntry eventLeaderboardEntryFromJson(Map<String, dynamic> json) {
  return EventLeaderboardEntry(
    sessionId: json['session_id'] as String,
    userId: json['user_id'] as int,
    userName: json['user_name'] as String? ?? '',
    bibNumber: json['bib_number'] as String?,
    targetButt: json['target_butt'] as int?,
    targetLetter: json['target_letter'] as String?,
    totalScore: json['total_score'] as int? ?? 0,
    xCount: json['x_count'] as int? ?? 0,
    tenCount: json['ten_count'] as int? ?? 0,
    missCount: json['miss_count'] as int? ?? 0,
    arrowsShot: json['arrows_shot'] as int? ?? 0,
    avgPerArrow: (json['avg_per_arrow'] as num?)?.toDouble() ?? 0.0,
  );
}
