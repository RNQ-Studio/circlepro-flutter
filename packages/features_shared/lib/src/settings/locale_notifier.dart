import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings_repository_provider.dart';

class LocaleNotifier extends AsyncNotifier<Locale> {
  @override
  Future<Locale> build() async {
    final repo = await ref.watch(settingsRepositoryProvider.future);
    return repo.getLocale();
  }

  Future<void> setLocale(Locale locale) async {
    final repo = await ref.read(settingsRepositoryProvider.future);
    await repo.saveLocale(locale);
    state = AsyncData(locale);
  }
}
