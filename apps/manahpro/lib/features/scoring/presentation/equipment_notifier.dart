import 'package:core/core.dart';
import 'package:features_shared/features_shared.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/remote/equipment_remote_data_source.dart';
import '../domain/equipment_profile_entity.dart';

part 'equipment_notifier.g.dart';

@Riverpod(keepAlive: true)
EquipmentRemoteDataSource _equipmentRemote(Ref ref) {
  return EquipmentRemoteDataSource(
    DioClient(
      ref.watch(storageServiceProvider),
      onLogout: () async {
        await ref.read(authProvider.notifier).logout();
      },
    ).dio,
  );
}

/// Online CRUD of the user's equipment profiles (Module 1, task 1.11b).
@riverpod
class EquipmentList extends _$EquipmentList {
  @override
  Future<List<EquipmentProfileEntity>> build() {
    return ref.watch(_equipmentRemoteProvider).fetchAll();
  }

  EquipmentRemoteDataSource get _remote => ref.read(_equipmentRemoteProvider);

  /// Create (id empty) or update (id present) then refresh the list.
  Future<void> save(EquipmentProfileEntity profile) async {
    state = const AsyncLoading();
    if (profile.id.isEmpty) {
      await _remote.create(profile);
    } else {
      await _remote.update(profile);
    }
    ref.invalidateSelf();
    await future;
  }

  Future<void> remove(String id) async {
    await _remote.delete(id);
    ref.invalidateSelf();
    await future;
  }
}
