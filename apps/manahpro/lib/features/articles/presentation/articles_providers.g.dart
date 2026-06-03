// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'articles_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(articlesRepository)
final articlesRepositoryProvider = ArticlesRepositoryProvider._();

final class ArticlesRepositoryProvider extends $FunctionalProvider<
    ArticlesRepository,
    ArticlesRepository,
    ArticlesRepository> with $Provider<ArticlesRepository> {
  ArticlesRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'articlesRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$articlesRepositoryHash();

  @$internal
  @override
  $ProviderElement<ArticlesRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ArticlesRepository create(Ref ref) {
    return articlesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ArticlesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ArticlesRepository>(value),
    );
  }
}

String _$articlesRepositoryHash() =>
    r'd51c89a7bd7592fbeee4a9171fceb7c426a3b6f7';

@ProviderFor(articleCategories)
final articleCategoriesProvider = ArticleCategoriesProvider._();

final class ArticleCategoriesProvider extends $FunctionalProvider<
        AsyncValue<List<ArticleCategoryEntity>>,
        List<ArticleCategoryEntity>,
        FutureOr<List<ArticleCategoryEntity>>>
    with
        $FutureModifier<List<ArticleCategoryEntity>>,
        $FutureProvider<List<ArticleCategoryEntity>> {
  ArticleCategoriesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'articleCategoriesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$articleCategoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<ArticleCategoryEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<ArticleCategoryEntity>> create(Ref ref) {
    return articleCategories(ref);
  }
}

String _$articleCategoriesHash() => r'e6bf6c4eb019293bfacb9af1a1941192509dfa10';

@ProviderFor(articlesList)
final articlesListProvider = ArticlesListFamily._();

final class ArticlesListProvider extends $FunctionalProvider<
        AsyncValue<List<ArticleEntity>>,
        List<ArticleEntity>,
        FutureOr<List<ArticleEntity>>>
    with
        $FutureModifier<List<ArticleEntity>>,
        $FutureProvider<List<ArticleEntity>> {
  ArticlesListProvider._(
      {required ArticlesListFamily super.from,
      required ({
        int? categoryId,
        String? search,
      })
          super.argument})
      : super(
          retry: null,
          name: r'articlesListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$articlesListHash();

  @override
  String toString() {
    return r'articlesListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<ArticleEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<ArticleEntity>> create(Ref ref) {
    final argument = this.argument as ({
      int? categoryId,
      String? search,
    });
    return articlesList(
      ref,
      categoryId: argument.categoryId,
      search: argument.search,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ArticlesListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$articlesListHash() => r'ffc2c611045f2a3b401617415be410f9ba429d03';

final class ArticlesListFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<List<ArticleEntity>>,
            ({
              int? categoryId,
              String? search,
            })> {
  ArticlesListFamily._()
      : super(
          retry: null,
          name: r'articlesListProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ArticlesListProvider call({
    int? categoryId,
    String? search,
  }) =>
      ArticlesListProvider._(argument: (
        categoryId: categoryId,
        search: search,
      ), from: this);

  @override
  String toString() => r'articlesListProvider';
}

@ProviderFor(articleDetail)
final articleDetailProvider = ArticleDetailFamily._();

final class ArticleDetailProvider extends $FunctionalProvider<
        AsyncValue<ArticleEntity>, ArticleEntity, FutureOr<ArticleEntity>>
    with $FutureModifier<ArticleEntity>, $FutureProvider<ArticleEntity> {
  ArticleDetailProvider._(
      {required ArticleDetailFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'articleDetailProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$articleDetailHash();

  @override
  String toString() {
    return r'articleDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ArticleEntity> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ArticleEntity> create(Ref ref) {
    final argument = this.argument as int;
    return articleDetail(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ArticleDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$articleDetailHash() => r'eae984e62a26952d9d8ab82c7a4c08e61a8a8bde';

final class ArticleDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ArticleEntity>, int> {
  ArticleDetailFamily._()
      : super(
          retry: null,
          name: r'articleDetailProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ArticleDetailProvider call(
    int id,
  ) =>
      ArticleDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'articleDetailProvider';
}
