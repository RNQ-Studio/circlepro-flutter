// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotes_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_dioClient)
final _dioClientProvider = _DioClientProvider._();

final class _DioClientProvider
    extends $FunctionalProvider<DioClient, DioClient, DioClient>
    with $Provider<DioClient> {
  _DioClientProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'_dioClientProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$_dioClientHash();

  @$internal
  @override
  $ProviderElement<DioClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DioClient create(Ref ref) {
    return _dioClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DioClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DioClient>(value),
    );
  }
}

String _$_dioClientHash() => r'20a6a680cd73f336aff2a3caae7530b4e2e225a1';

@ProviderFor(_quotesRemoteDataSource)
final _quotesRemoteDataSourceProvider = _QuotesRemoteDataSourceProvider._();

final class _QuotesRemoteDataSourceProvider extends $FunctionalProvider<
    QuotesRemoteDataSource,
    QuotesRemoteDataSource,
    QuotesRemoteDataSource> with $Provider<QuotesRemoteDataSource> {
  _QuotesRemoteDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'_quotesRemoteDataSourceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$_quotesRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<QuotesRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  QuotesRemoteDataSource create(Ref ref) {
    return _quotesRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuotesRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QuotesRemoteDataSource>(value),
    );
  }
}

String _$_quotesRemoteDataSourceHash() =>
    r'9046dfa632e50bc5b70104f328bcc6d7e80a12ab';

@ProviderFor(_quotesLocalDataSource)
final _quotesLocalDataSourceProvider = _QuotesLocalDataSourceProvider._();

final class _QuotesLocalDataSourceProvider extends $FunctionalProvider<
    QuotesLocalDataSource,
    QuotesLocalDataSource,
    QuotesLocalDataSource> with $Provider<QuotesLocalDataSource> {
  _QuotesLocalDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'_quotesLocalDataSourceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$_quotesLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<QuotesLocalDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  QuotesLocalDataSource create(Ref ref) {
    return _quotesLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuotesLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QuotesLocalDataSource>(value),
    );
  }
}

String _$_quotesLocalDataSourceHash() =>
    r'3c5483bf160c070899ca10bc6eff96f798c3a917';

@ProviderFor(quotesRepository)
final quotesRepositoryProvider = QuotesRepositoryProvider._();

final class QuotesRepositoryProvider extends $FunctionalProvider<
    QuotesRepository,
    QuotesRepository,
    QuotesRepository> with $Provider<QuotesRepository> {
  QuotesRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'quotesRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$quotesRepositoryHash();

  @$internal
  @override
  $ProviderElement<QuotesRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  QuotesRepository create(Ref ref) {
    return quotesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuotesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QuotesRepository>(value),
    );
  }
}

String _$quotesRepositoryHash() => r'dbf5c7437d85f8894c9ddef36c407f4f6eefd9f5';

@ProviderFor(getQuotesUseCase)
final getQuotesUseCaseProvider = GetQuotesUseCaseProvider._();

final class GetQuotesUseCaseProvider extends $FunctionalProvider<
    GetQuotesUseCase,
    GetQuotesUseCase,
    GetQuotesUseCase> with $Provider<GetQuotesUseCase> {
  GetQuotesUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'getQuotesUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$getQuotesUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetQuotesUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetQuotesUseCase create(Ref ref) {
    return getQuotesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetQuotesUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetQuotesUseCase>(value),
    );
  }
}

String _$getQuotesUseCaseHash() => r'15d056ce2d3db2265d6a00b2178c9a9824d42b2c';

@ProviderFor(syncQuotesUseCase)
final syncQuotesUseCaseProvider = SyncQuotesUseCaseProvider._();

final class SyncQuotesUseCaseProvider extends $FunctionalProvider<
    SyncQuotesUseCase,
    SyncQuotesUseCase,
    SyncQuotesUseCase> with $Provider<SyncQuotesUseCase> {
  SyncQuotesUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'syncQuotesUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$syncQuotesUseCaseHash();

  @$internal
  @override
  $ProviderElement<SyncQuotesUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SyncQuotesUseCase create(Ref ref) {
    return syncQuotesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncQuotesUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncQuotesUseCase>(value),
    );
  }
}

String _$syncQuotesUseCaseHash() => r'a2ca251b97e0c42be04cb8a5e9248235712733dd';
