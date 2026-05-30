/// An in-app notification (Module 8).
class NotificationEntity {
  const NotificationEntity({
    required this.id,
    this.title,
    this.body,
    this.type,
    this.data,
    this.isRead = false,
    this.createdAt,
  });

  final String id;
  final String? title;
  final String? body;
  final String? type;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime? createdAt;

  factory NotificationEntity.fromJson(Map<String, dynamic> json) {
    return NotificationEntity(
      id: json['id'].toString(),
      title: json['title'] as String?,
      body: json['body'] as String?,
      type: json['type'] as String?,
      data: json['data'] as Map<String, dynamic>?,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
    );
  }
}

/// A per-category notification preference.
class NotificationPrefEntity {
  const NotificationPrefEntity({
    required this.category,
    this.pushEnabled = true,
    this.emailEnabled = false,
  });

  final String category;
  final bool pushEnabled;
  final bool emailEnabled;

  NotificationPrefEntity copyWith({bool? pushEnabled, bool? emailEnabled}) => NotificationPrefEntity(
        category: category,
        pushEnabled: pushEnabled ?? this.pushEnabled,
        emailEnabled: emailEnabled ?? this.emailEnabled,
      );

  Map<String, dynamic> toJson() => {
        'category': category,
        'push_enabled': pushEnabled,
        'email_enabled': emailEnabled,
      };

  factory NotificationPrefEntity.fromJson(Map<String, dynamic> json) {
    return NotificationPrefEntity(
      category: json['category'] as String,
      pushEnabled: json['push_enabled'] as bool? ?? true,
      emailEnabled: json['email_enabled'] as bool? ?? false,
    );
  }
}
