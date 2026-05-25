import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Callback handler for background messages.
///
/// Must be a **top-level function** (not a class method)
/// because it runs in its own isolate on Android.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message received: ${message.messageId}');
}

/// Service layer for Firebase Cloud Messaging (FCM).
///
/// Handles permission request, token management, and message listeners
/// for foreground, background, and terminated-state notifications.
class FCMNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  /// Initializes FCM: requests permission, retrieves token,
  /// and registers foreground/background listeners.
  Future<void> init({
    required void Function(RemoteMessage) onForegroundMessage,
    required void Function(RemoteMessage) onMessageOpenedApp,
  }) async {
    // 1. Request permission (iOS & Android 13+)
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // 2. Get FCM token
      final token = await _fcm.getToken();
      debugPrint('FCM Token: $token');

      // 3. Listen for token refresh
      _fcm.onTokenRefresh.listen((newToken) {
        debugPrint('FCM Token refreshed: $newToken');
        // TODO: Send the new token to your backend
      });

      // 4. Configure foreground listener
      FirebaseMessaging.onMessage.listen(onForegroundMessage);

      // 5. Configure notification-click (app opened from background)
      FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedApp);

      // 6. Register background handler
      FirebaseMessaging.onBackgroundMessage(
        firebaseMessagingBackgroundHandler,
      );

      // 7. Handle initial message (app launched from terminated state)
      final initialMessage = await _fcm.getInitialMessage();
      if (initialMessage != null) {
        onMessageOpenedApp(initialMessage);
      }
    }
  }

  /// Returns the current FCM device token, or `null` if unavailable.
  Future<String?> getToken() => _fcm.getToken();
}
