import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'settings_repository_provider.dart';

part 'theme_notifier.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  Future<ThemeMode> build() async {
    final repo = await ref.watch(settingsRepositoryProvider.future);
    return repo.getThemeMode();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final repo = await ref.read(settingsRepositoryProvider.future);
    await repo.saveThemeMode(mode);
    state = AsyncData(mode);
  }
}
