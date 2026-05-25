import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'biometric_auth_service.g.dart';

/// Wrapper around [LocalAuthentication] for biometric checks and login.
class BiometricAuthService {
  BiometricAuthService([LocalAuthentication? localAuth])
      : _localAuth = localAuth ?? LocalAuthentication();

  final LocalAuthentication _localAuth;

  /// Whether the device has biometric hardware.
  Future<bool> isDeviceSupported() => _localAuth.isDeviceSupported();

  /// Whether the device has any enrolled biometrics.
  Future<bool> canCheckBiometrics() => _localAuth.canCheckBiometrics;

  /// Available biometric types on the device.
  Future<List<BiometricType>> getAvailableBiometrics() =>
      _localAuth.getAvailableBiometrics();

  /// Prompt the user to authenticate using biometrics.
  Future<bool> authenticate({
    required String localizedReason,
  }) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } on PlatformException {
      return false;
    }
  }
}

@riverpod
BiometricAuthService biometricAuthService(Ref ref) {
  return BiometricAuthService();
}
