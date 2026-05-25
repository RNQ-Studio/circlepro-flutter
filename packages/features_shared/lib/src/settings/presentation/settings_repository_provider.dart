import 'package:core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/repositories/settings_repository_impl.dart';
import '../domain/repositories/settings_repository.dart';

part 'settings_repository_provider.g.dart';

// FutureProvider karena SharedPreferencesStorage.init() adalah async
// (memanggil SharedPreferences.getInstance() yang mengembalikan Future).
@riverpod
Future<StorageService> _settingsStorage(Ref ref) async {
  final storage = SharedPreferencesStorage();
  await storage.init();
  return storage;
}

@riverpod
Future<SettingsRepository> settingsRepository(Ref ref) async {
  final storage = await ref.watch(_settingsStorageProvider.future);
  return SettingsRepositoryImpl(storage);
}
