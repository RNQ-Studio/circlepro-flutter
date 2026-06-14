import 'package:go_router/go_router.dart';

import '../domain/group_entities.dart';
import 'screens/create_group_screen.dart';
import 'screens/group_created_screen.dart';
import 'screens/group_list_screen.dart';
import 'screens/host_board_screen.dart';

/// Route paths for the Latihan Bersama (group scoring) feature. Declared
/// app-level (not in core's shared AppRoutes, which the `variant` flavor uses).
abstract final class GroupScoringRoutes {
  static const String list = '/group-scoring';
  static const String create = '/group-scoring/create';

  static String created(String groupId) => '/group-scoring/$groupId/created';

  /// The host board (Sprint 05) — end-by-end scoring for the whole roster.
  static String board(String groupId) => '/group-scoring/$groupId/board';
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
    builder: (context, state) =>
        HostBoardScreen(groupId: state.pathParameters['id']!),
  ),
];
