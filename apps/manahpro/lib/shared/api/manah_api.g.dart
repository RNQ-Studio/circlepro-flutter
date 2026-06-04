// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manah_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Shared authenticated Dio for the online ManahPro features (profile, clubs,
/// feed). Reuses the same token interceptor as the rest of the app.

@ProviderFor(manahDio)
final manahDioProvider = ManahDioProvider._();

/// Shared authenticated Dio for the online ManahPro features (profile, clubs,
/// feed). Reuses the same token interceptor as the rest of the app.

final class ManahDioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Shared authenticated Dio for the online ManahPro features (profile, clubs,
  /// feed). Reuses the same token interceptor as the rest of the app.
  ManahDioProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'manahDioProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$manahDioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return manahDio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$manahDioHash() => r'8e2b553d8e62401823070f2e1734959d574322b9';
