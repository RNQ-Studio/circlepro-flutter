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
          _SectionHeader(l10n.appearance),
          themeAsync.when(
            data: (mode) => _ThemeTile(
              current: mode,
              onChanged: (val) =>
                  ref.read(themeNotifierProvider.notifier).setThemeMode(val),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const Divider(),
          _SectionHeader(l10n.language),
          localeAsync.when(
            data: (locale) => _LanguageTile(
              current: locale,
              onChanged: (val) =>
                  ref.read(localeNotifierProvider.notifier).setLocale(val),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const Divider(),
          const _AboutTile(),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                )),
        dense: true,
      );
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({required this.current, required this.onChanged});
  final ThemeMode current;
  final void Function(ThemeMode) onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return RadioGroup<ThemeMode>(
      groupValue: current,
      onChanged: (val) { if (val != null) onChanged(val); },
      child: Column(
        children: ThemeMode.values
            .map((mode) => RadioListTile<ThemeMode>(
                  title: Text(switch (mode) {
                    ThemeMode.system => l10n.themeSystem,
                    ThemeMode.light => l10n.themeLight,
                    ThemeMode.dark => l10n.themeDark,
                  }),
                  value: mode,
                ))
            .toList(),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({required this.current, required this.onChanged});
  final Locale current;
  final void Function(Locale) onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return RadioGroup<String>(
      groupValue: current.languageCode,
      onChanged: (val) { if (val != null) onChanged(Locale(val)); },
      child: Column(
        children: [
          RadioListTile<String>(
            title: Text(l10n.langIndonesia),
            value: 'id',
          ),
          RadioListTile<String>(
            title: Text(l10n.langEnglish),
            value: 'en',
          ),
        ],
      ),
    );
  }
}

class _AboutTile extends StatelessWidget {
  const _AboutTile();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snap) => ListTile(
        title: Text(l10n.version),
        trailing: Text(snap.hasData
            ? '${snap.data!.version}+${snap.data!.buildNumber}'
            : '—'),
      ),
    );
  }
}
