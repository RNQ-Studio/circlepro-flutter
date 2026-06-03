import 'package:dio/dio.dart';

import '../domain/article_entity.dart';

class ArticlesRepository {
  const ArticlesRepository(this._dio);

  final Dio _dio;

  Future<List<ArticleCategoryEntity>> getCategories() async {
    final response = await _dio.get('v1/categories');
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => ArticleCategoryEntity.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<ArticleEntity>> directory({
    int? categoryId,
    String? search,
  }) async {
    final response = await _dio.get('v1/articles', queryParameters: {
      'filter[status]': 'published',
      if (categoryId != null) 'filter[category_id]': categoryId,
      if (search != null && search.isNotEmpty) 'filter[search]': search,
    });
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => ArticleEntity.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ArticleEntity> getArticle(int id) async {
    final response = await _dio.get('v1/articles/$id');
    return ArticleEntity.fromJson(response.data['data'] as Map<String, dynamic>);
  }
}
