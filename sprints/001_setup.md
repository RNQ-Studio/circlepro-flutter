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

- [ ] Buat struktur direktori awal:
  ```bash
  mkdir -p apps packages/core packages/features_shared
  ```
- [ ] Buat `.gitignore` — exclude `.dart_tool/`, `build/`, `.flutter-plugins`, `.flutter-plugins-dependencies`
- [ ] Buat root `pubspec.yaml` — Dart workspace config (hanya daftarkan packages dulu, apps ditambahkan di Phase 4 & 5):
  ```yaml
  name: flutter_starter_workspace
  publish_to: none
  environment:
    sdk: ">=3.5.0 <4.0.0"
  workspace:
    - packages/core
    - packages/features_shared
  ```
- [ ] Buat `melos.yaml` — workspace scripts:
  ```yaml
  name: flutter_starter
  packages:
    - apps/**
    - packages/**
  scripts:
    dev:
      run: cd apps/main && flutter run --dart-define=ENV=dev
    dev:variant:
      run: cd apps/variant && flutter run --dart-define=ENV=dev
    build:android:
      run: cd apps/main && flutter build apk --dart-define=ENV=prod
    build:ios:
      run: cd apps/main && flutter build ipa --dart-define=ENV=prod
    test:
      exec: flutter test
      concurrency: 4
  ```
- [ ] Smoke test — verifikasi file terbuat: `ls pubspec.yaml melos.yaml .gitignore` tidak error

**Selesai jika:** ketiga file root terbuat tanpa error.

---

## Phase 2 — `packages/core/`

- [ ] Buat package:
  ```bash
  flutter create --template=package packages/core
  ```
- [ ] Update `packages/core/pubspec.yaml`:
  - `name: core`, `resolution: workspace`
  - deps: `flutter_riverpod: ^3.3.1`, `dio: ^5.9.2`, `go_router: ^17.2.3`, `shared_preferences: ^2.5.5`, `flutter_secure_storage: ^10.2.0`
- [ ] Hapus `lib/core.dart` default, buat ulang sebagai barrel export
- [ ] `src/config/` — `AppConfig` abstract class:
  - field abstract: `String baseUrl`, `Environment environment`
  - static: `static late AppConfig instance`
  - `Environment` enum: `dev`, `staging`, `prod` + factory `Environment.fromString(String value)`
- [ ] `src/errors/` — `AppException` classes (data layer) + `Failure` classes (domain layer)
- [ ] `src/constants/` — global constants (ukuran, durasi, string key)
- [ ] `src/storage/` — abstract `StorageService` + implementasi `SharedPreferencesStorage` & `SecureStorageService`
- [ ] `src/network/` — Dio client: `baseUrl` dari `AppConfig.instance`, interceptor auth (attach token dari `StorageService`), error handler global
- [ ] `src/theme/` — `ThemeData` light & dark, warna, tipografi, ukuran
- [ ] `src/responsive/` — `Breakpoints` constants + `ResponsiveLayout` widget
- [ ] `src/extensions/` — Dart extension methods: `context.theme`, `String.capitalize`, dll
- [ ] `src/utils/` — helper functions: format tanggal, validasi input, helper umum
- [ ] `src/widgets/` — `AppButton`, `AppTextField`, `LoadingOverlay`
- [ ] `src/router/` — `AppRoutes` constants + `AppNavigatorObserver` (AuthGuard tidak di sini — ada di Phase 3)
- [ ] `src/l10n/` — `.arb` files (`app_id.arb`, `app_en.arb`) + konfigurasi `flutter gen-l10n` di `pubspec.yaml`, output ke `lib/src/l10n/`
- [ ] Export semua public API ke `lib/core.dart`

**Selesai jika:** semua file `src/` terbuat dan `lib/core.dart` barrel export lengkap (analisis dijalankan di akhir Phase 3).

---

## Phase 3 — `packages/features_shared/`

- [ ] Buat package:
  ```bash
  flutter create --template=package packages/features_shared
  ```
- [ ] Update `packages/features_shared/pubspec.yaml`:
  - `name: features_shared`, `resolution: workspace`
  - deps: `core`, `flutter_riverpod: ^3.3.1`, `go_router: ^17.2.3`
- [ ] Hapus `lib/features_shared.dart` default, buat ulang sebagai barrel export

### Auth — full implementation
- [ ] `src/auth/domain/` — entity `User`, interface `AuthRepository`, usecases: `LoginUseCase`, `LogoutUseCase`, `RegisterUseCase`
- [ ] `src/auth/data/` — `UserModel` (JSON↔Dart), datasource (remote + local), `AuthRepositoryImpl`
- [ ] `src/auth/presentation/` — Riverpod provider, login screen, `AuthGuard` (cek auth state via provider, redirect ke login jika belum login), GoRoute definitions

### Profile — stub
- [ ] `src/profile/domain/` — entity `Profile`, interface `ProfileRepository`, usecase stubs: `GetProfileUseCase`, `UpdateProfileUseCase`
- [ ] `src/profile/data/` — stub `ProfileRepositoryImpl` (return hardcoded data, bisa compile)
- [ ] `src/profile/presentation/` — `ProfileScreen` (Scaffold kosong), stub Riverpod provider

### Notifications — stub
- [ ] `src/notifications/domain/` — entity `AppNotification`, interface `NotificationsRepository`, usecase stub: `GetNotificationsUseCase`
- [ ] `src/notifications/data/` — stub `NotificationsRepositoryImpl` (return empty list, bisa compile)
- [ ] `src/notifications/presentation/` — `NotificationsScreen` (Scaffold kosong), stub Riverpod provider

- [ ] Export semua public API ke `lib/features_shared.dart`
- [ ] Jalankan `dart pub get` dari root — resolve semua dependency untuk packages/core dan packages/features_shared:
  ```bash
  dart pub get
  ```
- [ ] Verifikasi packages: `dart analyze packages/core packages/features_shared` tidak menghasilkan warning atau error
- [ ] Verifikasi melos: `melos list` menampilkan 2 package (core, features_shared)

**Selesai jika:** `dart analyze` dan `melos list` berjalan tanpa error.

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
