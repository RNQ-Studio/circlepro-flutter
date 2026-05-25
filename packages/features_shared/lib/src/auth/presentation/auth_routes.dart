import 'package:go_router/go_router.dart';

import '../../onboarding/presentation/onboarding_screen.dart';
import '../../onboarding/presentation/splash_screen.dart';
import 'login_screen.dart';

const authLoginPath = '/login';

final List<GoRoute> authRoutes = [
  GoRoute(
    path: '/splash',
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    path: '/onboarding',
    builder: (context, state) => const OnboardingScreen(),
  ),
  GoRoute(
    path: authLoginPath,
    builder: (context, state) => const LoginScreen(),
  ),
];
