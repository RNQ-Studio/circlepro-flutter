// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scoring_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_scoringDioClient)
final _scoringDioClientProvider = _ScoringDioClientProvider._();

final class _ScoringDioClientProvider
    extends $FunctionalProvider<DioClient, DioClient, DioClient>
    with $Provider<DioClient> {
  _ScoringDioClientProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'_scoringDioClientProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$_scoringDioClientHash();

  @$internal
  @override
  $ProviderElement<DioClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DioClient create(Ref ref) {
    return _scoringDioClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DioClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DioClient>(value),
    );
  }
}

String _$_scoringDioClientHash() => r'a1d65af5c6c72b7e4b7de8996b8bcbd71de41553';

@ProviderFor(scoringDatabase)
final scoringDatabaseProvider = ScoringDatabaseProvider._();

final class ScoringDatabaseProvider extends $FunctionalProvider<ScoringDatabase,
    ScoringDatabase, ScoringDatabase> with $Provider<ScoringDatabase> {
  ScoringDatabaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'scoringDatabaseProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$scoringDatabaseHash();

  @$internal
  @override
  $ProviderElement<ScoringDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ScoringDatabase create(Ref ref) {
    return scoringDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScoringDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScoringDatabase>(value),
    );
  }
}

String _$scoringDatabaseHash() => r'914f1c7a298e6bca179b70971fab26615a9dc814';

@ProviderFor(_scoringLocalDataSource)
final _scoringLocalDataSourceProvider = _ScoringLocalDataSourceProvider._();

final class _ScoringLocalDataSourceProvider extends $FunctionalProvider<
    ScoringLocalDataSource,
    ScoringLocalDataSource,
    ScoringLocalDataSource> with $Provider<ScoringLocalDataSource> {
  _ScoringLocalDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'_scoringLocalDataSourceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$_scoringLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<ScoringLocalDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ScoringLocalDataSource create(Ref ref) {
    return _scoringLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScoringLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScoringLocalDataSource>(value),
    );
  }
}

String _$_scoringLocalDataSourceHash() =>
    r'caf7dbc9a9c1f05d3f9e1d7b53218306e996250f';

@ProviderFor(_scoringRemoteDataSource)
final _scoringRemoteDataSourceProvider = _ScoringRemoteDataSourceProvider._();

final class _ScoringRemoteDataSourceProvider extends $FunctionalProvider<
    ScoringRemoteDataSource,
    ScoringRemoteDataSource,
    ScoringRemoteDataSource> with $Provider<ScoringRemoteDataSource> {
  _ScoringRemoteDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'_scoringRemoteDataSourceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$_scoringRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<ScoringRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ScoringRemoteDataSource create(Ref ref) {
    return _scoringRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScoringRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScoringRemoteDataSource>(value),
    );
  }
}

String _$_scoringRemoteDataSourceHash() =>
    r'a7c7102a1363d751d4294f03bd68cedb44dec3a5';

@ProviderFor(scoringRepository)
final scoringRepositoryProvider = ScoringRepositoryProvider._();

final class ScoringRepositoryProvider extends $FunctionalProvider<
    ScoringRepository,
    ScoringRepository,
    ScoringRepository> with $Provider<ScoringRepository> {
  ScoringRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'scoringRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$scoringRepositoryHash();

  @$internal
  @override
  $ProviderElement<ScoringRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ScoringRepository create(Ref ref) {
    return scoringRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScoringRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScoringRepository>(value),
    );
  }
}

String _$scoringRepositoryHash() => r'8a150ce3b485a9efdca68a5542a26033507d126d';

/// History list of sessions (most-recent first), local-first.

@ProviderFor(sessionsList)
final sessionsListProvider = SessionsListProvider._();

/// History list of sessions (most-recent first), local-first.

final class SessionsListProvider extends $FunctionalProvider<
        AsyncValue<List<ScoringSessionEntity>>,
        List<ScoringSessionEntity>,
        FutureOr<List<ScoringSessionEntity>>>
    with
        $FutureModifier<List<ScoringSessionEntity>>,
        $FutureProvider<List<ScoringSessionEntity>> {
  /// History list of sessions (most-recent first), local-first.
  SessionsListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'sessionsListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$sessionsListHash();

  @$internal
  @override
  $FutureProviderElement<List<ScoringSessionEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<ScoringSessionEntity>> create(Ref ref) {
    return sessionsList(ref);
  }
}

String _$sessionsListHash() => r'e07e49e54708ff7dfb6b920a45d23fcc0dd74787';

/// List of all target faces (cached locally).

@ProviderFor(targetFacesList)
final targetFacesListProvider = TargetFacesListProvider._();

/// List of all target faces (cached locally).

final class TargetFacesListProvider extends $FunctionalProvider<
        AsyncValue<List<TargetFaceEntity>>,
        List<TargetFaceEntity>,
        Stream<List<TargetFaceEntity>>>
    with
        $FutureModifier<List<TargetFaceEntity>>,
        $StreamProvider<List<TargetFaceEntity>> {
  /// List of all target faces (cached locally).
  TargetFacesListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'targetFacesListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$targetFacesListHash();

  @$internal
  @override
  $StreamProviderElement<List<TargetFaceEntity>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<TargetFaceEntity>> create(Ref ref) {
    return targetFacesList(ref);
  }
}

String _$targetFacesListHash() => r'110dd9d42327541dbdafc2e7f877102018662c61';
