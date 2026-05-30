import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/scoring_entities.dart';
import '../domain/scoring_enums.dart';
import 'scoring_providers.dart';

part 'dashboard_provider.g.dart';

/// One point on the progress trend (one completed session).
class TrendPoint {
  const TrendPoint({required this.date, required this.avgPerArrow, required this.totalScore});

  final DateTime date;
  final double avgPerArrow;
  final int totalScore;
}

/// Aggregated progress stats, derived locally from offline sessions
/// (offline-first; mirrors the backend `/scoring/dashboard`). Task 1.9/1.10.
class DashboardStats {
  const DashboardStats({
    required this.totalSessions,
    required this.totalArrows,
    required this.totalScore,
    required this.overallAvgPerArrow,
    required this.bestScore,
    required this.currentStreakDays,
    required this.trend,
  });

  final int totalSessions;
  final int totalArrows;
  final int totalScore;
  final double? overallAvgPerArrow;
  final int? bestScore;
  final int currentStreakDays;
  final List<TrendPoint> trend;

  bool get isEmpty => totalSessions == 0;
}

@riverpod
Future<DashboardStats> dashboardStats(Ref ref) async {
  final sessions = await ref.watch(sessionsListProvider.future);

  final completed = sessions
      .where((s) => s.status == ScoringSessionStatus.completed && s.arrowsShot > 0)
      .toList()
    ..sort((a, b) => a.startedAt.compareTo(b.startedAt));

  final totalArrows = completed.fold<int>(0, (sum, s) => sum + s.arrowsShot);
  final totalScore = completed.fold<int>(0, (sum, s) => sum + s.totalScore);

  return DashboardStats(
    totalSessions: completed.length,
    totalArrows: totalArrows,
    totalScore: totalScore,
    overallAvgPerArrow: totalArrows > 0 ? totalScore / totalArrows : null,
    bestScore: completed.isEmpty ? null : completed.map((s) => s.totalScore).reduce((a, b) => a > b ? a : b),
    currentStreakDays: _streak(sessions),
    trend: completed
        .map((s) => TrendPoint(
              date: s.startedAt,
              avgPerArrow: s.avgPerArrow ?? 0,
              totalScore: s.totalScore,
            ))
        .toList(),
  );
}

/// Consecutive days (ending today or yesterday) with at least one session.
int _streak(List<ScoringSessionEntity> sessions) {
  if (sessions.isEmpty) return 0;

  final days = sessions
      .map((s) => DateTime(s.startedAt.year, s.startedAt.month, s.startedAt.day))
      .toSet()
      .toList()
    ..sort((a, b) => b.compareTo(a));

  final today = DateTime.now();
  final todayKey = DateTime(today.year, today.month, today.day);
  final yesterdayKey = todayKey.subtract(const Duration(days: 1));

  if (days.first != todayKey && days.first != yesterdayKey) return 0;

  var streak = 0;
  var cursor = days.first;
  for (final day in days) {
    if (day == cursor) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    } else {
      break;
    }
  }
  return streak;
}
