# features_shared

`features_shared` adalah package fitur yang dipakai oleh semua app/flavor di monorepo ini. Package ini berada di atas `core` dan boleh memakai infrastruktur dari `package:core/core.dart`, tetapi tidak boleh bergantung pada `apps/main`, `apps/variant`, atau app lain.

Gunakan package ini untuk fitur reusable seperti auth, profile, notifications, settings logic, dan fitur bisnis yang memang dibagi antar app.

---

## Isi Package

Public API diexport melalui:

```dart
import 'package:features_shared/features_shared.dart';
```

Fitur saat ini:

| Fitur | Status | Isi |
|-------|--------|-----|
| `auth` | implemented starter | entity user, repository, usecase, data source, login screen, provider, auth routes, redirect |
| `profile` | stub | entity, repository interface, usecase, repository impl hardcoded, provider, screen |
| `notifications` | stub | entity, repository interface, usecase, repository impl empty list, provider, screen |
| `settings` | implemented starter | theme/locale repository, notifier, provider, persistent preference |

---

## Aturan Dependency

Dependency direction:

```text
apps/* -> features_shared -> core
```

Aturan utama:

- `features_shared` boleh import `package:core/core.dart`.
- `features_shared` tidak boleh import dari `apps/main`, `apps/variant`, atau app lain.
- UI yang harus berbeda per app sebaiknya berada di `apps/<app_name>/lib/features/`.
- Shared logic yang reusable boleh tetap berada di `features_shared`.
- Dari app, import public API lewat `package:features_shared/features_shared.dart`.

---

## Struktur Fitur

Untuk fitur bisnis besar, gunakan struktur:

```text
src/<feature>/
|-- data/
|   |-- datasources/
|   |-- models/
|   `-- repositories/
|-- domain/
|   |-- entities/
|   |-- repositories/
|   `-- usecases/
`-- presentation/
    |-- providers / notifier
    |-- screens
    `-- routes
```

Fitur kecil boleh memakai struktur lebih sederhana jika belum membutuhkan tiga lapisan penuh. Contohnya `settings`, yang berisi shared logic untuk theme dan locale preference.

---

## Auth

Auth menyediakan:

- `User`
- `AuthRepository`
- `LoginUseCase`, `RegisterUseCase`, `LogoutUseCase`, `GetCurrentUserUseCase`
- `AuthRepositoryImpl`
- `AuthNotifier`
- `authNotifierProvider`
- `authRepositoryProvider`
- `storageServiceProvider`
- `authRoutes`
- `authRedirect`
- `LoginScreen`

App wajib mengoverride `storageServiceProvider` karena token auth adalah tanggung jawab app root:

```dart
ProviderScope(
  overrides: [
    storageServiceProvider.overrideWithValue(storage),
  ],
  child: const _AppRouter(),
)
```

`apps/main` saat ini mengoverride `authRepositoryProvider` dengan `FakeAuthRepository` saat debug mode agar development bisa berjalan tanpa backend. Untuk production, hapus atau sesuaikan override tersebut.

---

## Settings

Settings menyimpan:

- `ThemeMode`
- `Locale`

Data disimpan menggunakan `SharedPreferencesStorage` karena bukan data sensitif.

Provider utama:

```dart
final themeMode =
    ref.watch(themeNotifierProvider).asData?.value ?? ThemeMode.system;
final locale = ref.watch(localeNotifierProvider).asData?.value;
```

Contoh penggunaan di `MaterialApp.router`:

```dart
MaterialApp.router(
  theme: AppTheme.light,
  darkTheme: AppTheme.dark,
  themeMode: themeMode,
  locale: locale,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  routerConfig: appRouter,
)
```

UI settings sengaja berada di masing-masing app agar setiap flavor bisa punya tampilan berbeda:

```text
apps/main/lib/features/settings/
apps/variant/lib/features/settings/
```

---

## Routing

Shared auth routes diexport melalui `authRoutes`. App menggabungkan shared routes dengan routes milik app:

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

Route dengan UI berbeda antar app, seperti settings, didefinisikan di app masing-masing.

---

## Menambah Shared Feature

Tambahkan fitur baru di:

```text
lib/src/<feature>/
```

Lalu export API yang memang perlu dipakai app dari:

```text
lib/features_shared.dart
```

Jangan export helper internal, DTO yang tidak perlu, atau implementasi detail yang hanya dipakai repository.

Panduan lengkap ada di:

```text
../../docs/ADD_FEATURE.md
```

---

## Test dan Analyze

Jalankan dari root repo:

```bash
dart analyze packages/features_shared
flutter test packages/features_shared/test
```

Atau dari folder package:

```bash
cd packages/features_shared
flutter test
```
