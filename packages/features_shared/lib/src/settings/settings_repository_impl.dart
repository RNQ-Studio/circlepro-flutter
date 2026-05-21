import 'package:flutter/material.dart';
import 'package:core/core.dart';

import 'settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._storage);
  final StorageService _storage;

  static const _keyTheme = 'settings_theme_mode';
  static const _keyLocale = 'settings_locale';

  @override
  Future<ThemeMode> getThemeMode() async {
    final value = await _storage.read(_keyTheme);
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) =>
      _storage.write(_keyTheme, mode.name);

  @override
  Future<Locale> getLocale() async {
    final value = await _storage.read(_keyLocale);
    return Locale(value ?? 'id');
  }

  @override
  Future<void> saveLocale(Locale locale) =>
      _storage.write(_keyLocale, locale.languageCode);
}
