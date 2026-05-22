import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  const NotificationsRepositoryImpl();

  @override
  Future<List<AppNotification>> getNotifications() {
    throw UnimplementedError(
      'NotificationsRepositoryImpl.getNotifications not yet implemented',
    );
  }

  @override
  Future<void> markAsRead(String notificationId) {
    throw UnimplementedError(
      'NotificationsRepositoryImpl.markAsRead not yet implemented',
    );
  }
}
