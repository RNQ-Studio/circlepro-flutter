import 'package:go_router/go_router.dart';

import '../../features/clubs/presentation/screens/club_detail_screen.dart';
import '../../features/clubs/presentation/screens/clubs_directory_screen.dart';
import '../../features/clubs/presentation/screens/create_club_screen.dart';
import '../../features/feed/presentation/screens/create_post_screen.dart';
import '../../features/feed/presentation/screens/feed_screen.dart';
import '../../features/identity/presentation/screens/edit_profile_screen.dart';
import '../../features/identity/presentation/screens/profile_screen.dart';
import '../../features/notifications/presentation/screens/notification_preferences_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';

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

  static String clubDetail(String id) => '/clubs/$id';
}

/// GoRoutes for the identity & social features, spread into the app router.
final List<RouteBase> socialRoutes = [
  GoRoute(path: SocialRoutes.profile, builder: (context, state) => const ProfileScreen()),
  GoRoute(path: SocialRoutes.editProfile, builder: (context, state) => const EditProfileScreen()),

  GoRoute(path: SocialRoutes.clubs, builder: (context, state) => const ClubsDirectoryScreen()),
  GoRoute(path: SocialRoutes.createClub, builder: (context, state) => const CreateClubScreen()),
  GoRoute(
    path: '/clubs/:id',
    builder: (context, state) => ClubDetailScreen(clubId: state.pathParameters['id']!),
  ),

  GoRoute(path: SocialRoutes.feed, builder: (context, state) => const FeedScreen()),
  GoRoute(path: SocialRoutes.createPost, builder: (context, state) => const CreatePostScreen()),

  GoRoute(path: SocialRoutes.notifications, builder: (context, state) => const NotificationsScreen()),
  GoRoute(path: SocialRoutes.notificationPrefs, builder: (context, state) => const NotificationPreferencesScreen()),
];
