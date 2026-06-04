import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:features_shared/features_shared.dart';

import '../features/home/presentation/home_screen.dart';
import '../features/settings/presentation/settings_route.dart';
import '../features/profile/presentation/profile_route.dart';
import '../features/ui_gallery/screens/ui_gallery_home_screen.dart';
import '../features/quotes/presentation/screens/quotes_screen.dart';

import '../features/onboarding/presentation/manah_onboarding_screen.dart';
import '../features/scoring/presentation/scoring_routes.dart';
import '../shared/routes/social_routes.dart';
import '../features/events/presentation/events_routes.dart';
import '../features/monetization/presentation/monetization_routes.dart';
import '../features/stories/domain/story_entities.dart';
import '../features/stories/presentation/screens/story_picker_preview_screen.dart';
import '../features/stories/presentation/screens/story_viewer_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  redirect: authRedirect,
  observers: [AppNavigatorObserver()],
  routes: [
    // Keep shared splash/login, but override onboarding with ManahPro content (task 2.4).
    ...authRoutes.where((r) => r.path != '/onboarding'),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const ManahOnboardingScreen(),
    ),
    settingsRoute,
    profileRoute,
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/ui-gallery',
      builder: (context, state) => const UiGalleryHomeScreen(),
    ),

    // Quotes management
    GoRoute(
      path: AppRoutes.quotes,
      builder: (context, state) {
        final initialIdStr = state.uri.queryParameters['initialId'];
        final initialId = initialIdStr != null ? int.tryParse(initialIdStr) : null;
        return QuotesScreen(initialId: initialId);
      },
    ),


    // ManahPro — Scoring (Module 1 / TRACK)
    ...scoringRoutes,

    // ManahPro — Phase 2: Identity & Social (profile, clubs, feed)
    ...socialRoutes,

    // ManahPro — Phase 3: Events & Ranking (COMPETE)
    ...eventsRoutes,

    // ManahPro — Phase 5: Monetization
    ...monetizationRoutes,

    // Stories system
    GoRoute(
      path: '/stories/preview',
      builder: (context, state) {
        final filePath = state.extra as String;
        return StoryPickerPreviewScreen(filePath: filePath);
      },
    ),
    GoRoute(
      path: '/stories/view',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        final groups = data['groups'] as List<StoryGroupEntity>;
        final initialIndex = data['initialIndex'] as int;
        return StoryViewerScreen(groups: groups, initialIndex: initialIndex);
      },
    ),
  ],
);
