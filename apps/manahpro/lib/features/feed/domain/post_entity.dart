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

class FeedMedia {
  const FeedMedia({
    required this.id,
    required this.url,
    required this.type,
    this.position = 0,
  });

  final String id;
  final String url;
  final String type;
  final int position;

  factory FeedMedia.fromJson(Map<String, dynamic> json) {
    return FeedMedia(
      id: json['id'] as String? ?? '',
      url: json['url'] as String? ?? '',
      type: json['type'] as String? ?? 'image',
      position: json['position'] as int? ?? 0,
    );
  }
}

class PollOptionEntity {
  const PollOptionEntity({
    required this.id,
    required this.optionText,
    required this.votesCount,
  });

  final String id;
  final String optionText;
  final int votesCount;

  factory PollOptionEntity.fromJson(Map<String, dynamic> json) {
    return PollOptionEntity(
      id: json['id'] as String? ?? '',
      optionText: json['option_text'] as String? ?? '',
      votesCount: json['votes_count'] as int? ?? 0,
    );
  }
}

class PollEntity {
  const PollEntity({
    required this.id,
    required this.question,
    this.expiresAt,
    this.isExpired = false,
    required this.options,
    this.totalVotes = 0,
    this.userVotedOptionId,
  });

  final String id;
  final String question;
  final DateTime? expiresAt;
  final bool isExpired;
  final List<PollOptionEntity> options;
  final int totalVotes;
  final String? userVotedOptionId;

  factory PollEntity.fromJson(Map<String, dynamic> json) {
    final optionsList = json['options'] as List<dynamic>? ?? [];
    return PollEntity(
      id: json['id'] as String? ?? '',
      question: json['question'] as String? ?? '',
      expiresAt: json['expires_at'] != null ? DateTime.tryParse(json['expires_at'] as String) : null,
      isExpired: json['is_expired'] as bool? ?? false,
      options: optionsList.map((e) => PollOptionEntity.fromJson(e as Map<String, dynamic>)).toList(),
      totalVotes: json['total_votes'] as int? ?? 0,
      userVotedOptionId: json['user_voted_option_id'] as String?,
    );
  }
}

/// A community feed post.
class PostEntity {
  const PostEntity({
    required this.id,
    this.authorId,
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
    this.media = const [],
    this.poll,
  });

  final String id;
  final int? authorId;
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
  final List<FeedMedia> media;
  final PollEntity? poll;

  PostEntity copyWith({int? likeCount, bool? isLiked, int? commentCount, PollEntity? poll}) => PostEntity(
        id: id,
        authorId: authorId,
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
        media: media,
        poll: poll ?? this.poll,
      );

  factory PostEntity.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>?;
    final shared = json['shared'] as Map<String, dynamic>?;
    final mediaList = json['media'] as List<dynamic>? ?? [];
    final pollJson = json['poll'] as Map<String, dynamic>?;

    return PostEntity(
      id: json['id'] as String,
      authorId: author?['id'] as int?,
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
      media: mediaList.map((e) => FeedMedia.fromJson(e as Map<String, dynamic>)).toList(),
      poll: pollJson != null ? PollEntity.fromJson(pollJson) : null,
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
