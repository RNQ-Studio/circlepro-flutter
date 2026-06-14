// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deep_link_coordinator.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Captures Latihan Bersama invite deep links and funnels them to the join
/// preview (Sprint 09, tasks 9.1 & 9.4).
///
/// Three transports converge here:
/// * HTTPS App Links / Universal Links (`https://<host>/j/<code>`),
/// * the `manahpro://join?code=` custom-scheme fallback,
/// * the clipboard deferred stash a freshly-installed app left behind.
///
/// Routing is **auth-gated**: a signed-out user's link is stashed and resumed
/// only after they register / log in, so they never land on a preview whose API
/// calls would 401. Warm links for a signed-in user open immediately.

@ProviderFor(DeepLinkCoordinator)
final deepLinkCoordinatorProvider = DeepLinkCoordinatorProvider._();

/// Captures Latihan Bersama invite deep links and funnels them to the join
/// preview (Sprint 09, tasks 9.1 & 9.4).
///
/// Three transports converge here:
/// * HTTPS App Links / Universal Links (`https://<host>/j/<code>`),
/// * the `manahpro://join?code=` custom-scheme fallback,
/// * the clipboard deferred stash a freshly-installed app left behind.
///
/// Routing is **auth-gated**: a signed-out user's link is stashed and resumed
/// only after they register / log in, so they never land on a preview whose API
/// calls would 401. Warm links for a signed-in user open immediately.
final class DeepLinkCoordinatorProvider
    extends $AsyncNotifierProvider<DeepLinkCoordinator, void> {
  /// Captures Latihan Bersama invite deep links and funnels them to the join
  /// preview (Sprint 09, tasks 9.1 & 9.4).
  ///
  /// Three transports converge here:
  /// * HTTPS App Links / Universal Links (`https://<host>/j/<code>`),
  /// * the `manahpro://join?code=` custom-scheme fallback,
  /// * the clipboard deferred stash a freshly-installed app left behind.
  ///
  /// Routing is **auth-gated**: a signed-out user's link is stashed and resumed
  /// only after they register / log in, so they never land on a preview whose API
  /// calls would 401. Warm links for a signed-in user open immediately.
  DeepLinkCoordinatorProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'deepLinkCoordinatorProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$deepLinkCoordinatorHash();

  @$internal
  @override
  DeepLinkCoordinator create() => DeepLinkCoordinator();
}

String _$deepLinkCoordinatorHash() =>
    r'a41ca0db90dea7532fdea14f7ded22764bd95c51';

/// Captures Latihan Bersama invite deep links and funnels them to the join
/// preview (Sprint 09, tasks 9.1 & 9.4).
///
/// Three transports converge here:
/// * HTTPS App Links / Universal Links (`https://<host>/j/<code>`),
/// * the `manahpro://join?code=` custom-scheme fallback,
/// * the clipboard deferred stash a freshly-installed app left behind.
///
/// Routing is **auth-gated**: a signed-out user's link is stashed and resumed
/// only after they register / log in, so they never land on a preview whose API
/// calls would 401. Warm links for a signed-in user open immediately.

abstract class _$DeepLinkCoordinator extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<void>, void>,
        AsyncValue<void>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
