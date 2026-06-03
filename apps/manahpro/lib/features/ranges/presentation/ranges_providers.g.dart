// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranges_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(rangesRepository)
final rangesRepositoryProvider = RangesRepositoryProvider._();

final class RangesRepositoryProvider extends $FunctionalProvider<
    RangesRepository,
    RangesRepository,
    RangesRepository> with $Provider<RangesRepository> {
  RangesRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'rangesRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$rangesRepositoryHash();

  @$internal
  @override
  $ProviderElement<RangesRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RangesRepository create(Ref ref) {
    return rangesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RangesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RangesRepository>(value),
    );
  }
}

String _$rangesRepositoryHash() => r'c99d571ce266b1885a427d3b4e3917345f0cb887';

@ProviderFor(rangeDirectory)
final rangeDirectoryProvider = RangeDirectoryFamily._();

final class RangeDirectoryProvider extends $FunctionalProvider<
        AsyncValue<List<ArcheryRangeEntity>>,
        List<ArcheryRangeEntity>,
        FutureOr<List<ArcheryRangeEntity>>>
    with
        $FutureModifier<List<ArcheryRangeEntity>>,
        $FutureProvider<List<ArcheryRangeEntity>> {
  RangeDirectoryProvider._(
      {required RangeDirectoryFamily super.from,
      required ({
        String? search,
        String? facility,
        double? latitude,
        double? longitude,
      })
          super.argument})
      : super(
          retry: null,
          name: r'rangeDirectoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$rangeDirectoryHash();

  @override
  String toString() {
    return r'rangeDirectoryProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<ArcheryRangeEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<ArcheryRangeEntity>> create(Ref ref) {
    final argument = this.argument as ({
      String? search,
      String? facility,
      double? latitude,
      double? longitude,
    });
    return rangeDirectory(
      ref,
      search: argument.search,
      facility: argument.facility,
      latitude: argument.latitude,
      longitude: argument.longitude,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RangeDirectoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$rangeDirectoryHash() => r'2583ce671d10652760d5fb3305ae610dc761bd3f';

final class RangeDirectoryFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<List<ArcheryRangeEntity>>,
            ({
              String? search,
              String? facility,
              double? latitude,
              double? longitude,
            })> {
  RangeDirectoryFamily._()
      : super(
          retry: null,
          name: r'rangeDirectoryProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  RangeDirectoryProvider call({
    String? search,
    String? facility,
    double? latitude,
    double? longitude,
  }) =>
      RangeDirectoryProvider._(argument: (
        search: search,
        facility: facility,
        latitude: latitude,
        longitude: longitude,
      ), from: this);

  @override
  String toString() => r'rangeDirectoryProvider';
}

@ProviderFor(rangeDetail)
final rangeDetailProvider = RangeDetailFamily._();

final class RangeDetailProvider extends $FunctionalProvider<
        AsyncValue<ArcheryRangeEntity>,
        ArcheryRangeEntity,
        FutureOr<ArcheryRangeEntity>>
    with
        $FutureModifier<ArcheryRangeEntity>,
        $FutureProvider<ArcheryRangeEntity> {
  RangeDetailProvider._(
      {required RangeDetailFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'rangeDetailProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$rangeDetailHash();

  @override
  String toString() {
    return r'rangeDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ArcheryRangeEntity> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ArcheryRangeEntity> create(Ref ref) {
    final argument = this.argument as String;
    return rangeDetail(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RangeDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$rangeDetailHash() => r'2ac5935d130ff4633814ca867bc9ad32d077ecca';

final class RangeDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ArcheryRangeEntity>, String> {
  RangeDetailFamily._()
      : super(
          retry: null,
          name: r'rangeDetailProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  RangeDetailProvider call(
    String id,
  ) =>
      RangeDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'rangeDetailProvider';
}
