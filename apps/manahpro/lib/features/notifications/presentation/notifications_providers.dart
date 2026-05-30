import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/api/manah_api.dart';
import '../data/notifications_repository.dart';
import '../domain/notification_entity.dart';

part 'notifications_providers.g.dart';

@Riverpod(keepAlive: true)
NotificationsRepository notificationsRepository(Ref ref) {
  return NotificationsRepository(ref.watch(manahDioProvider));
}

/// In-app notification list (task 2.6).
@riverpod
class Notifications extends _$Notifications {
  @override
  Future<List<NotificationEntity>> build() {
    return ref.watch(notificationsRepositoryProvider).list();
  }

  Future<void> markRead(String id) async {
    await ref.read(notificationsRepositoryProvider).markRead(id);
    ref.invalidateSelf();
    ref.invalidate(unreadCountProvider);
  }

  Future<void> markAllRead() async {
    await ref.read(notificationsRepositoryProvider).markAllRead();
    ref.invalidateSelf();
    ref.invalidate(unreadCountProvider);
  }
}

/// Unread badge count.
@riverpod
Future<int> unreadCount(Ref ref) {
  return ref.watch(notificationsRepositoryProvider).unreadCount();
}

/// Per-category preferences (task 2.5/2.6).
@riverpod
class NotificationPrefs extends _$NotificationPrefs {
  @override
  Future<List<NotificationPrefEntity>> build() {
    return ref.watch(notificationsRepositoryProvider).getPreferences();
  }

  Future<void> toggle(String category, {bool? push, bool? email}) async {
    final current = state.value ?? [];
    final updated = [
      for (final p in current)
        if (p.category == category) p.copyWith(pushEnabled: push, emailEnabled: email) else p,
    ];
    state = AsyncData(updated);
    final saved = await ref.read(notificationsRepositoryProvider).updatePreferences(updated);
    state = AsyncData(saved);
  }
}
