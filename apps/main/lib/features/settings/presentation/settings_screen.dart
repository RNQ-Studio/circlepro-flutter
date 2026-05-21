import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:features_shared/features_shared.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeAsync = ref.watch(themeNotifierProvider);
    final localeAsync = ref.watch(localeNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionHeader('Appearance'),
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
          const _SectionHeader('Language'),
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
  Widget build(BuildContext context) => RadioGroup<ThemeMode>(
        groupValue: current,
        onChanged: (val) {
          if (val != null) onChanged(val);
        },
        child: Column(
          children: ThemeMode.values
              .map((mode) => RadioListTile<ThemeMode>(
                    title: Text(switch (mode) {
                      ThemeMode.system => 'System default',
                      ThemeMode.light => 'Light',
                      ThemeMode.dark => 'Dark',
                    }),
                    value: mode,
                  ))
              .toList(),
        ),
      );
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({required this.current, required this.onChanged});
  final Locale current;
  final void Function(Locale) onChanged;

  @override
  Widget build(BuildContext context) => RadioGroup<String>(
        groupValue: current.languageCode,
        onChanged: (val) {
          if (val != null) onChanged(Locale(val));
        },
        child: const Column(
          children: [
            RadioListTile<String>(
              title: Text('Indonesia'),
              value: 'id',
            ),
            RadioListTile<String>(
              title: Text('English'),
              value: 'en',
            ),
          ],
        ),
      );
}

class _AboutTile extends StatelessWidget {
  const _AboutTile();

  @override
  Widget build(BuildContext context) => FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snap) => ListTile(
          title: const Text('Version'),
          trailing: Text(snap.hasData
              ? '${snap.data!.version}+${snap.data!.buildNumber}'
              : '—'),
        ),
      );
}
