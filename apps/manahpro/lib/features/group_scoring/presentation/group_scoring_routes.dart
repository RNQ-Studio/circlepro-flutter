import 'package:go_router/go_router.dart';

import '../domain/claim_success_summary.dart';
import '../domain/group_entities.dart';
import 'screens/claim_success_screen.dart';
import 'screens/create_group_screen.dart';
import 'screens/group_created_screen.dart';
import 'screens/group_detail_screen.dart';
import 'screens/group_join_preview_screen.dart';
import 'screens/group_leaderboard_screen.dart';
import 'screens/group_list_screen.dart';
import 'screens/claim_inbox_screen.dart';
import 'screens/group_result_card_screen.dart';
import 'screens/host_board_screen.dart';
import 'screens/join_by_code_screen.dart';
import 'screens/scan_qr_screen.dart';
import 'screens/self_scoring_screen.dart';
import 'screens/show_qr_screen.dart';

/// Route paths for the Latihan Bersama (group scoring) feature. Declared
/// app-level (not in core's shared AppRoutes, which the `variant` flavor uses).
abstract final class GroupScoringRoutes {
  static const String list = '/group-scoring';
  static const String create = '/group-scoring/create';

  /// Typed-code fallback entry (Sprint 09, task 9.5).
  static const String joinByCode = '/group-scoring/join-by-code';

  /// QR scanner entry (Sprint 09, task 9.3).
  static const String scan = '/group-scoring/scan';

  /// The rich join preview every entry point funnels to (Sprint 09, task 9.2).
  static String joinPreview(String code) => '/group-scoring/preview/$code';

  /// Full-screen QR poster for a group (Sprint 09, task 9.3).
  static String qr(String groupId) => '/group-scoring/$groupId/qr';

  static String created(String groupId) => '/group-scoring/$groupId/created';

  /// The session hub (Sprint 06) — roster, running scores, share & quick-add.
  static String detail(String groupId) => '/group-scoring/$groupId';

  /// Self-scoring for a joined member (Sprint 10) — score my own row in the
  /// group, offline-first, with past-round correction.
  static String selfScoring(String groupId) => '/group-scoring/$groupId/me';

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

  /// The host claim inbox (Sprint 14, task 14.3) — approve/reject guest-slot
  /// claims; also the deep-link target for a `group_claim_submitted` notice.
  static String claims(String groupId) => '/group-scoring/$groupId/claims';

  /// The claim-success onboarding (Sprint 15.3) — the `group_claim_approved`
  /// notification lands here so the new owner is welcomed with their first PB /
  /// average, not a bare "berhasil". The skill numbers ride along via `extra`.
  static String claimSuccess(String groupId, String sessionId) =>
      '/group-scoring/$groupId/claim-success/$sessionId';
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
  // Join entry points (Sprint 09) — single-segment paths must precede the bare
  // `/:id` below so they are not swallowed as a group id.
  GoRoute(
    path: GroupScoringRoutes.joinByCode,
    builder: (context, state) => const JoinByCodeScreen(),
  ),
  GoRoute(
    path: GroupScoringRoutes.scan,
    builder: (context, state) => const ScanQrScreen(),
  ),
  GoRoute(
    path: '/group-scoring/preview/:code',
    builder: (context, state) =>
        GroupJoinPreviewScreen(code: state.pathParameters['code']!),
  ),
  GoRoute(
    path: '/group-scoring/:id/qr',
    builder: (context, state) =>
        ShowQrScreen(groupId: state.pathParameters['id']!),
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
    path: '/group-scoring/:id/me',
    builder: (context, state) =>
        SelfScoringScreen(groupId: state.pathParameters['id']!),
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
  GoRoute(
    path: '/group-scoring/:id/claims',
    builder: (context, state) =>
        ClaimInboxScreen(groupId: state.pathParameters['id']!),
  ),
  GoRoute(
    path: '/group-scoring/:id/claim-success/:sessionId',
    builder: (context, state) {
      // The approved-claim notification rides its `data` map in via `extra` so
      // the skill numbers render without a re-fetch; a cold/missing extra
      // degrades gracefully to a plain warm welcome.
      final data = state.extra is Map<String, dynamic>
          ? state.extra as Map<String, dynamic>
          : null;
      return ClaimSuccessScreen(
        groupId: state.pathParameters['id']!,
        sessionId: state.pathParameters['sessionId']!,
        summary: ClaimSuccessSummary.fromNotificationData(data),
      );
    },
  ),
  // Keep the bare `/:id` (detail hub) **last** so the more specific
  // `/created` and `/board` segments match first.
  GoRoute(
    path: '/group-scoring/:id',
    builder: (context, state) =>
        GroupDetailScreen(groupId: state.pathParameters['id']!),
  ),
];
