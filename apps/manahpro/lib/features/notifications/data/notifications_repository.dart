import 'package:dio/dio.dart';

import '../domain/notification_entity.dart';

/// Online notifications API client (Module 8, task 2.6).
class NotificationsRepository {
  const NotificationsRepository(this._dio);

  final Dio _dio;

  Future<List<NotificationEntity>> list() async {
    final response = await _dio.get('v1/notifications');
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => NotificationEntity.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<int> unreadCount() async {
    final response = await _dio.get('v1/notifications/unread-count');
    return response.data['data']['count'] as int? ?? 0;
  }

  Future<void> markRead(String id) async {
    await _dio.post('v1/notifications/$id/read');
  }

  Future<void> markAllRead() async {
    await _dio.post('v1/notifications/read-all');
  }

  Future<List<NotificationPrefEntity>> getPreferences() async {
    final response = await _dio.get('v1/notifications/preferences');
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => NotificationPrefEntity.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<NotificationPrefEntity>> updatePreferences(List<NotificationPrefEntity> prefs) async {
    final response = await _dio.put('v1/notifications/preferences', data: {
      'preferences': prefs.map((p) => p.toJson()).toList(),
    });
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => NotificationPrefEntity.fromJson(e as Map<String, dynamic>)).toList();
  }
}
