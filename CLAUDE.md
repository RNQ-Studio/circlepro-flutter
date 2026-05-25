# 🤖 Panduan AI Agent — Flutter Starter Workspace

> Dokumen ini dirancang agar AI Agent (Claude, Gemini, GPT, dll.)
> dapat langsung bekerja di proyek ini tanpa hambatan.

---

## 📦 Struktur Monorepo

Proyek ini menggunakan **Melos** sebagai workspace manager monorepo:

```
flutter-starter/
├── packages/
│   ├── core/               ← Fondasi (tema, network, storage, l10n, widgets)
│   └── features_shared/    ← Fitur bersama (auth, profile, settings, notifications, onboarding)
└── apps/
    ├── main/               ← Aplikasi utama (flavor main)
    └── variant/            ← Aplikasi variant (flavor white-label)
```

### Aturan Dependency (WAJIB DIPATUHI)
- `core` → Tidak boleh import `features_shared` maupun `apps/*`
- `features_shared` → Boleh import `core`, TIDAK boleh import `apps/*`
- `apps/*` → Boleh import `core` dan `features_shared`
- ⚠️ DILARANG import silang antar `apps` (misal `apps/main` import `apps/variant`)

### Aturan Import
- Di dalam package (folder `src/`): Gunakan **relative imports**
- Dari luar package: Gunakan **barrel import** (`package:core/core.dart` atau `package:features_shared/features_shared.dart`)

---

## 🛠️ Perintah CLI Penting (Melos)

```bash
# Setup awal
dart pub get
dart run melos bootstrap
# ↑ postbootstrap otomatis menjalankan `melos run l10n` dan `melos run codegen`

# Generate file localization (L10n) manual
dart run melos run l10n

# Generate file code (Riverpod, Drift, dll.)
dart run melos run codegen
# Atau per-package:
cd packages/features_shared && dart run build_runner build

# Analisis statis seluruh workspace
dart run melos run analyze

# Format kode
dart run melos run format

# Cek format tanpa mengubah file
dart run melos run format:check

# Jalankan semua test
dart run melos run test

# Jalankan app main (dev environment)
dart run melos run dev

# Jalankan app variant (dev environment)
dart run melos run dev:variant

# Build APK release
dart run melos run build:android
```

---

## 🏗️ Arsitektur Fitur (Clean Architecture)

Setiap fitur mengikuti struktur 3-layer:

```
feature_name/
├── data/
│   ├── datasources/    ← Remote & Local data source
│   ├── models/         ← DTO / JSON models
│   └── repositories/   ← Implementasi repository
├── domain/
│   ├── entities/       ← Entity bisnis (pure Dart)
│   ├── repositories/   ← Interface/kontrak repository (abstract class)
│   └── usecases/       ← Business logic use cases
└── presentation/
    ├── screens/        ← Widget layar utama
    ├── widgets/        ← Widget komponen fitur
    └── *_notifier.dart ← Riverpod Notifier/AsyncNotifier
```

---

## 📋 Konvensi Penulisan Kode

### State Management (Riverpod Generator)
- Gunakan anotasi `@riverpod` dari `riverpod_annotation`
- Notifier harus meng-extend `_$NamaNotifier` (generated)
- Provider yang harus persisten: gunakan `@Riverpod(keepAlive: true)`
- Akses di `build()`: gunakan `ref.watch()`
- Akses di method aksi: gunakan `ref.read()`
- ⚠️ JANGAN menulis provider secara manual (vanilla) — gunakan generator

### Penamaan File & Class
- File: `snake_case.dart`
- Class: `PascalCase`
- Provider variable: `camelCaseProvider` (di-generate otomatis oleh @riverpod)
- Suffix penamaan: `*Screen`, `*Widget`, `*Notifier`, `*Repository`, `*UseCase`, `*DataSource`, `*Model`, `*Entity`

### Navigasi
- Gunakan `GoRouter` — rute dideklarasikan di `app_router.dart` masing-masing app
- Konstanta path rute didefinisikan di `AppRoutes` di `core`
- Gunakan `context.go()` untuk navigasi replace, `context.push()` untuk stack

### Error Handling
- Network error ditangani oleh `DioClient` → dipetakan ke `AppException` (sealed class)
- Subclass: `NetworkException`, `UnauthorizedException`, `ServerException`, `CacheException`
- Auto-refresh token 401 ditangani oleh `TokenRefreshInterceptor` (`QueuedInterceptor`)
- Presentation layer menangani error melalui `AsyncValue.when()` pattern

### Storage
- **Data sensitif** (token, password): `SecureStorageService` (flutter_secure_storage)
- **Preferensi umum** (theme, locale, onboarding): `SharedPreferencesStorage`
- **Cache/offline data**: `AppDatabase` (Drift)

---

## ⚙️ Environment & Flavor

| Konsep | Penjelasan |
| :--- | :--- |
| **Flavor** | Aplikasi mana yang dijalankan (`apps/main` vs `apps/variant`) |
| **Environment** | Backend mana yang dipakai (`dev`, `staging`, `prod`) via `--dart-define=ENV=...` |

Konfigurasi environment: `AppConfig` (abstract) → `MainConfig` / `VariantConfig` (per app)

---

## 🔒 Fitur Keamanan

| Fitur | Status | Lokasi |
|-------|--------|--------|
| Auto-refresh token (401) | ✅ Aktif | `core/network/token_refresh_interceptor.dart` |
| Biometric auth (fingerprint/Face ID) | ✅ Aktif | `features_shared/auth/data/biometric_auth_service.dart` |
| Secure storage | ✅ Aktif | `core/storage/secure_storage_service.dart` |

---

## 🎨 Fitur UX

| Fitur | Status | Lokasi |
|-------|--------|--------|
| Splash screen (animated) | ✅ Aktif | `features_shared/onboarding/presentation/splash_screen.dart` |
| Onboarding (3-page) | ✅ Aktif | `features_shared/onboarding/presentation/onboarding_screen.dart` |
| Theme switching (system/light/dark) | ✅ Aktif | `features_shared/settings/` |
| Locale switching (ID/EN) | ✅ Aktif | `features_shared/settings/` |

---

## 📂 Barrel Exports

Setiap package memiliki satu file barrel export:
- `package:core/core.dart` — semua yang ada di `packages/core/lib/src/`
- `package:features_shared/features_shared.dart` — semua yang ada di `packages/features_shared/lib/src/`

Saat menambahkan file baru, **WAJIB** tambahkan export-nya di barrel file.

---

## 🔧 Git & Contributing

- Branching: **Git Flow** (`main`, `develop`, `feature/*`, `hotfix/*`)
- Commit: **Conventional Commits** (`feat`, `fix`, `docs`, `chore`, `refactor`, `test`)
- Quality gates wajib passed sebelum push: `format:check`, `analyze`, `test`
- Lihat [CONTRIBUTING.md](CONTRIBUTING.md) untuk detail lengkap

---

## ⚠️ Hal-Hal yang HARUS DIHINDARI

1. ❌ Jangan import file dari `apps/main` ke `apps/variant` atau sebaliknya
2. ❌ Jangan hardcode URL API — gunakan `AppConfig` / `MainConfig` / `VariantConfig`
3. ❌ Jangan simpan data sensitif (token, password) di `SharedPreferences` — gunakan `SecureStorageService`
4. ❌ Jangan commit file `google-services.json`, `.env`, atau `*.jks` ke Git
5. ❌ Jangan menulis provider secara manual (vanilla) — gunakan `@riverpod` generator
6. ❌ Jangan lupa menambahkan export baru ke barrel file (`core.dart` / `features_shared.dart`)
7. ❌ Jangan membuat `Dio` instance baru di interceptor yang mengarah ke chain yang sama (infinite loop)
