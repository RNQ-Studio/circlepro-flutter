import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:features_shared/features_shared.dart';

import 'mock_storage.dart';

void main() {
  late MockStorageService storage;
  late SettingsRepositoryImpl repo;

  setUp(() {
    storage = MockStorageService();
    repo = SettingsRepositoryImpl(storage);
  });

  group('getThemeMode', () {
    test('returns ThemeMode.light when stored value is "light"', () async {
      when(() => storage.read('settings_theme_mode'))
          .thenAnswer((_) async => 'light');
      expect(await repo.getThemeMode(), ThemeMode.light);
    });

    test('returns ThemeMode.dark when stored value is "dark"', () async {
      when(() => storage.read('settings_theme_mode'))
          .thenAnswer((_) async => 'dark');
      expect(await repo.getThemeMode(), ThemeMode.dark);
    });

    test('returns ThemeMode.system when no value stored', () async {
      when(() => storage.read('settings_theme_mode'))
          .thenAnswer((_) async => null);
      expect(await repo.getThemeMode(), ThemeMode.system);
    });

    test('returns ThemeMode.system for unknown stored value', () async {
      when(() => storage.read('settings_theme_mode'))
          .thenAnswer((_) async => 'invalid');
      expect(await repo.getThemeMode(), ThemeMode.system);
    });
  });

  group('saveThemeMode', () {
    test('writes "dark" to storage for ThemeMode.dark', () async {
      when(() => storage.write('settings_theme_mode', 'dark'))
          .thenAnswer((_) async {});
      await repo.saveThemeMode(ThemeMode.dark);
      verify(() => storage.write('settings_theme_mode', 'dark')).called(1);
    });

    test('writes "system" to storage for ThemeMode.system', () async {
      when(() => storage.write('settings_theme_mode', 'system'))
          .thenAnswer((_) async {});
      await repo.saveThemeMode(ThemeMode.system);
      verify(() => storage.write('settings_theme_mode', 'system')).called(1);
    });
  });

  group('getLocale', () {
    test('returns stored locale', () async {
      when(() => storage.read('settings_locale')).thenAnswer((_) async => 'en');
      expect(await repo.getLocale(), const Locale('en'));
    });

    test('returns Locale("id") as default when no value stored', () async {
      when(() => storage.read('settings_locale')).thenAnswer((_) async => null);
      expect(await repo.getLocale(), const Locale('id'));
    });
  });

  group('saveLocale', () {
    test('writes languageCode to storage', () async {
      when(() => storage.write('settings_locale', 'en'))
          .thenAnswer((_) async {});
      await repo.saveLocale(const Locale('en'));
      verify(() => storage.write('settings_locale', 'en')).called(1);
    });
  });
}
