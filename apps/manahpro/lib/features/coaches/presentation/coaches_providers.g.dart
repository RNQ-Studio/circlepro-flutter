// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coaches_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(coachesRepository)
final coachesRepositoryProvider = CoachesRepositoryProvider._();

final class CoachesRepositoryProvider extends $FunctionalProvider<
    CoachesRepository,
    CoachesRepository,
    CoachesRepository> with $Provider<CoachesRepository> {
  CoachesRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'coachesRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$coachesRepositoryHash();

  @$internal
  @override
  $ProviderElement<CoachesRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CoachesRepository create(Ref ref) {
    return coachesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoachesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoachesRepository>(value),
    );
  }
}

String _$coachesRepositoryHash() => r'c76c226864f2f1673a3ea8faaaf202bb17062e17';

@ProviderFor(coachDirectory)
final coachDirectoryProvider = CoachDirectoryFamily._();

final class CoachDirectoryProvider extends $FunctionalProvider<
        AsyncValue<List<CoachProfileEntity>>,
        List<CoachProfileEntity>,
        FutureOr<List<CoachProfileEntity>>>
    with
        $FutureModifier<List<CoachProfileEntity>>,
        $FutureProvider<List<CoachProfileEntity>> {
  CoachDirectoryProvider._(
      {required CoachDirectoryFamily super.from,
      required ({
        String? search,
        String? specialty,
        String? city,
      })
          super.argument})
      : super(
          retry: null,
          name: r'coachDirectoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$coachDirectoryHash();

  @override
  String toString() {
    return r'coachDirectoryProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<CoachProfileEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<CoachProfileEntity>> create(Ref ref) {
    final argument = this.argument as ({
      String? search,
      String? specialty,
      String? city,
    });
    return coachDirectory(
      ref,
      search: argument.search,
      specialty: argument.specialty,
      city: argument.city,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CoachDirectoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$coachDirectoryHash() => r'ab5aee580e46a81e0939b1699e90658afabbc364';

final class CoachDirectoryFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<List<CoachProfileEntity>>,
            ({
              String? search,
              String? specialty,
              String? city,
            })> {
  CoachDirectoryFamily._()
      : super(
          retry: null,
          name: r'coachDirectoryProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  CoachDirectoryProvider call({
    String? search,
    String? specialty,
    String? city,
  }) =>
      CoachDirectoryProvider._(argument: (
        search: search,
        specialty: specialty,
        city: city,
      ), from: this);

  @override
  String toString() => r'coachDirectoryProvider';
}

@ProviderFor(coachDetail)
final coachDetailProvider = CoachDetailFamily._();

final class CoachDetailProvider extends $FunctionalProvider<
        AsyncValue<CoachProfileEntity>,
        CoachProfileEntity,
        FutureOr<CoachProfileEntity>>
    with
        $FutureModifier<CoachProfileEntity>,
        $FutureProvider<CoachProfileEntity> {
  CoachDetailProvider._(
      {required CoachDetailFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'coachDetailProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$coachDetailHash();

  @override
  String toString() {
    return r'coachDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<CoachProfileEntity> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<CoachProfileEntity> create(Ref ref) {
    final argument = this.argument as String;
    return coachDetail(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CoachDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$coachDetailHash() => r'552bd6a605da8a9a162100fac1a4e290ff643b8b';

final class CoachDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CoachProfileEntity>, String> {
  CoachDetailFamily._()
      : super(
          retry: null,
          name: r'coachDetailProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  CoachDetailProvider call(
    String id,
  ) =>
      CoachDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'coachDetailProvider';
}

@ProviderFor(coachReviews)
final coachReviewsProvider = CoachReviewsFamily._();

final class CoachReviewsProvider extends $FunctionalProvider<
        AsyncValue<List<CoachReviewEntity>>,
        List<CoachReviewEntity>,
        FutureOr<List<CoachReviewEntity>>>
    with
        $FutureModifier<List<CoachReviewEntity>>,
        $FutureProvider<List<CoachReviewEntity>> {
  CoachReviewsProvider._(
      {required CoachReviewsFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'coachReviewsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$coachReviewsHash();

  @override
  String toString() {
    return r'coachReviewsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<CoachReviewEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<CoachReviewEntity>> create(Ref ref) {
    final argument = this.argument as String;
    return coachReviews(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CoachReviewsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$coachReviewsHash() => r'4c0a7ba86289528f0cab492fa9dbc284860295af';

final class CoachReviewsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<CoachReviewEntity>>, String> {
  CoachReviewsFamily._()
      : super(
          retry: null,
          name: r'coachReviewsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  CoachReviewsProvider call(
    String coachId,
  ) =>
      CoachReviewsProvider._(argument: coachId, from: this);

  @override
  String toString() => r'coachReviewsProvider';
}
