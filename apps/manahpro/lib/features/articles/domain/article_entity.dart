class ArticleCategoryEntity {
  const ArticleCategoryEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
  });

  final int id;
  final String name;
  final String slug;
  final String? description;

  factory ArticleCategoryEntity.fromJson(Map<String, dynamic> json) {
    return ArticleCategoryEntity(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String?,
    );
  }
}

class ArticleEntity {
  const ArticleEntity({
    required this.id,
    required this.title,
    required this.slug,
    this.excerpt,
    required this.content,
    this.featuredImage,
    required this.status,
    required this.readingTime,
    this.publishedAt,
    this.category,
    this.authorName,
    required this.tags,
  });

  final int id;
  final String title;
  final String slug;
  final String? excerpt;
  final String content;
  final String? featuredImage;
  final String status;
  final int readingTime;
  final DateTime? publishedAt;
  final ArticleCategoryEntity? category;
  final String? authorName;
  final List<String> tags;

  factory ArticleEntity.fromJson(Map<String, dynamic> json) {
    final categoryJson = json['category'] as Map<String, dynamic>?;
    final authorJson = json['author'] as Map<String, dynamic>?;
    final tagsList = json['tags'] as List<dynamic>? ?? [];

    return ArticleEntity(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      excerpt: json['excerpt'] as String?,
      content: json['content'] as String? ?? '',
      featuredImage: json['featured_image'] as String?,
      status: json['status'] as String? ?? 'draft',
      readingTime: json['reading_time'] as int? ?? 1,
      publishedAt: json['published_at'] != null ? DateTime.parse(json['published_at'] as String) : null,
      category: categoryJson != null ? ArticleCategoryEntity.fromJson(categoryJson) : null,
      authorName: authorJson != null ? (authorJson['full_name'] as String? ?? authorJson['name'] as String? ?? '') : null,
      tags: tagsList.map((e) => (e as Map<String, dynamic>)['name'] as String? ?? '').where((s) => s.isNotEmpty).toList(),
    );
  }
}
