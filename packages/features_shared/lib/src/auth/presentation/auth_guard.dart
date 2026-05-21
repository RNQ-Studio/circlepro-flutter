import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth_provider.dart';
import 'auth_state.dart';

/// Compatible with GoRouter's [redirect] callback: `redirect: authRedirect`.
String? authRedirect(BuildContext context, GoRouterState state) {
  final authState =
      ProviderScope.containerOf(context).read(authNotifierProvider);
  final isAuthenticated = authState is AuthAuthenticated;
  final isOnLoginPage = state.matchedLocation == '/login';

  if (!isAuthenticated && !isOnLoginPage) return '/login';
  if (isAuthenticated && isOnLoginPage) return '/';
  return null;
}

class AuthGuard extends ConsumerWidget {
  const AuthGuard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    if (authState is AuthAuthenticated) return child;

    return const SizedBox.shrink();
  }
}
