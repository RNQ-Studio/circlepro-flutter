// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clubs_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(clubsRepository)
final clubsRepositoryProvider = ClubsRepositoryProvider._();

final class ClubsRepositoryProvider extends $FunctionalProvider<ClubsRepository,
    ClubsRepository, ClubsRepository> with $Provider<ClubsRepository> {
  ClubsRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'clubsRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$clubsRepositoryHash();

  @$internal
  @override
  $ProviderElement<ClubsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ClubsRepository create(Ref ref) {
    return clubsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClubsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClubsRepository>(value),
    );
  }
}

String _$clubsRepositoryHash() => r'6ed192af4a6926f0f109185872884d74de523399';

/// Club directory (optionally filtered by [search]).

@ProviderFor(clubDirectory)
final clubDirectoryProvider = ClubDirectoryFamily._();

/// Club directory (optionally filtered by [search]).

final class ClubDirectoryProvider extends $FunctionalProvider<
        AsyncValue<List<ClubEntity>>,
        List<ClubEntity>,
        FutureOr<List<ClubEntity>>>
    with $FutureModifier<List<ClubEntity>>, $FutureProvider<List<ClubEntity>> {
  /// Club directory (optionally filtered by [search]).
  ClubDirectoryProvider._(
      {required ClubDirectoryFamily super.from,
      required String? super.argument})
      : super(
          retry: null,
          name: r'clubDirectoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$clubDirectoryHash();

  @override
  String toString() {
    return r'clubDirectoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ClubEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<ClubEntity>> create(Ref ref) {
    final argument = this.argument as String?;
    return clubDirectory(
      ref,
      search: argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ClubDirectoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$clubDirectoryHash() => r'a326e96cc841b159d4b7acaadce5572d79a5f54e';

/// Club directory (optionally filtered by [search]).

final class ClubDirectoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ClubEntity>>, String?> {
  ClubDirectoryFamily._()
      : super(
          retry: null,
          name: r'clubDirectoryProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Club directory (optionally filtered by [search]).

  ClubDirectoryProvider call({
    String? search,
  }) =>
      ClubDirectoryProvider._(argument: search, from: this);

  @override
  String toString() => r'clubDirectoryProvider';
}

/// Clubs the user belongs to.

@ProviderFor(myClubs)
final myClubsProvider = MyClubsProvider._();

/// Clubs the user belongs to.

final class MyClubsProvider extends $FunctionalProvider<
        AsyncValue<List<ClubEntity>>,
        List<ClubEntity>,
        FutureOr<List<ClubEntity>>>
    with $FutureModifier<List<ClubEntity>>, $FutureProvider<List<ClubEntity>> {
  /// Clubs the user belongs to.
  MyClubsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'myClubsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$myClubsHash();

  @$internal
  @override
  $FutureProviderElement<List<ClubEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<ClubEntity>> create(Ref ref) {
    return myClubs(ref);
  }
}

String _$myClubsHash() => r'aa1ab4befb4136f86e220834aa6ed3c5ea5d139f';

/// A single club's detail.

@ProviderFor(clubDetail)
final clubDetailProvider = ClubDetailFamily._();

/// A single club's detail.

final class ClubDetailProvider extends $FunctionalProvider<
        AsyncValue<ClubEntity>, ClubEntity, FutureOr<ClubEntity>>
    with $FutureModifier<ClubEntity>, $FutureProvider<ClubEntity> {
  /// A single club's detail.
  ClubDetailProvider._(
      {required ClubDetailFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'clubDetailProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$clubDetailHash();

  @override
  String toString() {
    return r'clubDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ClubEntity> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ClubEntity> create(Ref ref) {
    final argument = this.argument as String;
    return clubDetail(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ClubDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$clubDetailHash() => r'62b71d24790c3272ed2ebf0c34662d04ee8711f8';

/// A single club's detail.

final class ClubDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ClubEntity>, String> {
  ClubDetailFamily._()
      : super(
          retry: null,
          name: r'clubDetailProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// A single club's detail.

  ClubDetailProvider call(
    String clubId,
  ) =>
      ClubDetailProvider._(argument: clubId, from: this);

  @override
  String toString() => r'clubDetailProvider';
}

/// A club's member list.

@ProviderFor(clubMembers)
final clubMembersProvider = ClubMembersFamily._();

/// A club's member list.

final class ClubMembersProvider extends $FunctionalProvider<
        AsyncValue<List<ClubMemberEntity>>,
        List<ClubMemberEntity>,
        FutureOr<List<ClubMemberEntity>>>
    with
        $FutureModifier<List<ClubMemberEntity>>,
        $FutureProvider<List<ClubMemberEntity>> {
  /// A club's member list.
  ClubMembersProvider._(
      {required ClubMembersFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'clubMembersProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$clubMembersHash();

  @override
  String toString() {
    return r'clubMembersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ClubMemberEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<ClubMemberEntity>> create(Ref ref) {
    final argument = this.argument as String;
    return clubMembers(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ClubMembersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$clubMembersHash() => r'34c72701b5f3502a97fcf9e338f3a793e4aa35c8';

/// A club's member list.

final class ClubMembersFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ClubMemberEntity>>, String> {
  ClubMembersFamily._()
      : super(
          retry: null,
          name: r'clubMembersProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// A club's member list.

  ClubMembersProvider call(
    String clubId,
  ) =>
      ClubMembersProvider._(argument: clubId, from: this);

  @override
  String toString() => r'clubMembersProvider';
}
