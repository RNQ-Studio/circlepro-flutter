import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'onboarding_notifier.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../auth/presentation/auth_state.dart';

/// Premium splash screen with animated fade-in branding.
///
/// After 2 seconds navigates to:
/// - `/onboarding` — if the user has not completed onboarding yet.
/// - `/login`      — if the user has not logged in.
/// - `/`           — if the user is already authenticated.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  String _appName = 'Starter App';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();

    _loadAppName();

    Future.delayed(const Duration(seconds: 2), _checkNavigation);
  }

  Future<void> _loadAppName() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          // Fallback to title case of folder if blank
          _appName = info.appName.isNotEmpty ? info.appName : 'Starter App';
        });
      }
    } catch (_) {}
  }

  Future<void> _checkNavigation() async {
    if (!mounted) return;

    // Check onboarding status.
    bool hasOnboarded = false;
    try {
      hasOnboarded = await ref.read(onboardingProvider.future);
    } catch (_) {
      final onboardingAsync = ref.read(onboardingProvider);
      hasOnboarded = onboardingAsync.asData?.value ?? false;
    }

    // Wait for auth session check to finish (not AuthInitial or AuthLoading)
    var authState = ref.read(authProvider);
    while (authState is AuthInitial || authState is AuthLoading) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
      authState = ref.read(authProvider);
    }

    final isAuthenticated = authState is AuthAuthenticated;

    if (!hasOnboarded && !isAuthenticated) {
      if (mounted) context.go('/onboarding');
      return;
    }

    // Go to home if already onboarded or logged in
    if (mounted) context.go('/');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'packages/features_shared/assets/logo.png',
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _appName,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
