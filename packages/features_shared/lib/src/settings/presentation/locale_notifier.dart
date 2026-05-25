import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'settings_repository_provider.dart';

part 'locale_notifier.g.dart';

@riverpod
class LocaleNotifier extends _$LocaleNotifier {
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
