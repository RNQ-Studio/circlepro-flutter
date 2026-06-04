// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monetization_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(monetizationRepository)
final monetizationRepositoryProvider = MonetizationRepositoryProvider._();

final class MonetizationRepositoryProvider extends $FunctionalProvider<
    MonetizationRepository,
    MonetizationRepository,
    MonetizationRepository> with $Provider<MonetizationRepository> {
  MonetizationRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'monetizationRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$monetizationRepositoryHash();

  @$internal
  @override
  $ProviderElement<MonetizationRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MonetizationRepository create(Ref ref) {
    return monetizationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MonetizationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MonetizationRepository>(value),
    );
  }
}

String _$monetizationRepositoryHash() =>
    r'f3ac59c4a8802fbe333a689f3f1143fe2b953a34';

@ProviderFor(monetizationPlans)
final monetizationPlansProvider = MonetizationPlansProvider._();

final class MonetizationPlansProvider extends $FunctionalProvider<
        AsyncValue<List<SubscriptionPlanEntity>>,
        List<SubscriptionPlanEntity>,
        FutureOr<List<SubscriptionPlanEntity>>>
    with
        $FutureModifier<List<SubscriptionPlanEntity>>,
        $FutureProvider<List<SubscriptionPlanEntity>> {
  MonetizationPlansProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'monetizationPlansProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$monetizationPlansHash();

  @$internal
  @override
  $FutureProviderElement<List<SubscriptionPlanEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<SubscriptionPlanEntity>> create(Ref ref) {
    return monetizationPlans(ref);
  }
}

String _$monetizationPlansHash() => r'16a9739b7ccb4e640e2f1d40b729bac148e97473';

@ProviderFor(UserSubscription)
final userSubscriptionProvider = UserSubscriptionProvider._();

final class UserSubscriptionProvider
    extends $AsyncNotifierProvider<UserSubscription, UserSubscriptionStatus> {
  UserSubscriptionProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'userSubscriptionProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$userSubscriptionHash();

  @$internal
  @override
  UserSubscription create() => UserSubscription();
}

String _$userSubscriptionHash() => r'f93d011651ab1ec052f566f6a972225b76be82ba';

abstract class _$UserSubscription
    extends $AsyncNotifier<UserSubscriptionStatus> {
  FutureOr<UserSubscriptionStatus> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<UserSubscriptionStatus>, UserSubscriptionStatus>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<UserSubscriptionStatus>, UserSubscriptionStatus>,
        AsyncValue<UserSubscriptionStatus>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(adsList)
final adsListProvider = AdsListFamily._();

final class AdsListProvider extends $FunctionalProvider<
        AsyncValue<List<AdEntity>>, List<AdEntity>, FutureOr<List<AdEntity>>>
    with $FutureModifier<List<AdEntity>>, $FutureProvider<List<AdEntity>> {
  AdsListProvider._(
      {required AdsListFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'adsListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$adsListHash();

  @override
  String toString() {
    return r'adsListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<AdEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<AdEntity>> create(Ref ref) {
    final argument = this.argument as String;
    return adsList(
      ref,
      placement: argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AdsListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$adsListHash() => r'59302d0fefe8a9e8134aa03e3434c735a748ee82';

final class AdsListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<AdEntity>>, String> {
  AdsListFamily._()
      : super(
          retry: null,
          name: r'adsListProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  AdsListProvider call({
    String placement = 'feed',
  }) =>
      AdsListProvider._(argument: placement, from: this);

  @override
  String toString() => r'adsListProvider';
}
