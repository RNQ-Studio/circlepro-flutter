# Sprint 006 — Profile Feature

Tujuan: mengimplementasi fitur Profile yang saat ini masih stub di `packages/features_shared` — lengkap dengan domain, data, dan presentation layer — serta menampilkannya di kedua app. Sprint ini mendemonstrasikan full Clean Architecture pattern untuk fitur selain auth.

Acceptance criteria sprint: Profile screen tampil di kedua app, menampilkan data user yang sedang login (nama dan email), dengan tombol logout. Data profile dibaca dari sesi auth yang sudah ada — tidak perlu API call terpisah.

> **Desain keputusan:** Profile di sprint ini menggunakan data `User` dari sesi auth yang sudah ada (tidak memanggil `/profile` endpoint terpisah). Ini cukup untuk starter — pengembang yang butuh profile API terpisah bisa extend setelah starter ini menjadi project nyata.

---

## Arsitektur Profile Feature

```text
packages/features_shared/lib/src/profile/
├── domain/
│   ├── entities/profile.dart           ← entity Profile (wrap User)
│   ├── repositories/profile_repository.dart
│   └── usecases/
│       ├── get_profile_use_case.dart
│       └── update_profile_use_case.dart
├── data/
│   └── repositories/profile_repository_impl.dart  ← membaca dari AuthRepository
└── presentation/
    ├── profile_provider.dart
    └── profile_screen.dart             ← tampilkan nama, email, tombol logout

apps/main/lib/features/profile/presentation/profile_route.dart
apps/variant/lib/features/profile/presentation/profile_route.dart
```

Untuk starter ini, `ProfileScreen` diletakkan di `features_shared` karena UI kedua app sama — hanya tampilkan nama, email, dan tombol logout.

---

## Phase 1 — Review & Complete Domain Layer ✅

- [x] Review `packages/features_shared/lib/src/profile/domain/entities/profile.dart` — entity benar, punya id, name, email (+ avatarUrl, bio optional)
- [x] Update `packages/features_shared/lib/src/profile/domain/repositories/profile_repository.dart` — interface diupdate ke `getProfile()` tanpa arg, return `Future<Profile?>`, `updateProfile` return `Future<void>`
- [x] Update `packages/features_shared/lib/src/profile/domain/usecases/get_profile_use_case.dart` — call `_repository.getProfile()` tanpa arg
- [x] `update_profile_use_case.dart` — stub dengan comment TODO, tidak diimplementasi di Sprint 006
- [x] `dart analyze packages/features_shared` — no issues

**Selesai jika:** Domain layer clean, entity dan usecase sudah benar. ✅

---

## Phase 2 — Implementasi Data Layer ✅

- [x] Update `packages/features_shared/lib/src/profile/data/repositories/profile_repository_impl.dart`:
  - Inject `AuthRepository` via constructor
  - `getProfile()` membaca `getCurrentUser()` dari auth, map ke `Profile`
  - `updateProfile()` stub TODO read-only
- [x] `dart analyze packages/features_shared` — no issues

**Selesai jika:** `ProfileRepositoryImpl` bisa dikompilasi tanpa error. ✅

---

## Phase 3 — Implementasi Presentation Layer ✅

- [x] Update `packages/features_shared/lib/src/profile/presentation/profile_provider.dart`:
  - `profileRepositoryProvider` inject `authRepositoryProvider`
  - `profileProvider` sebagai `FutureProvider<Profile?>` via `GetProfileUseCase`
- [x] Update `packages/features_shared/lib/src/profile/presentation/profile_screen.dart`:
  - `ConsumerWidget` yang watch `profileProvider`
  - Avatar dengan inisial nama
  - ListTile untuk Name, Email
  - ListTile Logout yang trigger `authNotifierProvider.notifier.logout()`
  - Semua teks via `AppLocalizations` (l10n)
- [x] `dart analyze packages/features_shared` — no issues

**Selesai jika:** `ProfileScreen` bisa dirender dan menampilkan data dari `profileProvider`. ✅

---

## Phase 4 — Export & Route ✅

- [x] Verifikasi exports di `packages/features_shared/lib/features_shared.dart` — semua file profile sudah diexport
- [x] `AppRoutes.profile = '/profile'` sudah ada di `packages/core/lib/src/router/app_routes.dart`
- [x] Buat `apps/main/lib/features/profile/presentation/profile_route.dart`
- [x] Daftarkan `profileRoute` di `apps/main/lib/router/app_router.dart`
- [x] Buat `apps/variant/lib/features/profile/presentation/profile_route.dart`
- [x] Daftarkan `profileRoute` di `apps/variant/lib/router/app_router.dart`
- [x] Tambah tombol profile (`Icons.person_outline`) di `HomeScreen` kedua app — navigate ke `AppRoutes.profile`
- [x] `dart analyze packages/core packages/features_shared apps/main apps/variant` — no issues

**Selesai jika:** Profile screen bisa dibuka dari home, data user tampil. ✅

---

## Phase 5 — L10n Profile ✅

Sprint 003 sudah selesai, keys l10n ditambahkan:

- [x] Tambah ke `app_en.arb`: `"profile"`, `"name"`, `"logoutConfirm"`
- [x] Tambah ke `app_id.arb`: `"profile"`, `"name"`, `"logoutConfirm"` (dengan @-metadata)
- [x] Update `app_localizations.dart` — tambah abstract getter `profile`, `name`, `logoutConfirm`
- [x] Update `app_localizations_en.dart` — implementasi EN
- [x] Update `app_localizations_id.dart` — implementasi ID
- [x] `profile_screen.dart` menggunakan `l10n.profile`, `l10n.name`, `l10n.email`, `l10n.logout`

---

## Phase 6 — Verifikasi ✅

- [x] `dart analyze packages/core packages/features_shared apps/main apps/variant` — no issues
- [x] `flutter test` — semua pass
- [x] Verifikasi alur profile:
  - Login → buka Profile via icon di AppBar → nama dan email tampil ✅
  - Tap Logout → redirect ke login screen ✅
  - Login ulang → Profile kembali menampilkan data ✅
  - Berlaku di `apps/main` dan `apps/variant` ✅

**Selesai jika:** Profile screen fungsional di kedua app, logout bekerja dari profile screen. ✅
