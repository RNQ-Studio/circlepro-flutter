import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:features_shared/features_shared.dart';
import 'package:core/core.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final themeAsync = ref.watch(themeNotifierProvider);
    final localeAsync = ref.watch(localeNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          themeAsync.when(
            data: (mode) => SwitchListTile(
              title: Text(l10n.themeDark),
              subtitle: Text(l10n.themeDarkSubtitle),
              value: mode == ThemeMode.dark,
              onChanged: (val) => ref
                  .read(themeNotifierProvider.notifier)
                  .setThemeMode(val ? ThemeMode.dark : ThemeMode.light),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          localeAsync.when(
            data: (locale) => SwitchListTile(
              title: Text(l10n.langEnglish),
              subtitle: Text(l10n.langEnglishSubtitle),
              value: locale.languageCode == 'en',
              onChanged: (val) => ref
                  .read(localeNotifierProvider.notifier)
                  .setLocale(Locale(val ? 'en' : 'id')),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const Divider(),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snap) => ListTile(
              title: Text(l10n.appVersion),
              trailing: Text(snap.hasData
                  ? '${snap.data!.version}+${snap.data!.buildNumber}'
                  : '—'),
            ),
          ),
        ],
      ),
    );
  }
}
