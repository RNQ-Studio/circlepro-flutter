// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(profileRepository)
final profileRepositoryProvider = ProfileRepositoryProvider._();

final class ProfileRepositoryProvider extends $FunctionalProvider<
    ProfileRepository,
    ProfileRepository,
    ProfileRepository> with $Provider<ProfileRepository> {
  ProfileRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'profileRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$profileRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProfileRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ProfileRepository create(Ref ref) {
    return profileRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileRepository>(value),
    );
  }
}

String _$profileRepositoryHash() => r'9f644de6aa2ccf0e4e19fbd5955bd625aadc66b9';

/// The signed-in user's profile (Module 0/2, task 2.3).

@ProviderFor(MyProfile)
final myProfileProvider = MyProfileProvider._();

/// The signed-in user's profile (Module 0/2, task 2.3).
final class MyProfileProvider
    extends $AsyncNotifierProvider<MyProfile, ProfileEntity> {
  /// The signed-in user's profile (Module 0/2, task 2.3).
  MyProfileProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'myProfileProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$myProfileHash();

  @$internal
  @override
  MyProfile create() => MyProfile();
}

String _$myProfileHash() => r'bafc7c2edbf4b71ae229a3e3b2147ea58eaff8ae';

/// The signed-in user's profile (Module 0/2, task 2.3).

abstract class _$MyProfile extends $AsyncNotifier<ProfileEntity> {
  FutureOr<ProfileEntity> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ProfileEntity>, ProfileEntity>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<ProfileEntity>, ProfileEntity>,
        AsyncValue<ProfileEntity>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

/// A public user's profile (Phase 4). Supports follow/unfollow action.

@ProviderFor(PublicProfile)
final publicProfileProvider = PublicProfileFamily._();

/// A public user's profile (Phase 4). Supports follow/unfollow action.
final class PublicProfileProvider
    extends $AsyncNotifierProvider<PublicProfile, ProfileEntity> {
  /// A public user's profile (Phase 4). Supports follow/unfollow action.
  PublicProfileProvider._(
      {required PublicProfileFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'publicProfileProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$publicProfileHash();

  @override
  String toString() {
    return r'publicProfileProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PublicProfile create() => PublicProfile();

  @override
  bool operator ==(Object other) {
    return other is PublicProfileProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$publicProfileHash() => r'50ee243e9bcebd3f88febf7cdcd1335704525c4f';

/// A public user's profile (Phase 4). Supports follow/unfollow action.

final class PublicProfileFamily extends $Family
    with
        $ClassFamilyOverride<PublicProfile, AsyncValue<ProfileEntity>,
            ProfileEntity, FutureOr<ProfileEntity>, int> {
  PublicProfileFamily._()
      : super(
          retry: null,
          name: r'publicProfileProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// A public user's profile (Phase 4). Supports follow/unfollow action.

  PublicProfileProvider call(
    int userId,
  ) =>
      PublicProfileProvider._(argument: userId, from: this);

  @override
  String toString() => r'publicProfileProvider';
}

/// A public user's profile (Phase 4). Supports follow/unfollow action.

abstract class _$PublicProfile extends $AsyncNotifier<ProfileEntity> {
  late final _$args = ref.$arg as int;
  int get userId => _$args;

  FutureOr<ProfileEntity> build(
    int userId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ProfileEntity>, ProfileEntity>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<ProfileEntity>, ProfileEntity>,
        AsyncValue<ProfileEntity>,
        Object?,
        Object?>;
    element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}

@ProviderFor(followersList)
final followersListProvider = FollowersListFamily._();

final class FollowersListProvider extends $FunctionalProvider<
        AsyncValue<List<ProfileEntity>>,
        List<ProfileEntity>,
        FutureOr<List<ProfileEntity>>>
    with
        $FutureModifier<List<ProfileEntity>>,
        $FutureProvider<List<ProfileEntity>> {
  FollowersListProvider._(
      {required FollowersListFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'followersListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$followersListHash();

  @override
  String toString() {
    return r'followersListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ProfileEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<ProfileEntity>> create(Ref ref) {
    final argument = this.argument as int;
    return followersList(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FollowersListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$followersListHash() => r'e840f76e09c5de8b9aeabbdf9edc6eaad22568ba';

final class FollowersListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ProfileEntity>>, int> {
  FollowersListFamily._()
      : super(
          retry: null,
          name: r'followersListProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  FollowersListProvider call(
    int userId,
  ) =>
      FollowersListProvider._(argument: userId, from: this);

  @override
  String toString() => r'followersListProvider';
}

@ProviderFor(followingList)
final followingListProvider = FollowingListFamily._();

final class FollowingListProvider extends $FunctionalProvider<
        AsyncValue<List<ProfileEntity>>,
        List<ProfileEntity>,
        FutureOr<List<ProfileEntity>>>
    with
        $FutureModifier<List<ProfileEntity>>,
        $FutureProvider<List<ProfileEntity>> {
  FollowingListProvider._(
      {required FollowingListFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'followingListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$followingListHash();

  @override
  String toString() {
    return r'followingListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ProfileEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<ProfileEntity>> create(Ref ref) {
    final argument = this.argument as int;
    return followingList(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FollowingListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$followingListHash() => r'954dd6ed8a5de1b9a5e42fa8746c258851336f7c';

final class FollowingListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ProfileEntity>>, int> {
  FollowingListFamily._()
      : super(
          retry: null,
          name: r'followingListProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  FollowingListProvider call(
    int userId,
  ) =>
      FollowingListProvider._(argument: userId, from: this);

  @override
  String toString() => r'followingListProvider';
}
