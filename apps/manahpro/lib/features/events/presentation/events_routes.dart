import 'package:go_router/go_router.dart';

import 'screens/create_event_screen.dart';
import 'screens/event_detail_screen.dart';
import 'screens/event_discovery_screen.dart';
import 'screens/my_events_screen.dart';
import 'screens/participant_management_screen.dart';
import 'screens/registration_flow_screen.dart';
import 'screens/ticket_detail_screen.dart';
import 'screens/live_scoreboard_screen.dart';
import 'screens/scorer_target_selector_screen.dart';
import 'screens/multi_archer_scorer_screen.dart';
import 'screens/digital_scorecard_screen.dart';
import 'screens/national_leaderboard_screen.dart';
import 'screens/rating_history_screen.dart';

/// Route paths for the events feature. Declared app-level.
abstract final class EventsRoutes {
  static const String discovery = '/events';
  static const String create = '/events/create';
  static const String my = '/events/my';

  static String detail(String eventId) => '/events/$eventId';
}

/// GoRoutes for the events feature, spread into the app router.
final List<RouteBase> eventsRoutes = [
  GoRoute(
    path: EventsRoutes.discovery,
    builder: (context, state) => const EventDiscoveryScreen(),
  ),
  GoRoute(
    path: EventsRoutes.create,
    builder: (context, state) => const CreateEventScreen(),
  ),
  GoRoute(
    path: EventsRoutes.my,
    builder: (context, state) => const MyEventsScreen(),
  ),
  GoRoute(
    path: '/events/:id',
    builder: (context, state) => EventDetailScreen(
      eventId: state.pathParameters['id']!,
    ),
  ),
  GoRoute(
    path: '/events/:id/register',
    builder: (context, state) => RegistrationFlowScreen(
      eventId: state.pathParameters['id']!,
    ),
  ),
  GoRoute(
    path: '/tickets/:id',
    builder: (context, state) => TicketDetailScreen(
      ticketId: state.pathParameters['id']!,
    ),
  ),
  GoRoute(
    path: '/events/:id/participants',
    builder: (context, state) => ParticipantManagementScreen(
      eventId: state.pathParameters['id']!,
    ),
  ),
  GoRoute(
    path: '/events/:id/leaderboard',
    builder: (context, state) => LiveScoreboardScreen(
      eventId: state.pathParameters['id']!,
    ),
  ),
  GoRoute(
    path: '/events/:id/scorer',
    builder: (context, state) => ScorerTargetSelectorScreen(
      eventId: state.pathParameters['id']!,
    ),
  ),
  GoRoute(
    path: '/events/:id/scorer/:divId/:target',
    builder: (context, state) => MultiArcherScorerScreen(
      eventId: state.pathParameters['id']!,
      divisionId: state.pathParameters['divId']!,
      targetButt: int.parse(state.pathParameters['target']!),
    ),
  ),
  GoRoute(
    path: '/tickets/:id/scorecard',
    builder: (context, state) => DigitalScorecardScreen(
      ticketId: state.pathParameters['id']!,
    ),
  ),
  GoRoute(
    path: '/leaderboard',
    builder: (context, state) => const NationalLeaderboardScreen(),
  ),
  GoRoute(
    path: '/profiles/:userId/ratings/:ratingId',
    builder: (context, state) => RatingHistoryScreen(
      userId: state.pathParameters['userId']!,
      ratingId: state.pathParameters['ratingId']!,
    ),
  ),
];
