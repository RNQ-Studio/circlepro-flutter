import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../data/biometric_auth_service.dart';
import 'auth_provider.dart';
import 'auth_state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key, this.onLoginSuccess});

  final VoidCallback? onLoginSuccess;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId: AppConfig.instance.googleWebClientId.isNotEmpty
        ? AppConfig.instance.googleWebClientId
        : (const String.fromEnvironment('GOOGLE_CLIENT_ID').isNotEmpty
            ? const String.fromEnvironment('GOOGLE_CLIENT_ID')
            : null),
  );
  String _appName = '';
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _appName = info.appName.isNotEmpty ? info.appName : 'Starter App';
          _appVersion = '${info.version}+${info.buildNumber}';
        });
      }
    } catch (_) {}
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      // Sign out first to ensure account chooser always shows
      await _googleSignIn.signOut().catchError((_) => null);
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in
        return;
      }
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      
      if (idToken == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal mendapatkan Google ID Token.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      
      if (mounted) {
        await ref.read(authProvider.notifier).loginWithGoogle(idToken);
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Login Google Gagal'),
            content: Text(ErrorFormatter.getFriendlyMessage(e)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup'),
              ),
            ],
          ),
        );
      }
    }
  }

  Widget _buildGoogleIcon() {
    return Image.network(
      'https://developers.google.com/static/identity/images/g-logo.png',
      width: 24,
      height: 24,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Text(
            'G',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 1.5),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthAuthenticated) {
        if (widget.onLoginSuccess != null) {
          widget.onLoginSuccess?.call();
        } else {
          context.go('/');
        }
      } else if (next is AuthError) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 8),
                  const Text('Login Gagal'),
                ],
              ),
              content: Text(ErrorFormatter.getFriendlyMessage(next.message)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        });
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_appName.isNotEmpty) ...[
                  Center(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'packages/features_shared/assets/logo.png',
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _appName,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Versi $_appVersion',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.5),
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
                Text(
                  l10n.signIn,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Gunakan akun Google Anda untuk masuk dengan cepat dan aman',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                // Google Sign In Button
                OutlinedButton(
                  onPressed: authState is AuthLoading ? null : _handleGoogleSignIn,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(
                      color: isDark
                          ? Colors.grey.shade800
                          : Colors.grey.shade300,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: isDark
                        ? const Color(0xFF1E1E1E)
                        : Colors.white,
                    elevation: isDark ? 0 : 1,
                    shadowColor: Colors.black.withValues(alpha: 0.05),
                  ),
                  child: authState is AuthLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildGoogleIcon(),
                            const SizedBox(width: 12),
                            Text(
                              'Masuk dengan Google',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 16),
                const _BiometricLoginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shows a fingerprint/face-id button only when biometric is available
/// and the user has enabled it in settings.
class _BiometricLoginButton extends ConsumerWidget {
  const _BiometricLoginButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return FutureBuilder<bool>(
      future: _isBiometricAvailableAndEnabled(ref),
      builder: (context, snapshot) {
        if (!(snapshot.data ?? false)) return const SizedBox.shrink();

        return Column(
          children: [
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'atau masuk dengan',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
                  ),
            ),
            const SizedBox(height: 8),
            IconButton.filled(
              iconSize: 36,
              style: IconButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              onPressed: authState is AuthLoading
                  ? null
                  : () => ref.read(authProvider.notifier).loginWithBiometric(),
              icon: const Icon(Icons.fingerprint),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _isBiometricAvailableAndEnabled(WidgetRef ref) async {
    try {
      final service = ref.read(biometricAuthServiceProvider);
      final isSupported = await service.isDeviceSupported();
      if (!isSupported) return false;

      final canCheck = await service.canCheckBiometrics();
      if (!canCheck) return false;

      // Check user preference from SharedPreferences.
      final storage = SharedPreferencesStorage();
      await storage.init();
      final enabled = await storage.read(AppConstants.keyBiometricEnabled);
      return enabled == 'true';
    } catch (_) {
      return false;
    }
  }
}
