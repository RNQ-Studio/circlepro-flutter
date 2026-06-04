// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_equipmentRemote)
final _equipmentRemoteProvider = _EquipmentRemoteProvider._();

final class _EquipmentRemoteProvider extends $FunctionalProvider<
    EquipmentRemoteDataSource,
    EquipmentRemoteDataSource,
    EquipmentRemoteDataSource> with $Provider<EquipmentRemoteDataSource> {
  _EquipmentRemoteProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'_equipmentRemoteProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$_equipmentRemoteHash();

  @$internal
  @override
  $ProviderElement<EquipmentRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EquipmentRemoteDataSource create(Ref ref) {
    return _equipmentRemote(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EquipmentRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EquipmentRemoteDataSource>(value),
    );
  }
}

String _$_equipmentRemoteHash() => r'ba04ad4a84243cbf1cadf2a0cc08e0d28e8df790';

/// Online CRUD of the user's equipment profiles (Module 1, task 1.11b).

@ProviderFor(EquipmentList)
final equipmentListProvider = EquipmentListProvider._();

/// Online CRUD of the user's equipment profiles (Module 1, task 1.11b).
final class EquipmentListProvider extends $AsyncNotifierProvider<EquipmentList,
    List<EquipmentProfileEntity>> {
  /// Online CRUD of the user's equipment profiles (Module 1, task 1.11b).
  EquipmentListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'equipmentListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$equipmentListHash();

  @$internal
  @override
  EquipmentList create() => EquipmentList();
}

String _$equipmentListHash() => r'2506a50d0ede2ff66daf20a9d5445bd2932ec522';

/// Online CRUD of the user's equipment profiles (Module 1, task 1.11b).

abstract class _$EquipmentList
    extends $AsyncNotifier<List<EquipmentProfileEntity>> {
  FutureOr<List<EquipmentProfileEntity>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<EquipmentProfileEntity>>,
        List<EquipmentProfileEntity>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<EquipmentProfileEntity>>,
            List<EquipmentProfileEntity>>,
        AsyncValue<List<EquipmentProfileEntity>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
