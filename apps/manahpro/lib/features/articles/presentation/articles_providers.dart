import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/api/manah_api.dart';
import '../data/articles_repository.dart';
import '../domain/article_entity.dart';

part 'articles_providers.g.dart';

@Riverpod(keepAlive: true)
ArticlesRepository articlesRepository(Ref ref) {
  return ArticlesRepository(ref.watch(manahDioProvider));
}

@riverpod
Future<List<ArticleCategoryEntity>> articleCategories(Ref ref) {
  return ref.watch(articlesRepositoryProvider).getCategories();
}

@riverpod
Future<List<ArticleEntity>> articlesList(
  Ref ref, {
  int? categoryId,
  String? search,
}) {
  return ref.watch(articlesRepositoryProvider).directory(
        categoryId: categoryId,
        search: search,
      );
}

@riverpod
Future<ArticleEntity> articleDetail(Ref ref, int id) {
  return ref.watch(articlesRepositoryProvider).getArticle(id);
}
