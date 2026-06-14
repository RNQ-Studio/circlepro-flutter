import 'package:go_router/go_router.dart';

import '../domain/group_entities.dart';
import 'screens/create_group_screen.dart';
import 'screens/group_created_screen.dart';
import 'screens/group_detail_screen.dart';
import 'screens/group_leaderboard_screen.dart';
import 'screens/group_list_screen.dart';
import 'screens/group_result_card_screen.dart';
import 'screens/host_board_screen.dart';

/// Route paths for the Latihan Bersama (group scoring) feature. Declared
/// app-level (not in core's shared AppRoutes, which the `variant` flavor uses).
abstract final class GroupScoringRoutes {
  static const String list = '/group-scoring';
  static const String create = '/group-scoring/create';

  static String created(String groupId) => '/group-scoring/$groupId/created';

  /// The session hub (Sprint 06) — roster, running scores, share & quick-add.
  static String detail(String groupId) => '/group-scoring/$groupId';

  /// The host board (Sprint 05) — end-by-end scoring for the whole roster.
  /// Optionally focus a single participant (Sprint 06, task 6.4: tap a roster
  /// card → land on that archer).
  static String board(String groupId, {String? participantId}) {
    final base = '/group-scoring/$groupId/board';
    return participantId == null ? base : '$base?participant=$participantId';
  }

  /// The session leaderboard (Sprint 07) — fair ranking + drill-down + share.
  static String leaderboard(String groupId) =>
      '/group-scoring/$groupId/leaderboard';

  /// The shareable, DNF-friendly result card preview (Sprint 07).
  static String resultCard(String groupId) =>
      '/group-scoring/$groupId/result-card';
}

/// GoRoutes for the group scoring feature, spread into the app router.
final List<RouteBase> groupScoringRoutes = [
  GoRoute(
    path: GroupScoringRoutes.list,
    builder: (context, state) => const GroupListScreen(),
  ),
  GoRoute(
    path: GroupScoringRoutes.create,
    builder: (context, state) => const CreateGroupScreen(),
  ),
  GoRoute(
    path: '/group-scoring/:id/created',
    builder: (context, state) {
      // The freshly created group is passed via `extra` to avoid a re-fetch.
      final group = state.extra as ScoringGroupEntity?;
      return GroupCreatedScreen(
        groupId: state.pathParameters['id']!,
        group: group,
      );
    },
  ),
  GoRoute(
    path: '/group-scoring/:id/board',
    builder: (context, state) => HostBoardScreen(
      groupId: state.pathParameters['id']!,
      focusParticipantId: state.uri.queryParameters['participant'],
    ),
  ),
  GoRoute(
    path: '/group-scoring/:id/leaderboard',
    builder: (context, state) =>
        GroupLeaderboardScreen(groupId: state.pathParameters['id']!),
  ),
  GoRoute(
    path: '/group-scoring/:id/result-card',
    builder: (context, state) =>
        GroupResultCardScreen(groupId: state.pathParameters['id']!),
  ),
  // Keep the bare `/:id` (detail hub) **last** so the more specific
  // `/created` and `/board` segments match first.
  GoRoute(
    path: '/group-scoring/:id',
    builder: (context, state) =>
        GroupDetailScreen(groupId: state.pathParameters['id']!),
  ),
];
