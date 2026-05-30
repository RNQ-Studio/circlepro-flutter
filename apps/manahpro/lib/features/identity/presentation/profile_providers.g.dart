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
