// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(homeRepository)
final homeRepositoryProvider = HomeRepositoryProvider._();

final class HomeRepositoryProvider
    extends $FunctionalProvider<HomeRepository, HomeRepository, HomeRepository>
    with $Provider<HomeRepository> {
  HomeRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'homeRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$homeRepositoryHash();

  @$internal
  @override
  $ProviderElement<HomeRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HomeRepository create(Ref ref) {
    return homeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeRepository>(value),
    );
  }
}

String _$homeRepositoryHash() => r'd19d802b7a2cf910424594aaea5c8a73b02f7265';

@ProviderFor(getUserProfileUseCase)
final getUserProfileUseCaseProvider = GetUserProfileUseCaseProvider._();

final class GetUserProfileUseCaseProvider extends $FunctionalProvider<
    GetUserProfileUseCase,
    GetUserProfileUseCase,
    GetUserProfileUseCase> with $Provider<GetUserProfileUseCase> {
  GetUserProfileUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'getUserProfileUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$getUserProfileUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetUserProfileUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetUserProfileUseCase create(Ref ref) {
    return getUserProfileUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetUserProfileUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetUserProfileUseCase>(value),
    );
  }
}

String _$getUserProfileUseCaseHash() =>
    r'1e8cb88f38e607481c7e119766a9bc10ebe1ca61';

@ProviderFor(userProfile)
final userProfileProvider = UserProfileProvider._();

final class UserProfileProvider extends $FunctionalProvider<
        AsyncValue<UserProfile>, UserProfile, FutureOr<UserProfile>>
    with $FutureModifier<UserProfile>, $FutureProvider<UserProfile> {
  UserProfileProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'userProfileProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$userProfileHash();

  @$internal
  @override
  $FutureProviderElement<UserProfile> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UserProfile> create(Ref ref) {
    return userProfile(ref);
  }
}

String _$userProfileHash() => r'ab1a865a81c55d7cd35dc0d6489678cea9948e20';
