// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamification_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gamificationRepository)
final gamificationRepositoryProvider = GamificationRepositoryProvider._();

final class GamificationRepositoryProvider extends $FunctionalProvider<
    GamificationRepository,
    GamificationRepository,
    GamificationRepository> with $Provider<GamificationRepository> {
  GamificationRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'gamificationRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$gamificationRepositoryHash();

  @$internal
  @override
  $ProviderElement<GamificationRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GamificationRepository create(Ref ref) {
    return gamificationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GamificationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GamificationRepository>(value),
    );
  }
}

String _$gamificationRepositoryHash() =>
    r'78636d9d1da7d65325526f72bcf869f49343ad56';

@ProviderFor(gamificationStats)
final gamificationStatsProvider = GamificationStatsProvider._();

final class GamificationStatsProvider extends $FunctionalProvider<
        AsyncValue<UserStatsEntity>, UserStatsEntity, FutureOr<UserStatsEntity>>
    with $FutureModifier<UserStatsEntity>, $FutureProvider<UserStatsEntity> {
  GamificationStatsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'gamificationStatsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$gamificationStatsHash();

  @$internal
  @override
  $FutureProviderElement<UserStatsEntity> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UserStatsEntity> create(Ref ref) {
    return gamificationStats(ref);
  }
}

String _$gamificationStatsHash() => r'59aeb268b1c558f7671cae180df1f17983717ae4';
