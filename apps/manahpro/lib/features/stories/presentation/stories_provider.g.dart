// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stories_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(storyRepository)
final storyRepositoryProvider = StoryRepositoryProvider._();

final class StoryRepositoryProvider extends $FunctionalProvider<StoryRepository,
    StoryRepository, StoryRepository> with $Provider<StoryRepository> {
  StoryRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'storyRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$storyRepositoryHash();

  @$internal
  @override
  $ProviderElement<StoryRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StoryRepository create(Ref ref) {
    return storyRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StoryRepository>(value),
    );
  }
}

String _$storyRepositoryHash() => r'0fd590ddf8fcd84f7a0d4ce590784a1210888d1a';

@ProviderFor(Stories)
final storiesProvider = StoriesProvider._();

final class StoriesProvider
    extends $AsyncNotifierProvider<Stories, List<StoryGroupEntity>> {
  StoriesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'storiesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$storiesHash();

  @$internal
  @override
  Stories create() => Stories();
}

String _$storiesHash() => r'9eba7a24d18fef7886972e7c765f25d674cbc94c';

abstract class _$Stories extends $AsyncNotifier<List<StoryGroupEntity>> {
  FutureOr<List<StoryGroupEntity>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<List<StoryGroupEntity>>, List<StoryGroupEntity>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<StoryGroupEntity>>, List<StoryGroupEntity>>,
        AsyncValue<List<StoryGroupEntity>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
