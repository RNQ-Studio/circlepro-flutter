# flutter-starter

[![CI](https://github.com/ramadhanrosihadi/flutter-starter/actions/workflows/ci.yml/badge.svg)](https://github.com/ramadhanrosihadi/flutter-starter/actions/workflows/ci.yml)

Flutter starter project dengan **Monorepo**, **Clean Architecture**, **Multi-Flavor**, dan **Multi-Environment**. Repo ini disiapkan untuk di-fork sebagai fondasi project baru.

---

## Tech Stack

| Kategori | Library |
|---|---|
| Monorepo | [Melos](https://melos.invertase.dev/) |
| State Management | [Riverpod](https://riverpod.dev/) |
| Navigation | [GoRouter](https://pub.dev/packages/go_router) |
| HTTP Client | [Dio](https://pub.dev/packages/dio) |
| Local Storage | SharedPreferences + FlutterSecureStorage |
| Localization | Flutter gen-l10n |

Catatan: Firebase bersifat optional dan belum menjadi dependency aktif di kode starter. Jika project memakai Firebase, lihat `docs/STARTER_GUIDE.md`.

---

## Available Features

Starter ini sudah membawa fondasi berikut:

| Area | Status | Keterangan |
|------|--------|------------|
| Monorepo workspace | siap pakai | Dart workspace + Melos scripts |
| Multi app/flavor | siap pakai | `apps/main` dan `apps/variant` |
| Multi environment | siap pakai | `dev`, `staging`, `prod` via `--dart-define=ENV=...` |
| Auth | starter implementation | repository, usecase, provider, route, login screen; mock dev via `FakeAuthRepository` |
| Settings | siap pakai | theme mode (system/light/dark) dan locale preference persisten |
| Localization (L10n) | siap pakai | real-time language switching ID ↔ EN tanpa restart, ARB-based via `flutter gen-l10n`, preferensi tersimpan antar sesi |
| Profile | siap pakai | Clean Architecture lengkap — domain, data, presentation; membaca dari sesi auth, tampil di kedua app, tombol logout |
| Notifications | stub | struktur clean architecture dan empty state |
| Core foundation | siap pakai | theme, network, storage, responsive, route constants, widgets |
| Testing | siap pakai | 28 tests — unit (exceptions, settings repo, auth notifier) + widget (HomeScreen, SettingsScreen) |
| CI | siap pakai | format check, analyze, test via GitHub Actions |
| Android signing config | siap pakai | signing config structure via `key.properties` (key.properties.example disertakan) |

---

## Prerequisites

Pastikan tools berikut sudah terinstall:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) stable channel
- [Melos](https://melos.invertase.dev/getting-started)

Install Melos jika belum tersedia:

```bash
dart pub global activate melos
```

Jika command `melos` global belum dikenali, gunakan `dart run melos ...`.

---

## Getting Started

```bash
# 1. Clone repo
git clone https://github.com/ramadhanrosihadi/flutter-starter.git
cd flutter-starter

# 2. Install dependencies dari root
dart pub get

# 3. Cek workspace
dart run melos list

# 4. Jalankan app main
dart run melos run dev
```

---

## Menjalankan App

```bash
# apps/main
dart run melos run dev

# apps/variant
dart run melos run dev:variant
```

Manual run dari folder app:

```bash
cd apps/main
flutter run --dart-define=ENV=staging
flutter run --dart-define=ENV=prod
```

```bash
cd apps/variant
flutter run --dart-define=ENV=staging
flutter run --dart-define=ENV=prod
```

Build:

```bash
dart run melos run build:android
dart run melos run build:ios
dart run melos run build:web
```

---

## Common Commands

Jalankan dari root repo:

| Command | Fungsi |
|---------|--------|
| `dart pub get` | Install dependencies workspace |
| `dart run melos list` | Lihat package/app yang terdaftar |
| `dart run melos run dev` | Run `apps/main` dengan `ENV=dev` |
| `dart run melos run dev:variant` | Run `apps/variant` dengan `ENV=dev` |
| `dart run melos run format` | Format semua file Dart |
| `dart run melos run format:check` | Cek format tanpa menulis file |
| `dart run melos run analyze` | Analyze semua package dan app |
| `dart run melos run test` | Run semua test |
| `dart run melos run build:android` | Build APK semua app |
| `dart run melos run build:ios` | Build IPA semua app |
| `dart run melos run build:web` | Build web semua app |

App-specific scripts juga tersedia, misalnya `build:android:main`, `build:android:variant`, `test:core`, `test:main`, dan `test:variant`.

---

## Quality Checks

CI menjalankan check berikut pada push dan pull request ke `main` atau `develop`:

```bash
dart pub get
dart run melos list
dart run melos run format:check
dart run melos run analyze
dart run melos run test
```

Sebelum membuat PR, jalankan:

```bash
dart run melos run format:check
dart run melos run analyze
dart run melos run test
```

Workflow CI ada di `.github/workflows/ci.yml`.

### Test Coverage

| Package / App | Test File | Yang di-cover |
|---|---|---|
| `packages/core` | `test/errors/app_exception_test.dart` | `AppException.toString()` semua subclass |
| `packages/features_shared` | `test/settings/settings_repository_impl_test.dart` | `getThemeMode`, `saveThemeMode`, `getLocale`, `saveLocale` |
| `packages/features_shared` | `test/auth/auth_notifier_test.dart` | initial state, login success/failure, logout, checkCurrentUser |
| `apps/main` | `test/home_screen_test.dart` | render + navigasi ke settings |
| `apps/main` | `test/features/settings/settings_screen_test.dart` | section headers + pilihan theme |
| `apps/variant` | `test/home_screen_test.dart` | smoke test render |

Mock menggunakan `mocktail` — `StorageService` di-mock untuk settings test, `AuthRepository` di-mock untuk auth test. `ThemeNotifier` dan `LocaleNotifier` di-fake via subclass override `build()` agar widget test tidak butuh storage asli.

---

## Struktur Project

Monorepo dengan dua layer utama:

```text
packages/   # shared libraries: core, features_shared
apps/       # Flutter apps: main, variant
```

Lihat [ARCHITECTURE.md](ARCHITECTURE.md) untuk dokumentasi lengkap arsitektur dan aturan dependency.

---

## Dokumentasi

- Baru fork atau copy repo? Baca [Starter Guide](docs/STARTER_GUIDE.md).
- Ingin memahami struktur dan dependency rule? Baca [Architecture](ARCHITECTURE.md).
- Ingin menambah fitur baru? Baca [Add Feature Guide](docs/ADD_FEATURE.md).
- Ingin menambah app/flavor baru? Baca [Add App Flavor Guide](docs/ADD_APP_FLAVOR.md).
- Ingin kontribusi lewat branch/PR? Baca [Contributing Guide](CONTRIBUTING.md).

---

## Cara Pakai Starter Ini

Setelah fork, lakukan langkah berikut sebelum mulai development:

- [ ] Rename package name di `pubspec.yaml` yang relevan.
- [ ] Update `applicationId` Android dan bundle ID iOS masing-masing app.
- [ ] Ganti base URL di `MainConfig` dan `VariantConfig`.
- [ ] Tentukan apakah `variant` tetap dipakai, dihapus, atau direname.
- [ ] Tambahkan konfigurasi Firebase jika project memakai Firebase.
- [ ] Update nama app, icon, splash screen, web title, dan manifest.
- [ ] Setup Android signing: copy `android/key.properties.example` → `android/key.properties`, isi dengan keystore path dan password.
- [ ] Jalankan quality checks lokal sebelum PR.
