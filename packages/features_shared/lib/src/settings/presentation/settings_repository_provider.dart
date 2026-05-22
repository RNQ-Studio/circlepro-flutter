import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/settings_repository_impl.dart';
import '../domain/repositories/settings_repository.dart';

// FutureProvider karena SharedPreferencesStorage.init() adalah async
// (memanggil SharedPreferences.getInstance() yang mengembalikan Future).
final _settingsStorageProvider = FutureProvider<StorageService>((ref) async {
  final storage = SharedPreferencesStorage();
  await storage.init();
  return storage;
});

final settingsRepositoryProvider =
    FutureProvider<SettingsRepository>((ref) async {
  final storage = await ref.watch(_settingsStorageProvider.future);
  return SettingsRepositoryImpl(storage);
});
