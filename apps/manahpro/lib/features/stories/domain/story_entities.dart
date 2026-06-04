class StoryItemEntity {
  const StoryItemEntity({
    required this.id,
    required this.mediaType,
    required this.mediaUrl,
    required this.expiresAt,
    this.caption,
    required this.viewsCount,
    this.createdAt,
  });

  final String id;
  final String mediaType; // 'image' or 'video'
  final String mediaUrl;
  final DateTime expiresAt;
  final String? caption;
  final int viewsCount;
  final DateTime? createdAt;

  factory StoryItemEntity.fromJson(Map<String, dynamic> json) {
    return StoryItemEntity(
      id: json['id'] as String,
      mediaType: json['media_type'] as String? ?? 'image',
      mediaUrl: json['media_url'] as String? ?? '',
      expiresAt: DateTime.parse(json['expires_at'] as String),
      caption: json['caption'] as String?,
      viewsCount: json['views_count'] as int? ?? 0,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
    );
  }
}

class StoryGroupEntity {
  const StoryGroupEntity({
    required this.userId,
    required this.fullName,
    required this.username,
    this.avatarUrl,
    required this.stories,
  });

  final int userId;
  final String fullName;
  final String username;
  final String? avatarUrl;
  final List<StoryItemEntity> stories;

  factory StoryGroupEntity.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    final storyList = json['stories'] as List<dynamic>? ?? [];
    return StoryGroupEntity(
      userId: user['id'] as int,
      fullName: user['full_name'] as String? ?? user['name'] as String? ?? '',
      username: user['username'] as String? ?? '',
      avatarUrl: user['avatar_url'] as String?,
      stories: storyList.map((e) => StoryItemEntity.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
