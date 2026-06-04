import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth_provider.dart';
import 'auth_state.dart';

/// Compatible with GoRouter's [redirect] callback: `redirect: authRedirect`.
///
/// Returns null during [AuthInitial] and [AuthLoading] to prevent a flash
/// redirect to /login while the session check is still in progress.
String? authRedirect(BuildContext context, GoRouterState state) {
  final authState = ProviderScope.containerOf(context).read(authProvider);
  final location = state.matchedLocation;

  // While auth check is in progress, don't redirect.
  if (authState is AuthInitial || authState is AuthLoading) return null;

  final isAuthenticated = authState is AuthAuthenticated;
  final isOnLoginPage = location == '/login';
  final isOnOnboardingPage = location == '/onboarding';

  // If user is authenticated and on login or onboarding page, go to home
  if (isAuthenticated && (isOnLoginPage || isOnOnboardingPage)) return '/';

  // Let public routes (splash, onboarding) render without auth.
  if (location == '/splash' || location == '/onboarding') return null;

  return null;
}

class AuthGuard extends ConsumerWidget {
  const AuthGuard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (authState is AuthAuthenticated) return child;

    return const SizedBox.shrink();
  }
}
