# Sprint 004 — Testing

Tujuan: menambahkan test yang bermakna ke seluruh package dan app — bukan hanya smoke test widget, tapi unit test untuk repository, notifier, dan usecase. Sprint ini menjadikan starter benar-benar bisa dipakai sebagai fondasi yang teruji.

Acceptance criteria sprint: `flutter test` dari root pass tanpa error, coverage mencakup happy path dan error path untuk semua shared logic penting.

> **Catatan versi dependency:**
> Selalu gunakan versi **terbaru** untuk semua dependency.
> Versi di dokumen ini adalah versi terbaru pada saat sprint ditulis **(2026-05-21)**.
>
> | Package | Versi saat dokumen ditulis |
> |---|---|
> | `mocktail` | `^1.0.4` |

---

## Apa yang ditest dan mengapa

| Target | Tipe test | Prioritas |
|--------|-----------|-----------|
| `SettingsRepositoryImpl` | Unit — storage read/write | Tinggi — logic persisten utama Sprint 002 |
| `ThemeNotifier` / `LocaleNotifier` | Provider — state transition | Tinggi — shared provider dipakai semua app |
| `AuthNotifier` | Provider — loading/success/error | Tinggi — auth flow paling kritis |
| `AuthRepositoryImpl` | Unit — remote+local koordinasi | Tinggi |
| `LoginScreen` | Widget — render + state | Sedang |
| `SettingsScreen` (main) | Widget — render + pilih theme | Sedang |
| `HomeScreen` | Widget — smoke test + settings nav | Sudah ada, perlu diupdate |
| `AppException.toString()` | Unit — message formatting | Rendah (trivial tapi perlu dikonfirmasi) |

---

## Phase 1 — Setup Test Infrastructure

- [x] Tambah `mocktail` ke dev_dependencies `packages/features_shared/pubspec.yaml`:
  ```yaml
  dev_dependencies:
    flutter_test:
      sdk: flutter
    mocktail: ^1.0.4
  ```
- [x] Tambah `mocktail` ke dev_dependencies `apps/main/pubspec.yaml` dan `apps/variant/pubspec.yaml`
- [x] `dart pub get` dari root
- [x] Buat struktur direktori test:
  ```bash
  mkdir -p packages/features_shared/test/settings
  mkdir -p packages/features_shared/test/auth
  mkdir -p apps/main/test/features/settings
  ```

**Selesai jika:** `mocktail` tersedia di semua package yang butuh mock, direktori test sudah ada.

---

## Phase 2 — Unit Test `packages/core`

- [x] Buat `packages/core/test/errors/app_exception_test.dart`:
  ```dart
  import 'package:core/core.dart';
  import 'package:flutter_test/flutter_test.dart';

  void main() {
    group('AppException.toString', () {
      test('ServerException returns message', () {
        const e = ServerException('Server error');
        expect(e.toString(), 'Server error');
      });

      test('NetworkException returns message', () {
        const e = NetworkException('No connection', statusCode: 503);
        expect(e.toString(), 'No connection');
      });

      test('CacheException returns message', () {
        const e = CacheException('Cache miss');
        expect(e.toString(), 'Cache miss');
      });

      test('UnauthorizedException returns Unauthorized', () {
        const e = UnauthorizedException();
        expect(e.toString(), 'Unauthorized');
      });
    });
  }
  ```
- [x] `flutter test packages/core/test` — pass

**Selesai jika:** AppException toString behavior terdokumentasi via test.

---

## Phase 3 — Unit Test Settings (`packages/features_shared`)

Gunakan `StorageService` mock agar test tidak bergantung pada SharedPreferences asli.

- [x] Buat `packages/features_shared/test/settings/mock_storage.dart`:
  ```dart
  import 'package:core/core.dart';
  import 'package:mocktail/mocktail.dart';

  class MockStorageService extends Mock implements StorageService {}
  ```
- [x] Buat `packages/features_shared/test/settings/settings_repository_impl_test.dart`:
  ```dart
  import 'package:flutter/material.dart';
  import 'package:flutter_test/flutter_test.dart';
  import 'package:mocktail/mocktail.dart';
  import 'package:features_shared/features_shared.dart';

  import 'mock_storage.dart';

  void main() {
    late MockStorageService storage;
    late SettingsRepositoryImpl repo;

    setUp(() {
      storage = MockStorageService();
      repo = SettingsRepositoryImpl(storage);
    });

    group('getThemeMode', () {
      test('returns ThemeMode.light when stored value is "light"', () async {
        when(() => storage.read('settings_theme_mode'))
            .thenAnswer((_) async => 'light');
        expect(await repo.getThemeMode(), ThemeMode.light);
      });

      test('returns ThemeMode.dark when stored value is "dark"', () async {
        when(() => storage.read('settings_theme_mode'))
            .thenAnswer((_) async => 'dark');
        expect(await repo.getThemeMode(), ThemeMode.dark);
      });

      test('returns ThemeMode.system when no value stored', () async {
        when(() => storage.read('settings_theme_mode'))
            .thenAnswer((_) async => null);
        expect(await repo.getThemeMode(), ThemeMode.system);
      });
    });

    group('saveThemeMode', () {
      test('writes mode.name to storage', () async {
        when(() => storage.write('settings_theme_mode', 'dark'))
            .thenAnswer((_) async {});
        await repo.saveThemeMode(ThemeMode.dark);
        verify(() => storage.write('settings_theme_mode', 'dark')).called(1);
      });
    });

    group('getLocale', () {
      test('returns stored locale', () async {
        when(() => storage.read('settings_locale'))
            .thenAnswer((_) async => 'en');
        expect(await repo.getLocale(), const Locale('en'));
      });

      test('returns Locale("id") as default when no value stored', () async {
        when(() => storage.read('settings_locale'))
            .thenAnswer((_) async => null);
        expect(await repo.getLocale(), const Locale('id'));
      });
    });

    group('saveLocale', () {
      test('writes languageCode to storage', () async {
        when(() => storage.write('settings_locale', 'en'))
            .thenAnswer((_) async {});
        await repo.saveLocale(const Locale('en'));
        verify(() => storage.write('settings_locale', 'en')).called(1);
      });
    });
  }
  ```
- [x] `flutter test packages/features_shared/test/settings` — pass

**Selesai jika:** Happy path dan default value settings repository terdokumentasi via test.

---

## Phase 4 — Unit Test Auth (`packages/features_shared`)

- [x] Buat `packages/features_shared/test/auth/mock_auth_repository.dart`:
  ```dart
  import 'package:features_shared/features_shared.dart';
  import 'package:mocktail/mocktail.dart';

  class MockAuthRepository extends Mock implements AuthRepository {}
  ```
- [x] Buat `packages/features_shared/test/auth/auth_notifier_test.dart`:
  ```dart
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:flutter_test/flutter_test.dart';
  import 'package:mocktail/mocktail.dart';
  import 'package:features_shared/features_shared.dart';

  import 'mock_auth_repository.dart';

  void main() {
    late MockAuthRepository mockRepo;
    late ProviderContainer container;

    setUp(() {
      mockRepo = MockAuthRepository();
      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
    });

    tearDown(() => container.dispose());

    const tUser = User(id: '1', name: 'Test', email: 'test@test.com');

    test('initial state is AuthInitial', () {
      expect(container.read(authNotifierProvider), isA<AuthInitial>());
    });

    test('login success → AuthAuthenticated', () async {
      when(() => mockRepo.login(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => tUser);

      await container.read(authNotifierProvider.notifier).login(
            email: 'test@test.com',
            password: 'password',
          );

      expect(container.read(authNotifierProvider), isA<AuthAuthenticated>());
      expect(
        (container.read(authNotifierProvider) as AuthAuthenticated).user,
        tUser,
      );
    });

    test('login failure → AuthError with message', () async {
      when(() => mockRepo.login(email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(const ServerException('Invalid credentials'));

      await container.read(authNotifierProvider.notifier).login(
            email: 'wrong@test.com',
            password: 'wrongpass',
          );

      final state = container.read(authNotifierProvider);
      expect(state, isA<AuthError>());
      expect((state as AuthError).message, 'Invalid credentials');
    });

    test('logout → AuthUnauthenticated', () async {
      when(() => mockRepo.login(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => tUser);
      when(() => mockRepo.logout()).thenAnswer((_) async {});

      await container.read(authNotifierProvider.notifier).login(
            email: 'test@test.com', password: 'password');
      await container.read(authNotifierProvider.notifier).logout();

      expect(container.read(authNotifierProvider), isA<AuthUnauthenticated>());
    });
  }
  ```
- [x] `flutter test packages/features_shared/test/auth` — pass

**Selesai jika:** Login success, login failure (dengan pesan yang benar), dan logout ter-cover.

---

## Phase 5 — Widget Test `apps/main`

- [x] Update `apps/main/test/home_screen_test.dart` — tambah test tombol settings:
  ```dart
  import 'package:app_main/home/home_screen.dart';
  import 'package:core/core.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_test/flutter_test.dart';
  import 'package:go_router/go_router.dart';

  void main() {
    Widget buildSubject() => MaterialApp.router(
          routerConfig: GoRouter(
            routes: [
              GoRoute(
                path: '/',
                builder: (_, __) => const HomeScreen(),
              ),
              GoRoute(
                path: AppRoutes.settings,
                builder: (_, __) => const Scaffold(body: Text('Settings')),
              ),
            ],
          ),
        );

    testWidgets('shows home title and welcome text', (tester) async {
      await tester.pumpWidget(buildSubject());
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Welcome!'), findsOneWidget);
    });

    testWidgets('settings icon navigates to settings route', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsOneWidget);
    });
  }
  ```
  > Setelah Sprint 003 selesai, teks `'Home'` dan `'Welcome!'` akan berasal dari ARB. Update test ini dengan `AppLocalizations` jika Sprint 003 sudah diimplementasi.
- [x] Buat `apps/main/test/features/settings/settings_screen_test.dart`:
  ```dart
  import 'package:app_main/features/settings/presentation/settings_screen.dart';
  import 'package:features_shared/features_shared.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:flutter_test/flutter_test.dart';

  void main() {
    Widget buildSubject({ThemeMode mode = ThemeMode.system}) =>
        ProviderScope(
          overrides: [
            themeNotifierProvider.overrideWith(() => _FakeThemeNotifier(mode)),
            localeNotifierProvider.overrideWith(
                () => _FakeLocaleNotifier(const Locale('id'))),
          ],
          child: const MaterialApp(home: SettingsScreen()),
        );

    testWidgets('shows Appearance and Language sections', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();
      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
    });

    testWidgets('shows all three theme options', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();
      expect(find.text('System default'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);
    });
  }

  class _FakeThemeNotifier extends ThemeNotifier {
    _FakeThemeNotifier(this._mode);
    final ThemeMode _mode;
    @override
    Future<ThemeMode> build() async => _mode;
  }

  class _FakeLocaleNotifier extends LocaleNotifier {
    _FakeLocaleNotifier(this._locale);
    final Locale _locale;
    @override
    Future<Locale> build() async => _locale;
  }
  ```
  > `_FakeThemeNotifier` dan `_FakeLocaleNotifier` meng-override `build()` agar tidak perlu storage asli saat test.
- [x] `flutter test apps/main/test` — semua pass

**Selesai jika:** HomeScreen dan SettingsScreen ter-cover termasuk navigasi dan konten utama.

---

## Phase 6 — Verifikasi Final

- [x] `flutter test apps/main/test apps/variant/test packages/core/test packages/features_shared/test` — semua pass
- [x] `dart analyze packages/core packages/features_shared apps/main apps/variant` — no issues
- [x] Update sprint doc — centang semua task

**Selesai jika:** Semua test pass, analyze clean, tidak ada test yang di-skip.
