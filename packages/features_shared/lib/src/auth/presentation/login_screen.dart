import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref.read(authProvider.notifier).login(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthAuthenticated) widget.onLoginSuccess?.call();
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.signIn,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: l10n.email),
                  validator: (v) => (v == null || !v.contains('@'))
                      ? l10n.errorInvalidEmail
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: true,
                  decoration: InputDecoration(labelText: l10n.password),
                  validator: (v) => (v == null || v.length < 6)
                      ? l10n.errorPasswordTooShort
                      : null,
                ),
                const SizedBox(height: 24),
                if (authState is AuthError)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      authState.message,
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                  ),
                FilledButton(
                  onPressed: authState is AuthLoading ? null : _submit,
                  child: authState is AuthLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.login),
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
