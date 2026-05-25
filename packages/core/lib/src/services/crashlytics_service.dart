import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Service wrapper for Firebase Crashlytics.
///
/// Provides automatic crash reporting for Flutter framework errors
/// and uncaught platform errors. Only active in release mode.
class CrashlyticsService {
  /// Initialize Crashlytics and register global error handlers.
  ///
  /// Must be called after [FirebaseService.init] in `bootstrap()`.
  static Future<void> init() async {
    // Only enable collection in release mode.
    if (kReleaseMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    }

    // Catch Flutter framework errors.
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // Catch async errors not handled by Flutter.
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  /// Record a non-fatal error for monitoring.
  static Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    String? reason,
  }) async {
    await FirebaseCrashlytics.instance.recordError(
      exception,
      stack,
      reason: reason ?? 'Non-fatal error',
    );
  }

  /// Set user identifier for crash report grouping.
  static Future<void> setUserIdentifier(String userId) async {
    await FirebaseCrashlytics.instance.setUserIdentifier(userId);
  }

  /// Add a custom log entry to the next crash report.
  static void log(String message) {
    FirebaseCrashlytics.instance.log(message);
  }
}
