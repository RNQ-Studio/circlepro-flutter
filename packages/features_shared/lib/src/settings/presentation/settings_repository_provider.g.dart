// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_settingsStorage)
final _settingsStorageProvider = _SettingsStorageProvider._();

final class _SettingsStorageProvider extends $FunctionalProvider<
        AsyncValue<StorageService>, StorageService, FutureOr<StorageService>>
    with $FutureModifier<StorageService>, $FutureProvider<StorageService> {
  _SettingsStorageProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'_settingsStorageProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$_settingsStorageHash();

  @$internal
  @override
  $FutureProviderElement<StorageService> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<StorageService> create(Ref ref) {
    return _settingsStorage(ref);
  }
}

String _$_settingsStorageHash() => r'67bc3dbaa90e4fd2c53dff4959abe24aae9dedd9';

@ProviderFor(settingsRepository)
final settingsRepositoryProvider = SettingsRepositoryProvider._();

final class SettingsRepositoryProvider extends $FunctionalProvider<
        AsyncValue<SettingsRepository>,
        SettingsRepository,
        FutureOr<SettingsRepository>>
    with
        $FutureModifier<SettingsRepository>,
        $FutureProvider<SettingsRepository> {
  SettingsRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'settingsRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$settingsRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<SettingsRepository> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<SettingsRepository> create(Ref ref) {
    return settingsRepository(ref);
  }
}

String _$settingsRepositoryHash() =>
    r'3ae96bec18d50780a0b315b89c76bb1bc08071fc';
