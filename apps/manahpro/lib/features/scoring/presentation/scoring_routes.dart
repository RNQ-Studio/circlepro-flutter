import 'package:go_router/go_router.dart';

import 'screens/bow_setup_screen.dart';
import 'screens/history_screen.dart';
import 'screens/progress_dashboard_screen.dart';
import 'screens/score_input_screen.dart';
import 'screens/scorecard_preview_screen.dart';
import 'screens/scoring_setup_screen.dart';
import 'screens/session_summary_screen.dart';

/// Route paths for the scoring feature. Declared app-level (not in core's
/// shared AppRoutes, which the `variant` flavor also uses).
abstract final class ScoringRoutes {
  static const String setup = '/scoring/setup';
  static const String history = '/scoring/history';
  static const String dashboard = '/scoring/dashboard';
  static const String equipment = '/scoring/equipment';

  static String input(String sessionId) => '/scoring/session/$sessionId';

  static String summary(String sessionId) => '/scoring/session/$sessionId/summary';

  static String scorecard(String sessionId) => '/scoring/session/$sessionId/scorecard';
}

/// GoRoutes for the scoring feature, spread into the app router.
final List<RouteBase> scoringRoutes = [
  GoRoute(
    path: ScoringRoutes.setup,
    builder: (context, state) => const ScoringSetupScreen(),
  ),
  GoRoute(
    path: ScoringRoutes.history,
    builder: (context, state) => const HistoryScreen(),
  ),
  GoRoute(
    path: ScoringRoutes.dashboard,
    builder: (context, state) => const ProgressDashboardScreen(),
  ),
  GoRoute(
    path: ScoringRoutes.equipment,
    builder: (context, state) => const BowSetupScreen(),
  ),
  GoRoute(
    path: '/scoring/session/:id',
    builder: (context, state) => ScoreInputScreen(sessionId: state.pathParameters['id']!),
  ),
  GoRoute(
    path: '/scoring/session/:id/summary',
    builder: (context, state) => SessionSummaryScreen(sessionId: state.pathParameters['id']!),
  ),
  GoRoute(
    path: '/scoring/session/:id/scorecard',
    builder: (context, state) => ScorecardPreviewScreen(sessionId: state.pathParameters['id']!),
  ),
];
