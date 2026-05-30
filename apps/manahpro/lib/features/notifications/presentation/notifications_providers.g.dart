// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notificationsRepository)
final notificationsRepositoryProvider = NotificationsRepositoryProvider._();

final class NotificationsRepositoryProvider extends $FunctionalProvider<
    NotificationsRepository,
    NotificationsRepository,
    NotificationsRepository> with $Provider<NotificationsRepository> {
  NotificationsRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'notificationsRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$notificationsRepositoryHash();

  @$internal
  @override
  $ProviderElement<NotificationsRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NotificationsRepository create(Ref ref) {
    return notificationsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationsRepository>(value),
    );
  }
}

String _$notificationsRepositoryHash() =>
    r'6091ade8d95c6d2e248ec70544a2bf96d7f87c14';

/// In-app notification list (task 2.6).

@ProviderFor(Notifications)
final notificationsProvider = NotificationsProvider._();

/// In-app notification list (task 2.6).
final class NotificationsProvider
    extends $AsyncNotifierProvider<Notifications, List<NotificationEntity>> {
  /// In-app notification list (task 2.6).
  NotificationsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'notificationsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$notificationsHash();

  @$internal
  @override
  Notifications create() => Notifications();
}

String _$notificationsHash() => r'aa95883b7a10661e107e271b432805dbe50e4545';

/// In-app notification list (task 2.6).

abstract class _$Notifications
    extends $AsyncNotifier<List<NotificationEntity>> {
  FutureOr<List<NotificationEntity>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<List<NotificationEntity>>, List<NotificationEntity>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<NotificationEntity>>,
            List<NotificationEntity>>,
        AsyncValue<List<NotificationEntity>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

/// Unread badge count.

@ProviderFor(unreadCount)
final unreadCountProvider = UnreadCountProvider._();

/// Unread badge count.

final class UnreadCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// Unread badge count.
  UnreadCountProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'unreadCountProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$unreadCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return unreadCount(ref);
  }
}

String _$unreadCountHash() => r'53604fd66c8cc2e459a9c846a6f2c0954b9a0f6c';

/// Per-category preferences (task 2.5/2.6).

@ProviderFor(NotificationPrefs)
final notificationPrefsProvider = NotificationPrefsProvider._();

/// Per-category preferences (task 2.5/2.6).
final class NotificationPrefsProvider extends $AsyncNotifierProvider<
    NotificationPrefs, List<NotificationPrefEntity>> {
  /// Per-category preferences (task 2.5/2.6).
  NotificationPrefsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'notificationPrefsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$notificationPrefsHash();

  @$internal
  @override
  NotificationPrefs create() => NotificationPrefs();
}

String _$notificationPrefsHash() => r'58bc237cc333985b7c012e53b951d6d102664f04';

/// Per-category preferences (task 2.5/2.6).

abstract class _$NotificationPrefs
    extends $AsyncNotifier<List<NotificationPrefEntity>> {
  FutureOr<List<NotificationPrefEntity>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<NotificationPrefEntity>>,
        List<NotificationPrefEntity>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<NotificationPrefEntity>>,
            List<NotificationPrefEntity>>,
        AsyncValue<List<NotificationPrefEntity>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
