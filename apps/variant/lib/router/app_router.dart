import 'package:core/core.dart';
import 'package:features_shared/features_shared.dart';
import 'package:go_router/go_router.dart';

import '../home/home_screen.dart';
import '../features/settings/presentation/settings_route.dart';
import '../features/profile/presentation/profile_route.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: authRedirect,
  observers: [AppNavigatorObserver()],
  routes: [
    ...authRoutes,
    settingsRoute,
    profileRoute,
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
