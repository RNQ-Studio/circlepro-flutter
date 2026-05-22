# Architecture

Project ini menggunakan arsitektur **Monorepo** dengan Melos, dikombinasikan dengan **Feature-First** dan prinsip **Clean Architecture**, dengan dukungan **Multi-Flavor**, **Multi-Environment**, dan **Responsive Layout** untuk mobile dan web.

Dokumen ini menjelaskan keputusan arsitektur dan aturan struktur. Untuk panduan operasional, lihat:

- [`docs/STARTER_GUIDE.md`](docs/STARTER_GUIDE.md) — setup pertama, checklist fork, rename identitas, environment, Firebase, CI
- [`docs/ADD_FEATURE.md`](docs/ADD_FEATURE.md) — cara menambah fitur baru step-by-step
- [`docs/ADD_APP_FLAVOR.md`](docs/ADD_APP_FLAVOR.md) — cara menambah app/flavor ketiga

---

## Konsep Penting

| Konsep | Pertanyaan yang dijawab | Contoh |
|--------|--------------------------|--------|
| **Monorepo** | Di mana semua kode tinggal? | satu repo, banyak package |
| **Flavor / App** | App apa yang sedang dijalankan? | main, variant |
| **Environment** | Backend mana yang dipakai? | dev, staging, prod |
| **Responsive Layout** | Bagaimana UI ditampilkan? | layout mobile, layout web |

---

## Struktur Monorepo

Konfigurasi workspace Dart dan Melos berada di root `pubspec.yaml`. Repo ini tidak memakai `melos.yaml` terpisah.

Struktur di bawah menampilkan file dan folder yang penting secara arsitektural. Folder platform seperti `android/`, `ios/`, dan `web/` tetap mengikuti struktur standar Flutter.

```text
flutter-starter/
|-- pubspec.yaml                         # root workspace + Melos scripts
|-- pubspec.lock                         # lockfile dependency workspace
|-- README.md                            # quickstart dan cara pakai starter
|-- ARCHITECTURE.md                      # dokumentasi arsitektur dan aturan struktur
|-- CONTRIBUTING.md                      # git workflow dan aturan kontribusi
|
|-- sprints/                             # rencana dan catatan eksekusi per sprint
|   |-- 001_setup.md                     # setup monorepo, core, shared features, dan app
|   |-- 002_feature_settings.md          # fitur settings lintas flavor
|   |-- 003_l10n.md                      # localization end-to-end
|   |-- 004_testing.md                   # unit & widget tests
|   |-- 005_ci_cd.md                     # CI/CD verification
|   |-- 006_profile_feature.md           # fitur profile (clean architecture)
|   |-- 007_release_prep.md              # release preparation
|   |-- 008_home_screen.md               # home screen apps/main
|   `-- 009_ui_gallery.md                # UI component gallery
|
|-- packages/                            # shared libraries, bukan Flutter app
|   |
|   |-- core/                            # fondasi seluruh app
|   |   |-- lib/
|   |   |   |-- core.dart                # barrel export public API
|   |   |   `-- src/                     # implementasi internal
|   |   |       |-- config/              # AppConfig + Environment
|   |   |       |-- constants/           # nilai tetap global
|   |   |       |-- errors/              # AppException dan Failure
|   |   |       |-- extensions/          # extension methods global
|   |   |       |-- l10n/                # ARB dan generated localizations
|   |   |       |-- network/             # Dio client, auth interceptor, error handler
|   |   |       |-- responsive/          # breakpoints dan ResponsiveLayout
|   |   |       |-- router/              # AppRoutes dan AppNavigatorObserver
|   |   |       |-- storage/             # SharedPreferences dan secure storage wrapper
|   |   |       |-- theme/               # ThemeData, warna, dan text style
|   |   |       |-- utils/               # helper umum
|   |   |       `-- widgets/             # widget reusable lintas fitur
|   |   |-- l10n.yaml                    # konfigurasi gen-l10n
|   |   `-- pubspec.yaml                 # package core
|   |
|   `-- features_shared/                 # fitur yang dipakai oleh semua app/flavor
|       |-- lib/
|       |   |-- features_shared.dart      # barrel export public API
|       |   `-- src/
|       |       |-- auth/                 # login, register, logout, session
|       |       |   |-- data/             # datasource, model, repository impl
|       |       |   |-- domain/           # entity, repository interface, usecase
|       |       |   `-- presentation/     # provider, screen, guard, shared routes
|       |       |-- profile/              # profil pengguna (stub — diimplementasi Sprint 006)
|       |       |   |-- data/
|       |       |   |-- domain/
|       |       |   `-- presentation/
|       |       |-- notifications/        # notifikasi (stub — diimplementasi Sprint 006)
|       |       |   |-- data/
|       |       |   |-- domain/
|       |       |   `-- presentation/
|       |       `-- settings/             # shared logic untuk theme dan locale preference
|       `-- pubspec.yaml                  # package features_shared
|
`-- apps/                                 # Flutter apps, masing-masing bisa di-build terpisah
    |
    |-- main/                             # app utama / produk primer
    |   |-- lib/
    |   |   |-- config/                   # MainConfig membaca ENV dari --dart-define
    |   |   |-- dev/                      # Riverpod overrides khusus debug (FakeAuthRepository, dll) — tidak masuk production build
    |   |   |-- features/                 # fitur eksklusif app main
    |   |   |   |-- home/                 # home screen (data/domain/presentation)
    |   |   |   |-- settings/             # UI settings khusus main
    |   |   |   `-- ui_gallery/           # UI component gallery (referensi dev — hapus sebelum prod)
    |   |   |       |-- data/             # dummy_data.dart
    |   |   |       |-- widgets/          # section_header, demo_card, gallery_menu_card
    |   |   |       `-- screens/          # ui_gallery_home_screen + 8 layar demo
    |   |   |-- router/
    |   |   |   `-- app_router.dart       # GoRouter final untuk app main
    |   |   |-- app.dart                  # ProviderScope + MaterialApp.router
    |   |   |-- bootstrap.dart            # init Flutter, error handler, storage, runApp
    |   |   `-- main.dart                 # inject MainConfig lalu bootstrap
    |   |-- android/
    |   |-- ios/
    |   |-- web/
    |   `-- pubspec.yaml                  # package app_main
    |
    `-- variant/                          # app kedua / template klien atau produk lain
        |-- lib/
        |   |-- config/                   # VariantConfig membaca ENV dari --dart-define
        |   |-- features/                 # fitur eksklusif app variant
        |   |   |-- home/                 # home screen (data/domain/presentation)
        |   |   `-- settings/             # UI settings khusus variant
        |   |-- router/
        |   |   `-- app_router.dart       # GoRouter final untuk app variant
        |   |-- app.dart                  # ProviderScope + MaterialApp.router
        |   |-- bootstrap.dart            # init Flutter, error handler, storage, runApp
        |   `-- main.dart                 # inject VariantConfig lalu bootstrap
        |-- android/
        |-- ios/
        |-- web/
        `-- pubspec.yaml                  # package app_variant
```

---

## Aturan Dependency

Dependency antar package dibuat satu arah agar fondasi tetap mudah dipahami dan tidak saling mengunci.

```text
apps/main, apps/variant
        |
        | import
        v
features_shared
        |
        | import
        v
core
```

Aturan utamanya:

- `core` tidak boleh import package internal lain di repo ini.
- `features_shared` boleh import `core`, tetapi tidak boleh import dari `apps/main` atau `apps/variant`.
- `apps/*` boleh import `core` dan `features_shared`.
- Kode dari luar package sebaiknya import barrel file: `package:core/core.dart` atau `package:features_shared/features_shared.dart`.
- File di dalam `src/` adalah implementasi internal package. Package lain tidak mengimport file `src/` secara langsung; gunakan barrel export package.
- Import relatif ke file `src/` masih boleh dipakai dari dalam package yang sama.
- Shared package tidak boleh bergantung pada detail UI app tertentu. Variasi tampilan antar app tetap diletakkan di `apps/<app_name>/lib/features/`.

Contoh import yang disarankan dari app:

```dart
import 'package:core/core.dart';
import 'package:features_shared/features_shared.dart';
```

---

## Flavor dan Environment

Repo ini memisahkan **app/flavor** dan **environment**.

App/flavor menjawab produk mana yang dijalankan:

- `apps/main`
- `apps/variant`

Environment menjawab backend mana yang dipakai:

- `dev`
- `staging`
- `prod`

Environment dibaca dari `--dart-define=ENV=...` melalui `MainConfig` dan `VariantConfig`.

```bash
melos run dev
melos run dev:variant

cd apps/main
flutter run --dart-define=ENV=staging

cd ../variant
flutter run --dart-define=ENV=prod
```

---

## Clean Architecture Per Feature

Untuk fitur bisnis yang cukup besar, struktur fitur mengikuti tiga lapisan:

```text
feature/
|-- data/          # datasource, DTO/model, repository implementation
|-- domain/        # entity, repository interface, usecase
`-- presentation/  # screen, widget, provider, route
```

Fitur yang dipakai semua app ditempatkan di `packages/features_shared/lib/src/`. Fitur yang hanya berlaku untuk satu app ditempatkan di `apps/<app_name>/lib/features/`.

Aturan saat ini:

- Setiap folder fitur di `apps/<app_name>/lib/features/` wajib memiliki folder `data/`, `domain/`, dan `presentation/`.
- Jika sebuah fitur saat ini hanya memiliki UI atau route, folder layer yang belum dipakai tetap dibuat dengan placeholder `.gitkeep`.
- Auth, profile, notifications, home, dan settings mengikuti struktur `data/domain/presentation`.

Prinsipnya: dependency tetap satu arah dari presentation ke domain ke data. Untuk logic kecil seperti settings preference, layer yang belum memiliki implementasi boleh kosong terlebih dahulu selama struktur fitur tetap konsisten.

---

## Routing

Route global didefinisikan sebagai konstanta di `core` melalui `AppRoutes`. Route final dirakit di masing-masing app melalui `app_router.dart`.

Auth route dan redirect logic berasal dari `features_shared`, lalu digabung dengan route eksklusif app. Route yang UI-nya berbeda antar app, seperti settings, didefinisikan di masing-masing app.

```dart
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

---

## State dan Storage

State management menggunakan Riverpod. Shared provider diletakkan bersama fitur yang memilikinya, sedangkan override dependency app dilakukan di `App` melalui `ProviderScope`.

Storage dibagi berdasarkan jenis data:

- `SecureStorageService` dipakai untuk data sensitif seperti token auth.
- `SharedPreferencesStorage` dipakai untuk preference non-sensitif seperti theme dan locale.

`storageServiceProvider` dari auth wajib dioverride oleh app, karena package `features_shared` tidak boleh menentukan sendiri storage sensitif yang dipakai app.

Di `apps/main`, debug mode mengoverride `authRepositoryProvider` dengan `FakeAuthRepository` agar development bisa berjalan tanpa backend. Project production perlu mengganti atau menghapus override ini sesuai kebutuhan.

---

## Bootstrap App

Setiap app punya entry point sendiri:

```text
main.dart -> AppConfig.instance = ... -> bootstrap() -> runApp(App(...))
```

`bootstrap.dart` bertanggung jawab untuk:

- memastikan Flutter binding siap,
- memasang error handler dasar,
- menginisialisasi storage,
- menjalankan root widget app.

Jika project baru membutuhkan Firebase atau service eksternal lain, inisialisasi tersebut sebaiknya ditambahkan di `bootstrap.dart` masing-masing app atau diekstrak ke helper yang eksplisit.

Saat ini Firebase belum diinisialisasi di kode starter. Jika Firebase dipakai, dokumentasi setup dan file konfigurasi platform perlu ditambahkan bersama perubahan bootstrap.

---

## Testing

Test disimpan di dalam package atau app pemilik fitur:

```text
packages/core/test/
packages/features_shared/test/
apps/main/test/
apps/variant/test/
```

Prioritas test per tipe logic:

| Tipe | Yang ditest |
|------|-------------|
| Entity / model | parsing, equality, required field |
| Repository | success path, error mapping, empty result |
| Notifier / provider | loading → data → error state transitions |
| Usecase | memanggil repository yang benar dengan parameter yang benar |
| Screen | smoke test render, state utama (loading, data, error) |
| Route guard | redirect saat authenticated dan unauthenticated |

Jalankan semua test dari root:

```bash
dart run melos run test
```

Atau per app/package:

```bash
flutter test apps/main/test
flutter test packages/features_shared/test
```

---

## CI/CD

Pipeline GitHub Actions ada di `.github/workflows/ci.yml`. CI berjalan otomatis pada push dan pull request ke branch `main` dan `develop`.

Langkah yang dijalankan CI secara berurutan:

```bash
dart pub get
dart run melos list
dart run melos run format:check
dart run melos run analyze
dart run melos run test
```

Jika CI gagal lokal, jalankan urutan yang sama dari root repo. Format failure diselesaikan dengan `dart run melos run format` lalu commit hasilnya.

Script Melos yang dipanggil CI harus selalu terdefinisi di `pubspec.yaml` root di bawah `melos.scripts`.
