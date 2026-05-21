# Architecture

Project ini menggunakan arsitektur **Monorepo** dengan Melos, dikombinasikan dengan **Feature-First** dan prinsip **Clean Architecture**, dengan dukungan **Multi-Flavor**, **Multi-Environment**, dan **Responsive Layout** (mobile & web).

---

## Konsep Penting

| Konsep | Pertanyaan yang dijawab | Contoh |
|--------|------------------------|--------|
| **Monorepo** | *Di mana semua kode tinggal?* | satu repo, banyak package |
| **Flavor** | *App apa yang sedang dijalankan?* | main, variant |
| **Environment** | *Backend mana yang dipakai?* | dev, staging, prod |
| **Responsive Layout** | *Bagaimana UI ditampilkan?* | layout mobile, layout web |

---

## Struktur Monorepo

```
flutter-starter/
├── melos.yaml                           ← definisi workspace scripts (dev, build, test) untuk semua app
├── pubspec.yaml                         ← root workspace: mendaftarkan semua member package ke Dart pub
├── ARCHITECTURE.md                      ← dokumentasi arsitektur, keputusan desain, dan aturan struktural
│
├── sprints/                              ← rencana dan catatan eksekusi per sprint
│   └── 001_setup.md                    ← Sprint 001: setup monorepo dari root hingga kedua flavor app
│
├── packages/                            ← shared libraries, bukan Flutter app
│   │
│   ├── core/                            ← fondasi seluruh app, tidak boleh import package lain di repo ini
│   │   ├── lib/
│   │   │   ├── core.dart                ← barrel export: satu-satunya file yang diimport dari luar
│   │   │   └── src/                     ← implementasi internal, tidak diimport langsung dari luar
│   │   │       ├── config/              ← AppConfig (abstract class) + Environment (enum dev/staging/prod)
│   │   │       ├── constants/           ← nilai tetap global: ukuran, durasi, string key
│   │   │       ├── errors/              ← Exception (teknis, di data layer) & Failure (bisnis, di domain layer)
│   │   │       ├── extensions/          ← Dart extension methods global: context.theme, string.capitalize, dll
│   │   │       ├── l10n/                ← file terjemahan (.arb) + konfigurasi gen-l10n
│   │   │       ├── network/             ← Dio client: base URL, interceptor auth, error handler global
│   │   │       ├── responsive/          ← Breakpoints (konstanta ukuran layar) + ResponsiveLayout widget
│   │   │       ├── router/              ← AppRoutes (nama konstanta route) + NavigatorObserver (AuthGuard ada di features_shared/auth/presentation/)
│   │   │       ├── storage/             ← wrapper SharedPreferences/SecureStorage: token, user preference
│   │   │       ├── theme/               ← ThemeData light & dark, warna, tipografi, ukuran
│   │   │       ├── utils/               ← fungsi pembantu global: format tanggal, validasi, helper umum
│   │   │       └── widgets/             ← widget reusable lintas fitur: AppButton, AppTextField, LoadingOverlay
│   │   └── pubspec.yaml                 ← name: core | resolution: workspace | deps: flutter, dio, riverpod, dll
│   │
│   └── features_shared/                 ← fitur yang dipakai oleh semua flavor (auth, profile, notifications)
│       ├── lib/
│       │   ├── features_shared.dart     ← barrel export: satu-satunya file yang diimport dari luar
│       │   └── src/
│       │       ├── auth/                ← autentikasi: login, register, logout, manajemen session
│       │       │   ├── data/            ← datasource (API/local), model (JSON↔Dart), repository impl
│       │       │   ├── domain/          ← entity, repository interface, usecase (LoginUseCase, dll)
│       │       │   └── presentation/    ← Riverpod provider, screen, widget, GoRoute definitions
│       │       ├── profile/             ← profil pengguna: lihat & edit data akun
│       │       │   ├── data/            ← datasource (API/local), model (JSON↔Dart), repository impl
│       │       │   ├── domain/          ← entity, repository interface, usecase (GetProfileUseCase, dll)
│       │       │   └── presentation/    ← Riverpod provider, screen, widget, GoRoute definitions
│       │       └── notifications/       ← notifikasi: push notification & in-app notification
│       │           ├── data/            ← datasource (FCM/local), model, repository impl
│       │           ├── domain/          ← entity, repository interface, usecase (GetNotificationsUseCase, dll)
│       │           └── presentation/    ← Riverpod provider, screen, widget, GoRoute definitions
│       └── pubspec.yaml                 ← name: features_shared | resolution: workspace | deps: flutter, core
│
└── apps/                                ← Flutter apps, masing-masing bisa di-build secara independen
    │
    ├── main/                            ← flavor utama, produk primer
    │   ├── lib/
    │   │   ├── config/                  ← MainConfig: implementasi AppConfig, membaca ENV dari --dart-define
    │   │   ├── features/                ← fitur eksklusif flavor main
    │   │   │   └── [nama_fitur]/
    │   │   │       ├── data/            ← datasource (API/local), model (JSON↔Dart), repository impl
    │   │   │       ├── domain/          ← entity, repository interface, usecase
    │   │   │       └── presentation/    ← Riverpod provider, screen, widget, GoRoute definitions
    │   │   ├── router/
    │   │   │   └── app_router.dart      ← GoRouter final: gabungan shared routes + routes eksklusif main
    │   │   ├── app.dart                 ← widget root: ProviderScope, MaterialApp.router — menerapkan tema dan router
    │   │   ├── bootstrap.dart           ← async init: WidgetsFlutterBinding, Firebase, error handler, runApp
    │   │   └── main.dart                ← entry point: inject AppConfig.instance, panggil bootstrap()
    │   ├── android/
    │   ├── ios/
    │   ├── web/
    │   └── pubspec.yaml                 ← name: app_main | resolution: workspace | deps: core, features_shared
    │
    └── variant/                         ← flavor kedua, template untuk klien atau produk lain
        ├── lib/
        │   ├── config/                  ← VariantConfig: implementasi AppConfig, membaca ENV dari --dart-define
        │   ├── features/                ← fitur eksklusif flavor variant
        │   │   └── [nama_fitur]/
        │   │       ├── data/            ← datasource (API/local), model (JSON↔Dart), repository impl
        │   │       ├── domain/          ← entity, repository interface, usecase
        │   │       └── presentation/    ← Riverpod provider, screen, widget, GoRoute definitions
        │   ├── router/
        │   │   └── app_router.dart      ← GoRouter final: gabungan shared routes + routes eksklusif variant
        │   ├── app.dart                 ← widget root: ProviderScope, MaterialApp.router — menerapkan tema dan router
        │   ├── bootstrap.dart           ← async init: WidgetsFlutterBinding, Firebase, error handler, runApp
        │   └── main.dart                ← entry point: inject AppConfig.instance, panggil bootstrap()
        ├── android/
        ├── ios/
        ├── web/
        └── pubspec.yaml                 ← name: app_variant | resolution: workspace | deps: core, features_shared
```
