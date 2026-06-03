import 'package:go_router/go_router.dart';

import '../../features/clubs/presentation/screens/club_detail_screen.dart';
import '../../features/clubs/presentation/screens/clubs_directory_screen.dart';
import '../../features/clubs/presentation/screens/create_club_screen.dart';
import '../../features/clubs/presentation/screens/club_schedule_screen.dart';
import '../../features/clubs/presentation/screens/club_attendance_dashboard_screen.dart';
import '../../features/feed/presentation/screens/create_post_screen.dart';
import '../../features/feed/presentation/screens/feed_screen.dart';
import '../../features/identity/presentation/screens/edit_profile_screen.dart';
import '../../features/identity/presentation/screens/profile_screen.dart';
import '../../features/identity/presentation/screens/user_profile_screen.dart';
import '../../features/identity/presentation/screens/follow_list_screen.dart';
import '../../features/notifications/presentation/screens/notification_preferences_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/coaches/presentation/screens/coach_directory_screen.dart';
import '../../features/coaches/presentation/screens/coach_detail_screen.dart';
import '../../features/ranges/presentation/screens/range_finder_screen.dart';
import '../../features/articles/presentation/screens/article_list_screen.dart';
import '../../features/articles/presentation/screens/article_reader_screen.dart';

/// Phase 2 (Identity & Social) route paths. App-level — not in core's shared
/// AppRoutes (which the `variant` flavor also uses).
abstract final class SocialRoutes {
  static const String profile = '/account';
  static const String editProfile = '/account/edit';
  static const String clubs = '/clubs';
  static const String createClub = '/clubs/create';
  static const String feed = '/feed';
  static const String createPost = '/feed/create';
  static const String notifications = '/notifications';
  static const String notificationPrefs = '/notifications/preferences';
  static const String coaches = '/coaches';
  static const String ranges = '/ranges';
  static const String articles = '/articles';

  static String clubDetail(String id) => '/clubs/$id';
}

/// GoRoutes for the identity & social features, spread into the app router.
final List<RouteBase> socialRoutes = [
  GoRoute(path: SocialRoutes.profile, builder: (context, state) => const ProfileScreen()),
  GoRoute(path: SocialRoutes.editProfile, builder: (context, state) => const EditProfileScreen()),

  GoRoute(
    path: '/profiles/:userId',
    builder: (context, state) {
      final userId = int.parse(state.pathParameters['userId']!);
      return UserProfileScreen(userId: userId);
    },
  ),
  GoRoute(
    path: '/profiles/:userId/followers',
    builder: (context, state) {
      final userId = int.parse(state.pathParameters['userId']!);
      return FollowListScreen(userId: userId, isFollowersMode: true);
    },
  ),
  GoRoute(
    path: '/profiles/:userId/following',
    builder: (context, state) {
      final userId = int.parse(state.pathParameters['userId']!);
      return FollowListScreen(userId: userId, isFollowersMode: false);
    },
  ),

  GoRoute(path: SocialRoutes.clubs, builder: (context, state) => const ClubsDirectoryScreen()),
  GoRoute(path: SocialRoutes.createClub, builder: (context, state) => const CreateClubScreen()),
  GoRoute(
    path: '/clubs/:id',
    builder: (context, state) => ClubDetailScreen(clubId: state.pathParameters['id']!),
  ),
  GoRoute(
    path: '/clubs/:id/schedules',
    builder: (context, state) => ClubScheduleScreen(clubId: state.pathParameters['id']!),
  ),
  GoRoute(
    path: '/clubs/:id/schedules/:scheduleId/attendance',
    builder: (context, state) => ClubAttendanceDashboardScreen(
      clubId: state.pathParameters['id']!,
      scheduleId: state.pathParameters['scheduleId']!,
    ),
  ),

  GoRoute(path: SocialRoutes.feed, builder: (context, state) => const FeedScreen()),
  GoRoute(path: SocialRoutes.createPost, builder: (context, state) => const CreatePostScreen()),

  GoRoute(path: SocialRoutes.notifications, builder: (context, state) => const NotificationsScreen()),
  GoRoute(path: SocialRoutes.notificationPrefs, builder: (context, state) => const NotificationPreferencesScreen()),

  GoRoute(path: SocialRoutes.coaches, builder: (context, state) => const CoachDirectoryScreen()),
  GoRoute(
    path: '/coaches/:coachId',
    builder: (context, state) => CoachDetailScreen(coachId: state.pathParameters['coachId']!),
  ),
  GoRoute(path: SocialRoutes.ranges, builder: (context, state) => const RangeFinderScreen()),
  GoRoute(path: SocialRoutes.articles, builder: (context, state) => const ArticleListScreen()),
  GoRoute(
    path: '/articles/:articleId',
    builder: (context, state) {
      final articleId = int.parse(state.pathParameters['articleId']!);
      return ArticleReaderScreen(articleId: articleId);
    },
  ),
];
