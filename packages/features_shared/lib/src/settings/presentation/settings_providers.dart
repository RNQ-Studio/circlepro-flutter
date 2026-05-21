import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'locale_notifier.dart';
import 'theme_notifier.dart';

export 'settings_repository_provider.dart';

final themeNotifierProvider =
    AsyncNotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);

final localeNotifierProvider =
    AsyncNotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);
