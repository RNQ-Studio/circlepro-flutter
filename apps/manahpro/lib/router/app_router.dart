import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:features_shared/features_shared.dart';

import '../features/home/presentation/home_screen.dart';
import '../features/settings/presentation/settings_route.dart';
import '../features/profile/presentation/profile_route.dart';
import '../features/ui_gallery/screens/ui_gallery_home_screen.dart';
import '../features/quotes/presentation/screens/quotes_screen.dart';
import '../features/quotes/presentation/screens/quote_form_screen.dart';
import '../features/onboarding/presentation/manah_onboarding_screen.dart';
import '../features/scoring/presentation/scoring_routes.dart';
import '../shared/routes/social_routes.dart';

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
      builder: (context, state) => const QuotesScreen(),
    ),
    GoRoute(
      path: AppRoutes.createQuote,
      builder: (context, state) => const QuoteFormScreen(),
    ),
    GoRoute(
      path: '${AppRoutes.editQuote}/:localId',
      builder: (context, state) {
        final localId = int.parse(state.pathParameters['localId']!);
        return QuoteFormScreen(localId: localId);
      },
    ),

    // ManahPro — Scoring (Module 1 / TRACK)
    ...scoringRoutes,

    // ManahPro — Phase 2: Identity & Social (profile, clubs, feed)
    ...socialRoutes,
  ],
);
