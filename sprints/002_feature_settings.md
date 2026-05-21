# Sprint 002 — Feature: Settings

Tujuan: menambahkan fitur Settings ke kedua flavor app — memungkinkan pengguna mengubah tema (light/dark/system) dan bahasa (Indonesia/English), dengan preferensi yang tersimpan secara persisten via `SharedPreferencesStorage`.

Acceptance criteria sprint: Settings screen tampil di kedua app, theme switch dan language switch bekerja secara real-time dan tersimpan antar sesi.

> **Catatan versi dependency:**
> Selalu gunakan versi **terbaru** untuk semua dependency.
> Sebelum eksekusi, verifikasi versi terbaru di [pub.dev](https://pub.dev).
> Versi di dokumen ini adalah versi terbaru pada saat sprint ditulis **(2026-05-21)** dan wajib diperbarui jika sudah ada versi lebih baru saat eksekusi.
>
> | Package | Versi saat dokumen ditulis |
> |---|---|
> | `package_info_plus` | `^8.3.0` |

---

## Arsitektur Settings Feature

Settings dibagi dua lapisan:

1. **Shared logic** (`packages/features_shared/src/settings/`) — repository, notifier theme, notifier locale — settings adalah fitur yang dipakai semua flavor, sesuai peran `features_shared`. Menggunakan `SharedPreferencesStorage` dari `core` (data tidak sensitif).
2. **Exclusive UI** (`apps/main` dan `apps/variant`) — `SettingsScreen` per flavor dengan style berbeda, demonstrasi bahwa fitur yang sama bisa tampil berbeda antar flavor.

```
packages/features_shared/lib/src/settings/
├── settings_repository.dart          ← abstract interface
├── settings_repository_impl.dart     ← implementasi via SharedPreferencesStorage
├── settings_repository_provider.dart ← FutureProvider untuk storage + repository
├── settings_providers.dart           ← themeNotifierProvider + localeNotifierProvider
├── theme_notifier.dart               ← AsyncNotifier<ThemeMode>
└── locale_notifier.dart              ← AsyncNotifier<Locale>

apps/main/lib/features/settings/
└── presentation/
    ├── settings_screen.dart          ← UI main: RadioListTile (Light/Dark/System)
    └── settings_route.dart           ← GoRoute definition

apps/variant/lib/features/settings/
└── presentation/
    ├── settings_screen.dart          ← UI variant: SwitchListTile (lebih simpel)
    └── settings_route.dart           ← GoRoute definition
```

---

## Phase 1 — `packages/features_shared`: Settings Logic

- [x] Buat direktori `packages/features_shared/lib/src/settings/`
- [x] `settings_repository.dart` — abstract interface:
  ```dart
  abstract class SettingsRepository {
    Future<ThemeMode> getThemeMode();
    Future<void> saveThemeMode(ThemeMode mode);
    Future<Locale> getLocale();
    Future<void> saveLocale(Locale locale);
  }
  ```
- [x] `settings_repository_impl.dart` — implementasi via `SharedPreferencesStorage`:
  ```dart
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
  ```
  > `SharedPreferencesStorage` dipakai karena data settings tidak sensitif. Provider-nya dibuat terpisah dari `storageServiceProvider` (yang pakai `SecureStorageService` untuk token auth).
  > `StorageService`, `SharedPreferencesStorage` diimport dari `package:core/core.dart`.

- [x] `settings_repository_provider.dart` — FutureProvider untuk storage dan repository (dipisah dari notifiers untuk menghindari circular import):
  ```dart
  import 'package:core/core.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'settings_repository.dart';
  import 'settings_repository_impl.dart';

  final _settingsStorageProvider = FutureProvider<StorageService>((ref) async {
    final storage = SharedPreferencesStorage();
    await storage.init();
    return storage;
  });

  final settingsRepositoryProvider = FutureProvider<SettingsRepository>((ref) async {
    final storage = await ref.watch(_settingsStorageProvider.future);
    return SettingsRepositoryImpl(storage);
  });
  ```
- [x] `settings_providers.dart` — aggregator: deklarasi notifier providers + re-export repository provider:
  ```dart
  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'locale_notifier.dart';
  import 'theme_notifier.dart';

  export 'settings_repository_provider.dart';

  final themeNotifierProvider =
      AsyncNotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);

  final localeNotifierProvider =
      AsyncNotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);
  ```
  > FutureProvider untuk storage & repository ada di `settings_repository_provider.dart` (dipisah untuk menghindari circular import — notifiers import repository provider, bukan sebaliknya).
- [x] `theme_notifier.dart`:
  ```dart
  class ThemeNotifier extends AsyncNotifier<ThemeMode> {
    @override
    Future<ThemeMode> build() async {
      final repo = await ref.watch(settingsRepositoryProvider.future);
      return repo.getThemeMode();
    }

    Future<void> setThemeMode(ThemeMode mode) async {
      final repo = await ref.read(settingsRepositoryProvider.future);
      await repo.saveThemeMode(mode);
      state = AsyncData(mode);
    }
  }
  ```
- [x] `locale_notifier.dart`:
  ```dart
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
  ```
- [x] Tambahkan `AppRoutes.settings = '/settings'` ke `packages/core/lib/src/router/app_routes.dart`
  > Route constant tetap di `core` karena merupakan infrastruktur navigasi, bukan fitur.
- [x] Export semua dari `lib/features_shared.dart`:
  ```dart
  // settings — domain
  export 'src/settings/settings_repository.dart';

  // settings — data
  export 'src/settings/settings_repository_impl.dart';

  // settings — presentation
  export 'src/settings/settings_providers.dart';
  export 'src/settings/theme_notifier.dart';
  export 'src/settings/locale_notifier.dart';
  ```
- [x] `dart pub get` dari root
- [x] `dart analyze packages/core packages/features_shared` — no issues

**Selesai jika:** semua provider terekspor dari `features_shared.dart` dan `dart analyze` clean.

---

## Phase 2 — `apps/main`: Settings Feature

- [x] Tambahkan `package_info_plus` ke `apps/main/pubspec.yaml`:
  ```yaml
  dependencies:
    ...
    package_info_plus: ^8.3.0
  ```
- [x] `dart pub get` dari root
- [x] Buat `apps/main/lib/features/settings/presentation/settings_screen.dart`:
  ```dart
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
          onChanged: (val) { if (val != null) onChanged(val); },
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
          onChanged: (val) { if (val != null) onChanged(Locale(val)); },
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
  ```
- [x] Buat `apps/main/lib/features/settings/presentation/settings_route.dart`:
  ```dart
  import 'package:go_router/go_router.dart';
  import 'package:core/core.dart';
  import 'settings_screen.dart';

  final settingsRoute = GoRoute(
    path: AppRoutes.settings,
    builder: (context, state) => const SettingsScreen(),
  );
  ```
- [x] Tambahkan `settingsRoute` ke `apps/main/lib/router/app_router.dart`:
  ```dart
  import '../features/settings/presentation/settings_route.dart';

  final appRouter = GoRouter(
    initialLocation: '/',
    redirect: authRedirect,
    observers: [AppNavigatorObserver()],
    routes: [
      ...authRoutes,
      settingsRoute,
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
  ```
- [x] Tambahkan tombol navigasi ke settings di `apps/main/lib/home/home_screen.dart`:
  > Perlu menambahkan dua import baru: `go_router` untuk `context.push` dan `core` untuk `AppRoutes.settings`.
  ```dart
  import 'package:flutter/material.dart';
  import 'package:go_router/go_router.dart';
  import 'package:core/core.dart';

  class HomeScreen extends StatelessWidget {
    const HomeScreen({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => context.push(AppRoutes.settings),
            ),
          ],
        ),
        body: const Center(child: Text('Welcome!')),
      );
    }
  }
  ```
- [x] `dart analyze apps/main` — no issues

**Selesai jika:** Settings screen tampil dari home, semua pilihan theme dan language bisa dipilih.

---

## Phase 3 — `apps/variant`: Settings Feature

- [x] Tambahkan `package_info_plus` ke `apps/variant/pubspec.yaml` (versi sama dengan main)
- [x] `dart pub get` dari root
- [x] Buat `apps/variant/lib/features/settings/presentation/settings_screen.dart`:
  > UI variant menggunakan `SwitchListTile` — lebih compact, demonstrasi style berbeda untuk fitur yang sama.
  ```dart
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
        appBar: AppBar(title: const Text('Pengaturan')),
        body: ListView(
          children: [
            themeAsync.when(
              data: (mode) => SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Tampilan gelap'),
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
                title: const Text('English'),
                subtitle: const Text('Use English language'),
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
                title: const Text('Versi Aplikasi'),
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
  ```
- [x] Buat `apps/variant/lib/features/settings/presentation/settings_route.dart` (identik dengan main)
- [x] Tambahkan `settingsRoute` ke `apps/variant/lib/router/app_router.dart`
- [x] Tambahkan tombol navigasi ke settings di `apps/variant/lib/home/home_screen.dart`:
  ```dart
  import 'package:flutter/material.dart';
  import 'package:go_router/go_router.dart';
  import 'package:core/core.dart';

  class HomeScreen extends StatelessWidget {
    const HomeScreen({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Variant'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => context.push(AppRoutes.settings),
            ),
          ],
        ),
        body: const Center(child: Text('Welcome to Variant!')),
      );
    }
  }
  ```
- [x] `dart analyze apps/variant` — no issues

**Selesai jika:** Settings screen tampil dari home variant, theme & language bisa diganti.

---

## Phase 4 — Wire Up Theme & Locale di `app.dart`

Kedua app perlu watch `themeNotifierProvider` dan `localeNotifierProvider` di `_AppRouterState.build()` agar perubahan terefleksi langsung ke `MaterialApp.router`.

- [x] Update `apps/main/lib/app.dart` — tambahkan watch di `_AppRouterState.build()`:
  ```dart
  @override
  Widget build(BuildContext context) {
    final themeMode =
        ref.watch(themeNotifierProvider).asData?.value ?? ThemeMode.system;
    final locale = ref.watch(localeNotifierProvider).asData?.value;

    return MaterialApp.router(
      title: 'Flutter Starter',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: appRouter,
    );
  }
  ```
  > `.asData?.value` aman: saat provider masih loading, fallback ke `ThemeMode.system` dan `locale: null` (pakai locale device). `valueOrNull` tidak ada di Riverpod 3.x.
  > `_AppRouter` sudah `ConsumerStatefulWidget` — cukup tambahkan `ref.watch` di `build()`.

- [x] Update `apps/variant/lib/app.dart` — pola sama dengan main, tapi `title` tetap `'Flutter Starter Variant'`:
  ```dart
  @override
  Widget build(BuildContext context) {
    final themeMode =
        ref.watch(themeNotifierProvider).asData?.value ?? ThemeMode.system;
    final locale = ref.watch(localeNotifierProvider).asData?.value;

    return MaterialApp.router(
      title: 'Flutter Starter Variant',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: appRouter,
    );
  }
  ```
- [x] `dart analyze packages/core packages/features_shared apps/main apps/variant` — no issues

**Selesai jika:** Ganti theme di Settings → `MaterialApp` langsung berubah tanpa restart.

---

## Phase 5 — Test & Verifikasi

- [x] ~~Update `apps/main/test/home_screen_test.dart`~~ — tidak perlu diubah. `HomeScreen` tidak watch provider apapun; `context.push` hanya dipanggil saat `onPressed`, bukan saat build. Test pass tanpa `ProviderScope`.
- [x] ~~Update `apps/variant/test/home_screen_test.dart`~~ — sama, tidak perlu diubah.
- [x] `flutter test apps/main/test apps/variant/test` — semua test pass
- [x] `dart analyze packages/core packages/features_shared apps/main apps/variant` — no issues
- [ ] Verifikasi end-to-end di device:
  - Buka Settings → pilih Dark → kembali ke home → tema berubah ✓
  - Buka Settings → pilih English → teks app berubah ke EN ✓
  - Kill app → buka ulang → preferensi tetap tersimpan ✓

**Selesai jika:** semua test pass, analyze clean, dan ketiga skenario verifikasi berhasil di device.
