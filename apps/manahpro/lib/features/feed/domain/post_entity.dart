/// Snapshot of shared content embedded in a post (currently a scoring session).
class SharedSnapshot {
  const SharedSnapshot({
    required this.type,
    this.totalScore,
    this.maxPossibleScore,
    this.bowClass,
    this.distanceCategory,
    this.isPersonalBest = false,
  });

  final String type;
  final int? totalScore;
  final int? maxPossibleScore;
  final String? bowClass;
  final String? distanceCategory;
  final bool isPersonalBest;

  factory SharedSnapshot.fromJson(Map<String, dynamic> json) {
    return SharedSnapshot(
      type: json['type'] as String? ?? 'unknown',
      totalScore: json['total_score'] as int?,
      maxPossibleScore: json['max_possible_score'] as int?,
      bowClass: json['bow_class'] as String?,
      distanceCategory: json['distance_category'] as String?,
      isPersonalBest: json['is_personal_best'] as bool? ?? false,
    );
  }
}

/// A community feed post.
class PostEntity {
  const PostEntity({
    required this.id,
    this.authorName,
    this.authorUsername,
    this.authorAvatar,
    this.body,
    this.visibility = 'public',
    this.sharedType,
    this.shared,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
    this.createdAt,
  });

  final String id;
  final String? authorName;
  final String? authorUsername;
  final String? authorAvatar;
  final String? body;
  final String visibility;
  final String? sharedType;
  final SharedSnapshot? shared;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final DateTime? createdAt;

  PostEntity copyWith({int? likeCount, bool? isLiked, int? commentCount}) => PostEntity(
        id: id,
        authorName: authorName,
        authorUsername: authorUsername,
        authorAvatar: authorAvatar,
        body: body,
        visibility: visibility,
        sharedType: sharedType,
        shared: shared,
        likeCount: likeCount ?? this.likeCount,
        commentCount: commentCount ?? this.commentCount,
        isLiked: isLiked ?? this.isLiked,
        createdAt: createdAt,
      );

  factory PostEntity.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>?;
    final shared = json['shared'] as Map<String, dynamic>?;
    return PostEntity(
      id: json['id'] as String,
      authorName: author?['full_name'] as String?,
      authorUsername: author?['username'] as String?,
      authorAvatar: author?['avatar_url'] as String?,
      body: json['body'] as String?,
      visibility: json['visibility'] as String? ?? 'public',
      sharedType: json['shared_type'] as String?,
      shared: shared != null ? SharedSnapshot.fromJson(shared) : null,
      likeCount: json['like_count'] as int? ?? 0,
      commentCount: json['comment_count'] as int? ?? 0,
      isLiked: json['is_liked'] as bool? ?? false,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
    );
  }
}

/// A comment on a post.
class CommentEntity {
  const CommentEntity({
    required this.id,
    this.authorName,
    this.authorAvatar,
    required this.body,
    this.createdAt,
  });

  final String id;
  final String? authorName;
  final String? authorAvatar;
  final String body;
  final DateTime? createdAt;

  factory CommentEntity.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>?;
    return CommentEntity(
      id: json['id'] as String,
      authorName: author?['full_name'] as String?,
      authorAvatar: author?['avatar_url'] as String?,
      body: json['body'] as String? ?? '',
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
    );
  }
}
