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
    final themeAsync = ref.watch(themeProvider);
    final localeAsync = ref.watch(localeProvider);

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
                  .read(themeProvider.notifier)
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
                  .read(localeProvider.notifier)
                  .setLocale(Locale(val ? 'en' : 'id')),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const Divider(),
          const _BiometricToggleTile(),
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

class _BiometricToggleTile extends StatefulWidget {
  const _BiometricToggleTile();

  @override
  State<_BiometricToggleTile> createState() => _BiometricToggleTileState();
}

class _BiometricToggleTileState extends State<_BiometricToggleTile> {
  bool _isSupported = false;
  bool _isEnabled = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBiometricState();
  }

  Future<void> _loadBiometricState() async {
    try {
      final service = BiometricAuthService();
      final supported = await service.isDeviceSupported();
      final canCheck = await service.canCheckBiometrics();

      final storage = SharedPreferencesStorage();
      await storage.init();
      final enabled = await storage.read(AppConstants.keyBiometricEnabled);

      if (mounted) {
        setState(() {
          _isSupported = supported && canCheck;
          _isEnabled = enabled == 'true';
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _toggleBiometric(bool value) async {
    final storage = SharedPreferencesStorage();
    await storage.init();
    await storage.write(
      AppConstants.keyBiometricEnabled,
      value.toString(),
    );
    setState(() => _isEnabled = value);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const LinearProgressIndicator();
    if (!_isSupported) {
      return const ListTile(
        title: Text('Login Biometrik'),
        subtitle: Text('Tidak tersedia di perangkat ini'),
        enabled: false,
      );
    }

    return SwitchListTile(
      title: const Text('Login Biometrik'),
      subtitle: const Text('Gunakan sidik jari atau Face ID untuk masuk'),
      value: _isEnabled,
      onChanged: _toggleBiometric,
    );
  }
}
