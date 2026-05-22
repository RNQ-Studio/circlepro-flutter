import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// In id: **'Flutter Starter'**
  String get appName;

  /// In id: **'Beranda'**
  String get home;

  /// In id: **'Pengaturan'**
  String get settings;

  /// In id: **'Selamat datang!'**
  String get welcome;

  /// In id: **'Tampilan'**
  String get appearance;

  /// In id: **'Ikuti sistem'**
  String get themeSystem;

  /// In id: **'Terang'**
  String get themeLight;

  /// In id: **'Gelap'**
  String get themeDark;

  /// In id: **'Tampilan gelap'**
  String get themeDarkSubtitle;

  /// In id: **'Bahasa'**
  String get language;

  /// In id: **'Indonesia'**
  String get langIndonesia;

  /// In id: **'English'**
  String get langEnglish;

  /// In id: **'Use English language'**
  String get langEnglishSubtitle;

  /// In id: **'Versi'**
  String get version;

  /// In id: **'Versi Aplikasi'**
  String get appVersion;

  /// In id: **'Masuk'**
  String get signIn;

  /// In id: **'OK'**
  String get ok;

  /// In id: **'Batal'**
  String get cancel;

  /// In id: **'Simpan'**
  String get save;

  /// In id: **'Hapus'**
  String get delete;

  /// In id: **'Memuat...'**
  String get loading;

  /// In id: **'Terjadi kesalahan. Coba lagi.'**
  String get errorGeneral;

  /// In id: **'Tidak ada koneksi internet.'**
  String get errorNetwork;

  /// In id: **'Masukkan email yang valid'**
  String get errorInvalidEmail;

  /// In id: **'Minimal 6 karakter'**
  String get errorPasswordTooShort;

  /// In id: **'Masuk'**
  String get login;

  /// In id: **'Keluar'**
  String get logout;

  /// In id: **'Daftar'**
  String get register;

  /// In id: **'Email'**
  String get email;

  /// In id: **'Kata Sandi'**
  String get password;

  /// In id: **'Profil'**
  String get profile;

  /// In id: **'Nama'**
  String get name;

  /// In id: **'Yakin ingin keluar?'**
  String get logoutConfirm;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
