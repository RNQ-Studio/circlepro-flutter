// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(feedRepository)
final feedRepositoryProvider = FeedRepositoryProvider._();

final class FeedRepositoryProvider
    extends $FunctionalProvider<FeedRepository, FeedRepository, FeedRepository>
    with $Provider<FeedRepository> {
  FeedRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'feedRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$feedRepositoryHash();

  @$internal
  @override
  $ProviderElement<FeedRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FeedRepository create(Ref ref) {
    return feedRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FeedRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FeedRepository>(value),
    );
  }
}

String _$feedRepositoryHash() => r'396fdb481d2219c2f0a190187ab6c2825424a4f6';

@ProviderFor(FeedFilter)
final feedFilterProvider = FeedFilterProvider._();

final class FeedFilterProvider extends $NotifierProvider<FeedFilter, String?> {
  FeedFilterProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'feedFilterProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$feedFilterHash();

  @$internal
  @override
  FeedFilter create() => FeedFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$feedFilterHash() => r'940a4f5e041ff382569bc0d18fcb124a20e816f4';

abstract class _$FeedFilter extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String?, String?>, String?, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

/// Community feed (Module 5, task 2.12).

@ProviderFor(Feed)
final feedProvider = FeedProvider._();

/// Community feed (Module 5, task 2.12).
final class FeedProvider
    extends $AsyncNotifierProvider<Feed, List<PostEntity>> {
  /// Community feed (Module 5, task 2.12).
  FeedProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'feedProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$feedHash();

  @$internal
  @override
  Feed create() => Feed();
}

String _$feedHash() => r'27ce10eccd55ee12de1ef8eb399963e502019cd6';

/// Community feed (Module 5, task 2.12).

abstract class _$Feed extends $AsyncNotifier<List<PostEntity>> {
  FutureOr<List<PostEntity>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<PostEntity>>, List<PostEntity>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<PostEntity>>, List<PostEntity>>,
        AsyncValue<List<PostEntity>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

/// Comments for a post.

@ProviderFor(postComments)
final postCommentsProvider = PostCommentsFamily._();

/// Comments for a post.

final class PostCommentsProvider extends $FunctionalProvider<
        AsyncValue<List<CommentEntity>>,
        List<CommentEntity>,
        FutureOr<List<CommentEntity>>>
    with
        $FutureModifier<List<CommentEntity>>,
        $FutureProvider<List<CommentEntity>> {
  /// Comments for a post.
  PostCommentsProvider._(
      {required PostCommentsFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'postCommentsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$postCommentsHash();

  @override
  String toString() {
    return r'postCommentsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<CommentEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<CommentEntity>> create(Ref ref) {
    final argument = this.argument as String;
    return postComments(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PostCommentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postCommentsHash() => r'a67893b3978a3cf2a03e02216439022c565a7da7';

/// Comments for a post.

final class PostCommentsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<CommentEntity>>, String> {
  PostCommentsFamily._()
      : super(
          retry: null,
          name: r'postCommentsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Comments for a post.

  PostCommentsProvider call(
    String postId,
  ) =>
      PostCommentsProvider._(argument: postId, from: this);

  @override
  String toString() => r'postCommentsProvider';
}
