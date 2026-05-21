# Sprint 001 — Project Setup

Tujuan: membangun fondasi flutter-starter sesuai ARCHITECTURE.md — dari monorepo root hingga kedua flavor app siap dijalankan.

Acceptance criteria sprint: kedua app (`apps/main` dan `apps/variant`) bisa di-run di emulator/device tanpa error.

> **Catatan versi dependency:**
> Selalu gunakan versi **terbaru** untuk semua dependency, Flutter SDK, dan Dart SDK.
> Sebelum eksekusi, verifikasi versi terbaru di [pub.dev](https://pub.dev) — jangan hardcode versi lama.
> Versi di dokumen ini adalah versi terbaru pada saat sprint ditulis **(2026-05-21)** dan wajib diperbarui jika sudah ada versi lebih baru saat eksekusi.
>
> | Package | Versi saat dokumen ditulis |
> |---|---|
> | `flutter_riverpod` | `^3.3.1` |
> | `dio` | `^5.9.2` |
> | `go_router` | `^17.2.3` |
> | `shared_preferences` | `^2.5.5` |
> | `flutter_secure_storage` | `^10.2.0` |

---

## Phase 1 — Monorepo Root

- [x] Buat struktur direktori awal:
  ```bash
  mkdir -p apps packages/core packages/features_shared
  ```
- [x] Buat `.gitignore` — exclude `.dart_tool/`, `build/`, `.flutter-plugins`, `.flutter-plugins-dependencies`
- [x] Buat root `pubspec.yaml` — Dart workspace config + melos scripts (melos 7.x: tidak ada `melos.yaml` terpisah, semua config ada di sini):
  ```yaml
  name: flutter_starter_workspace
  publish_to: none
  environment:
    sdk: ">=3.5.0 <4.0.0"
  dev_dependencies:
    melos: ^7.7.0
  workspace:
    - packages/core
    - packages/features_shared
  melos:
    packages:
      - apps/**
      - packages/**
    scripts:
      dev:
        run: cd apps/main && flutter run --dart-define=ENV=dev
      "dev:variant":
        run: cd apps/variant && flutter run --dart-define=ENV=dev
      build:android:
        run: cd apps/main && flutter build apk --dart-define=ENV=prod
      build:ios:
        run: cd apps/main && flutter build ipa --dart-define=ENV=prod
      test:
        exec: flutter test
        concurrency: 4
  ```
  > **Catatan melos 7.x:** Tidak perlu membuat `melos.yaml` terpisah — melos 7.0.0 menghapus `melos.yaml` sepenuhnya. Workspace root dideteksi dari `devDependencies` yang mengandung `melos`.
- [x] Smoke test — verifikasi file terbuat: `ls pubspec.yaml .gitignore` tidak error

**Selesai jika:** kedua file root terbuat tanpa error.

---

## Phase 2 — `packages/core/`

- [x] Buat package:
  ```bash
  flutter create --no-pub --template=package packages/core
  ```
  > `--no-pub` mencegah `flutter create` menjalankan `pub get` otomatis — workspace belum valid sampai semua member punya `pubspec.yaml`. `pub get` dijalankan di akhir Phase 2.
- [x] Update `packages/core/pubspec.yaml`:
  - `name: core`, `resolution: workspace`
  - deps: `flutter_riverpod: ^3.3.1`, `dio: ^5.9.2`, `go_router: ^17.2.3`, `shared_preferences: ^2.5.5`, `flutter_secure_storage: ^10.2.0`, `intl: any`
  - flutter SDK deps: `flutter_localizations` (dari `sdk: flutter`)
  > `intl: any` — biarkan pub resolver memilih versi yang kompatibel dengan `flutter_localizations` dari Flutter SDK. Jangan hardcode versi.
- [x] Hapus `lib/core.dart` default, buat ulang sebagai barrel export
- [x] Ganti `test/core_test.dart` boilerplate — hapus referensi `Calculator`, ganti dengan test yang valid (misal: `Environment.fromString`)
- [x] `src/config/` — `AppConfig` abstract class:
  - field abstract: `String baseUrl`, `Environment environment`
  - static: `static late AppConfig instance`
  - `Environment` enum: `dev`, `staging`, `prod` + factory `Environment.fromString(String value)`
- [x] `src/errors/` — `AppException` classes (data layer) + `Failure` classes (domain layer)
- [x] `src/constants/` — global constants (ukuran, durasi, string key)
- [x] `src/storage/` — abstract `StorageService` + implementasi `SharedPreferencesStorage` & `SecureStorageService`
- [x] `src/network/` — Dio client: `baseUrl` dari `AppConfig.instance`, interceptor auth (attach token dari `StorageService`), error handler global
- [x] `src/theme/` — `ThemeData` light & dark, warna, tipografi, ukuran
- [x] `src/responsive/` — `Breakpoints` constants + `ResponsiveLayout` widget
- [x] `src/extensions/` — Dart extension methods: `context.theme`, `String.capitalize`, dll
- [x] `src/utils/` — helper functions: format tanggal, validasi input, helper umum
- [x] `src/widgets/` — `AppButton`, `AppTextField`, `LoadingOverlay`
- [x] `src/router/` — `AppRoutes` constants + `AppNavigatorObserver` (AuthGuard tidak di sini — ada di Phase 3)
- [x] `src/l10n/` — buat `.arb` files:
  - `lib/src/l10n/app_id.arb` (Indonesian, template)
  - `lib/src/l10n/app_en.arb` (English)
- [x] Buat `packages/core/l10n.yaml`:
  ```yaml
  arb-dir: lib/src/l10n
  template-arb-file: app_id.arb
  output-localization-file: app_localizations.dart
  output-dir: lib/src/l10n
  ```
  > `synthetic-package` tidak perlu dicantumkan — opsi ini deprecated di Flutter terbaru dan output sudah otomatis ke `output-dir` sebagai file nyata.
- [x] Jalankan dari `packages/core/`:
  ```bash
  cd packages/core && flutter gen-l10n
  ```
- [x] Export semua public API ke `lib/core.dart`
- [x] Buat stub `packages/features_shared/pubspec.yaml` — minimal agar workspace valid untuk `dart pub get`:
  ```yaml
  name: features_shared
  description: "Features shared package."
  version: 0.0.1
  publish_to: none
  environment:
    sdk: ">=3.5.0 <4.0.0"
  resolution: workspace
  dependencies:
    flutter:
      sdk: flutter
  ```
  > Stub ini akan ditimpa oleh `flutter create` di Phase 3. Tujuannya hanya agar `dart pub get` bisa jalan sekarang.
- [x] Jalankan `dart pub get` dari root — resolve dependency `packages/core`:
  ```bash
  dart pub get
  ```
- [x] Smoke test — jalankan test dari `packages/core/`:
  ```bash
  cd packages/core && flutter test
  ```

**Selesai jika:** semua file `src/` terbuat, `lib/core.dart` barrel export lengkap, `dart pub get` sukses, dan `flutter test` pass.

---

## Phase 3 — `packages/features_shared/`

- [x] Buat package:
  ```bash
  flutter create --no-pub --template=package packages/features_shared
  ```
  > `flutter create` akan menimpa stub `pubspec.yaml` dari Phase 2 — ini yang diinginkan. `--no-pub` tetap dipakai karena deps belum lengkap.
- [x] Update `packages/features_shared/pubspec.yaml`:
  - `name: features_shared`, `resolution: workspace`
  - deps: `core` (tanpa versi/path — workspace resolver yang handle), `dio: ^5.9.2`, `flutter_riverpod: ^3.3.1`, `go_router: ^17.2.3`
  ```yaml
  dependencies:
    flutter:
      sdk: flutter
    core:
    dio: ^5.9.2
    flutter_riverpod: ^3.3.1
    go_router: ^17.2.3
  ```
  > `core:` tanpa versi atau `path:` — ini adalah cara benar untuk mereferensikan sibling workspace package di Dart workspace.
  > `dio:` diperlukan sebagai direct dep karena `AuthRemoteDataSource` mengimport `package:dio/dio.dart` langsung.
- [x] Hapus `lib/features_shared.dart` default, buat ulang sebagai barrel export
- [x] Ganti `test/features_shared_test.dart` boilerplate — hapus referensi `Calculator`, ganti dengan test minimal yang valid

### Auth — full implementation
- [x] `src/auth/domain/` — entity `User`, interface `AuthRepository`, usecases: `LoginUseCase`, `LogoutUseCase`, `RegisterUseCase`
- [x] `src/auth/data/` — `UserModel` (JSON↔Dart), datasource (remote + local), `AuthRepositoryImpl`
- [x] `src/auth/presentation/` — Riverpod provider, login screen, `AuthGuard` (cek auth state via provider, redirect ke login jika belum login), GoRoute definitions

### Profile — stub
- [x] `src/profile/domain/` — entity `Profile`, interface `ProfileRepository`, usecase stubs: `GetProfileUseCase`, `UpdateProfileUseCase`
- [x] `src/profile/data/` — stub `ProfileRepositoryImpl` (return hardcoded data, bisa compile)
- [x] `src/profile/presentation/` — `ProfileScreen` (Scaffold kosong), stub Riverpod provider

### Notifications — stub
- [x] `src/notifications/domain/` — entity `AppNotification`, interface `NotificationsRepository`, usecase stub: `GetNotificationsUseCase`
- [x] `src/notifications/data/` — stub `NotificationsRepositoryImpl` (return empty list, bisa compile)
- [x] `src/notifications/presentation/` — `NotificationsScreen` (Scaffold kosong), stub Riverpod provider

- [x] Export semua public API ke `lib/features_shared.dart`
- [x] Jalankan `dart pub get` dari root — re-resolve dengan dependency `features_shared` yang sudah lengkap:
  ```bash
  dart pub get
  ```
- [x] Smoke test — jalankan test dari `packages/features_shared/`:
  ```bash
  cd packages/features_shared && flutter test
  ```
- [x] Verifikasi packages: `dart analyze packages/core packages/features_shared` tidak menghasilkan warning atau error
- [x] Verifikasi melos: `melos list` menampilkan 2 package (core, features_shared)

**Selesai jika:** `flutter test` pass, `dart analyze` clean, dan `melos list` tampilkan 2 package.

---

## Phase 4 — `apps/main/`

- [ ] Buat Flutter project:
  ```bash
  flutter create --org id.rmq --platforms android,ios,web --project-name app_main apps/main
  ```
- [ ] Hapus boilerplate: `lib/main.dart` dan `test/widget_test.dart`
- [ ] Update `apps/main/pubspec.yaml`:
  - `name: app_main`, `resolution: workspace`
  - deps: `core`, `features_shared`
- [ ] Tambahkan `apps/main` ke workspace di root `pubspec.yaml`:
  ```yaml
  workspace:
    - packages/core
    - packages/features_shared
    - apps/main
  ```
- [ ] Jalankan `dart pub get` dari root — resolve workspace termasuk apps/main:
  ```bash
  dart pub get
  ```
- [ ] Konfigurasi platform:
  - Android (`android/app/build.gradle.kts`):
    - `applicationId = "id.rmq.main"`
    - `minSdk = 24` (default Flutter 3.41.6, sudah memenuhi syarat `flutter_secure_storage`)
    - `targetSdk = 36` (default Flutter 3.41.6, sesuai Google Play requirement)
    - `compileSdk = 36` (default Flutter 3.41.6)
  - iOS: `PRODUCT_BUNDLE_IDENTIFIER = id.rmq.main` di `ios/Runner/Info.plist`
  - Web: update `<title>` di `web/index.html`
- [ ] `lib/config/main_config.dart` — `MainConfig extends AppConfig`:
  ```dart
  class MainConfig extends AppConfig {
    @override
    final Environment environment = Environment.fromString(
      const String.fromEnvironment('ENV', defaultValue: 'dev'),
    );
    @override
    String get baseUrl => switch (environment) {
      Environment.prod => 'https://api.example.com',
      _ => 'https://api-dev.example.com',
    };
  }
  ```
- [ ] `lib/bootstrap.dart` — async init:
  ```dart
  Future<void> bootstrap(Widget app) async {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (details) { /* log error */ };
    runApp(app);
  }
  ```
- [ ] `lib/app.dart` — `ProviderScope` + `MaterialApp.router` dengan tema dari `core` dan router dari `app_router.dart`
- [ ] `lib/router/app_router.dart` — `GoRouter` instance: shared routes dari `features_shared` (termasuk `AuthGuard`) + home route eksklusif main
- [ ] `lib/main.dart`:
  ```dart
  void main() async {
    AppConfig.instance = MainConfig();
    await bootstrap(const App());
  }
  ```
- [ ] Verifikasi: jalankan `flutter run --dart-define=ENV=dev` dari `apps/main`

**Selesai jika:** `apps/main` tampil di emulator/device dengan home screen tanpa error.

---

## Phase 5 — `apps/variant/`

- [ ] Buat Flutter project:
  ```bash
  flutter create --org id.rmq --platforms android,ios,web --project-name app_variant apps/variant
  ```
- [ ] Hapus boilerplate: `lib/main.dart` dan `test/widget_test.dart`
- [ ] Update `apps/variant/pubspec.yaml`:
  - `name: app_variant`, `resolution: workspace`
  - deps: `core`, `features_shared`
- [ ] Tambahkan `apps/variant` ke workspace di root `pubspec.yaml` (workspace sekarang lengkap):
  ```yaml
  workspace:
    - packages/core
    - packages/features_shared
    - apps/main
    - apps/variant
  ```
- [ ] Jalankan `melos bootstrap` dari root — semua 4 package sudah siap, resolve penuh workspace:
  ```bash
  melos bootstrap
  ```
- [ ] Konfigurasi platform:
  - Android (`android/app/build.gradle.kts`):
    - `applicationId = "id.rmq.variant"`
    - `minSdk = 24` (default Flutter 3.41.6, sudah memenuhi syarat `flutter_secure_storage`)
    - `targetSdk = 36` (default Flutter 3.41.6, sesuai Google Play requirement)
    - `compileSdk = 36` (default Flutter 3.41.6)
  - iOS: `PRODUCT_BUNDLE_IDENTIFIER = id.rmq.variant` di `ios/Runner/Info.plist`
  - Web: update `<title>` di `web/index.html`
- [ ] `lib/config/variant_config.dart` — `VariantConfig extends AppConfig` (sama polanya dengan `MainConfig`)
- [ ] `lib/bootstrap.dart` — async init (sama dengan apps/main)
- [ ] `lib/app.dart` — `ProviderScope` + `MaterialApp.router` dengan tema dari `core` dan router dari `app_router.dart`
- [ ] `lib/router/app_router.dart` — `GoRouter` instance: shared routes dari `features_shared` (termasuk `AuthGuard`) + home route eksklusif variant
- [ ] `lib/main.dart`:
  ```dart
  void main() async {
    AppConfig.instance = VariantConfig();
    await bootstrap(const App());
  }
  ```
- [ ] Verifikasi: jalankan `flutter run --dart-define=ENV=dev` dari `apps/variant`

**Selesai jika:** `apps/variant` tampil di emulator/device dengan home screen tanpa error.
