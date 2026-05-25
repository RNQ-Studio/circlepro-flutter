# 🏗️ Fase 01: Sprint 1 — Fondasi & Core (1-2 Minggu)

> Dokumen ini berisi spesifikasi detail untuk Sprint 1 yang berfokus pada penguatan arsitektur core:
> 1. Migrasi ke Riverpod Generator (`@riverpod`)
> 2. Integrasi Riil Firebase Core & FCM
> 3. Integrasi Database Offline Isar
>
> **Prasyarat**: Seluruh tugas di [Fase 00: Temuan Kritis](00_critical.md) harus terselesaikan 100%.
> Saat menambahkan dependency baru, pastikan menggunakan versi terbaru.

---

## Daftar Tugas

- [x] [Tugas 1.1: Migrasi ke Riverpod Generator (`@riverpod`)](#tugas-11-migrasi-ke-riverpod-generator-riverpod)
- [x] [Tugas 1.2: Integrasi Riil Firebase Core & FCM](#tugas-12-integrasi-riil-firebase-core--fcm)
- [x] [Tugas 1.3: Integrasi Database Offline Drift (SQLite)](#tugas-13-integrasi-database-offline-isar)

---

## Tugas 1.1: Migrasi ke Riverpod Generator (`@riverpod`)

### Deskripsi & Konteks
Seluruh provider di proyek saat ini dideklarasikan secara manual menggunakan Riverpod vanilla/klasik (`NotifierProvider`, `AsyncNotifierProvider`, `Provider`, dll.). Migrasi ke Riverpod Generator (`@riverpod`) akan menghilangkan boilerplate, mengaktifkan `autoDispose` secara default, serta menjamin keamanan tipe pada provider keluarga (*family*).

### Lokasi Berkas
- **Package yang terpengaruh**: `packages/core`, `packages/features_shared`, `apps/main`, `apps/variant`
- **File-file provider utama yang harus di-refaktor**:
  - `packages/features_shared/lib/src/auth/presentation/auth_notifier.dart`
  - `packages/features_shared/lib/src/auth/presentation/auth_repository_provider.dart`
  - `packages/features_shared/lib/src/profile/presentation/profile_notifier.dart`
  - `packages/features_shared/lib/src/settings/presentation/theme_notifier.dart`
  - `packages/features_shared/lib/src/settings/presentation/locale_notifier.dart`
  - `apps/main/lib/features/home/presentation/home_notifier.dart` (jika ada)
  - `apps/main/lib/features/settings/presentation/` (semua provider terkait)
  - `apps/variant/lib/features/` (semua provider terkait)

### Langkah Eksekusi (Step-by-step)

#### Langkah 1: Tambahkan Dependensi ke Setiap Package

Untuk setiap package (`packages/core`, `packages/features_shared`, `apps/main`, `apps/variant`), tambahkan di `pubspec.yaml`:

```yaml
dependencies:
  flutter_riverpod: ^2.5.1        # (pastikan versi sudah sesuai)
  riverpod_annotation: ^2.3.5

dev_dependencies:
  riverpod_generator: ^2.4.3
  build_runner: ^2.4.13
  custom_lint: ^0.6.7
  riverpod_lint: ^2.3.13
```

#### Langkah 2: Refaktor Provider Satu Per Satu

Untuk setiap file provider, ikuti pola berikut:

**Sebelum (Vanilla):**
```dart
final authNotifierProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    // ...
    return const AuthInitial();
  }
}
```

**Sesudah (Generator):**
```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    // ...
    return const AuthInitial();
  }
}
```

#### Langkah 3: Refaktor Provider Sederhana (Non-Notifier)

Untuk provider yang hanya mengekpos nilai (seperti repository provider):

**Sebelum:**
```dart
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSource(ref.watch(dioClientProvider)),
    localDataSource: AuthLocalDataSource(ref.watch(secureStorageProvider)),
  );
});
```

**Sesudah:**
```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository_provider.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSource(ref.watch(dioClientProvider)),
    localDataSource: AuthLocalDataSource(ref.watch(secureStorageProvider)),
  );
}
```

#### Langkah 4: Generate File `.g.dart`

```bash
# Dari root workspace, jalankan build_runner untuk semua package
dart run melos exec -- "dart run build_runner build --delete-conflicting-outputs"
```

Atau tambahkan skrip Melos:
```yaml
scripts:
  codegen:
    run: melos exec -- "dart run build_runner build --delete-conflicting-outputs"
    description: Run code generation for all packages
```

#### Langkah 5: Update Barrel Exports

Pastikan file barrel (`core.dart`, `features_shared.dart`) mengekspor file `.g.dart` yang baru ter-generate jika diperlukan (biasanya `part` directive sudah cukup).

#### Langkah 6: Verifikasi dan Perbaiki Tes

Setelah migrasi, jalankan semua unit test dan widget test untuk memastikan tidak ada regresi:
```bash
dart run melos run test
```

### Batasan Arsitektur (Architectural Constraints)
- **Jangan campur** gaya vanilla dan generator dalam satu package — migrasi harus menyeluruh per package.
- File `.g.dart` hasil generate **harus di-commit** ke repositori agar developer lain tidak perlu menjalankan `build_runner` setiap kali clone.
- Patuhi aturan dependency: `core` → `features_shared` → `apps/*`. Jangan import provider dari `apps` ke `features_shared`.
- Provider yang bersifat `keepAlive` (tidak boleh di-dispose otomatis) harus menggunakan anotasi `@Riverpod(keepAlive: true)`.

### Cara Verifikasi
```bash
# 1. Pastikan code generation sukses tanpa error
dart run melos exec -- "dart run build_runner build --delete-conflicting-outputs"

# 2. Pastikan analisis statis bersih
dart run melos run analyze

# 3. Pastikan seluruh tes lolos
dart run melos run test
```

### Estimasi Effort
**M** (2-3 hari) — Membutuhkan refaktor sistematis di banyak file, namun perubahannya berpola dan repetitif.

---

## Tugas 1.2: Integrasi Riil Firebase Core & FCM

### Deskripsi & Konteks
Saat ini, fitur Push Notification di `features_shared` hanyalah *stub* kosong yang melempar `UnimplementedError`. Tidak ada dependensi Firebase SDK di mana pun. Tugas ini menambahkan Firebase Core dan Firebase Cloud Messaging (FCM) secara riil ke dalam proyek.

### Lokasi Berkas
- **Package yang terpengaruh**: `packages/core` (service layer), `packages/features_shared` (notification feature), `apps/main`, `apps/variant`
- **File baru yang harus dibuat**:
  - `packages/core/lib/src/services/firebase_service.dart`
  - `packages/core/lib/src/services/fcm_notification_service.dart`
- **File yang harus dimodifikasi**:
  - `packages/features_shared/lib/src/notifications/data/repositories/notifications_repository_impl.dart`
  - `packages/features_shared/lib/src/notifications/presentation/notifications_screen.dart`
  - `apps/main/lib/bootstrap.dart` (atau entry point inisialisasi)
  - `apps/variant/lib/bootstrap.dart`
  - `apps/main/android/app/build.gradle.kts`
  - `apps/variant/android/app/build.gradle.kts`

### Langkah Eksekusi (Step-by-step)

#### Langkah 1: Setup Konsol Firebase
1. Buat proyek Firebase di [Firebase Console](https://console.firebase.google.com/).
2. Registrasi aplikasi Android untuk `apps/main` (package name dari `AndroidManifest.xml`).
3. Registrasi aplikasi Android untuk `apps/variant` (package name berbeda).
4. Unduh file `google-services.json` untuk masing-masing app.

#### Langkah 2: Install FlutterFire CLI & Configure
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure untuk main app
cd apps/main
flutterfire configure --project=<your-firebase-project-id>

# Configure untuk variant app
cd apps/variant
flutterfire configure --project=<your-firebase-project-id-variant>
```

#### Langkah 3: Tambahkan Dependensi Firebase
Di `packages/core/pubspec.yaml`:
```yaml
dependencies:
  firebase_core: ^3.6.0
  firebase_messaging: ^15.1.4
```

Di `apps/main/pubspec.yaml` dan `apps/variant/pubspec.yaml`:
```yaml
dependencies:
  firebase_core: ^3.6.0
  firebase_messaging: ^15.1.4
```

#### Langkah 4: Buat Firebase Service di Core
```dart
// packages/core/lib/src/services/firebase_service.dart
import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  static Future<void> init({
    required FirebaseOptions options,
  }) async {
    await Firebase.initializeApp(options: options);
  }
}
```

#### Langkah 5: Buat FCM Notification Service di Core
```dart
// packages/core/lib/src/services/fcm_notification_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Callback handler untuk background message (harus top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message received: ${message.messageId}');
}

class FCMNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init({
    required void Function(RemoteMessage) onForegroundMessage,
    required void Function(RemoteMessage) onMessageOpenedApp,
  }) async {
    // 1. Request permission (iOS & Android 13+)
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // 2. Get FCM token
      final token = await _fcm.getToken();
      debugPrint('FCM Token: $token');

      // 3. Listen for token refresh
      _fcm.onTokenRefresh.listen((newToken) {
        debugPrint('FCM Token refreshed: $newToken');
        // TODO: Kirim token baru ke backend
      });

      // 4. Configure foreground listener
      FirebaseMessaging.onMessage.listen(onForegroundMessage);

      // 5. Configure notification click (app opened from background)
      FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedApp);

      // 6. Register background handler
      FirebaseMessaging.onBackgroundMessage(
        firebaseMessagingBackgroundHandler,
      );

      // 7. Handle initial message (app launched from terminated state)
      final initialMessage = await _fcm.getInitialMessage();
      if (initialMessage != null) {
        onMessageOpenedApp(initialMessage);
      }
    }
  }

  /// Mendapatkan token FCM saat ini
  Future<String?> getToken() => _fcm.getToken();
}
```

#### Langkah 6: Inisialisasi Firebase di Bootstrap
Di `apps/main/lib/bootstrap.dart`:
```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Generated by FlutterFire CLI

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ... rest of bootstrap
}
```

#### Langkah 7: Implementasi NotificationsRepositoryImpl
Ganti stub `UnimplementedError` dengan implementasi FCM yang riil di `features_shared`.

#### Langkah 8: Konfigurasi Platform Native
- **Android**: Pastikan `google-services.json` ditempatkan di `apps/main/android/app/` dan `apps/variant/android/app/`.
- **Android**: Tambahkan plugin Google Services di `build.gradle.kts`.
- **iOS**: Tambahkan `GoogleService-Info.plist` ke proyek Xcode.
- **iOS**: Aktifkan Push Notification capability di Xcode.

### Batasan Arsitektur (Architectural Constraints)
- Service Firebase **harus** diletakkan di `packages/core` agar dapat diakses oleh semua app flavor.
- `FirebaseOptions` yang di-generate oleh FlutterFire CLI **harus** tetap di folder `apps/*` masing-masing (tidak di `core`), karena setiap flavor memiliki konfigurasi Firebase berbeda.
- Background message handler **harus** berupa top-level function (bukan method instance).
- File `google-services.json` dan `GoogleService-Info.plist` **tidak boleh** di-commit ke Git (sudah ditangani di Tugas 0.3).

### Cara Verifikasi
```bash
# 1. Pastikan dependensi terpasang
cd apps/main && flutter pub get
cd apps/variant && flutter pub get

# 2. Pastikan analisis bersih
dart run melos run analyze

# 3. Build APK debug untuk memastikan integrasi berjalan
cd apps/main && flutter build apk --debug --dart-define=ENV=dev

# 4. Jalankan di emulator/device dan verifikasi log FCM token tercetak
cd apps/main && flutter run --dart-define=ENV=dev
```

### Estimasi Effort
**L** (4-5 hari) — Memerlukan konfigurasi konsol Firebase, integrasi multi-platform (Android & iOS), penanganan lifecycle notification, dan testing di device/emulator riil.

---

## Tugas 1.3: Integrasi Database Offline Isar

### Deskripsi & Konteks
Proyek saat ini hanya menggunakan `SharedPreferences` untuk penyimpanan key-value sederhana dan `flutter_secure_storage` untuk data sensitif. Tidak ada database lokal terstruktur untuk mendukung caching data offline. Tugas ini menambahkan **Isar Database** sebagai engine penyimpanan offline berkinerja tinggi.

### Lokasi Berkas
- **Package**: `packages/core`
- **File baru yang harus dibuat**:
  - `packages/core/lib/src/storage/isar_database_service.dart`
  - `packages/core/lib/src/storage/models/cache_entry.dart`
  - `packages/core/lib/src/storage/models/cache_entry.g.dart` (generated)
- **File yang harus dimodifikasi**:
  - `packages/core/pubspec.yaml` (tambah dependensi Isar)
  - `packages/core/lib/core.dart` (ekspor service baru)
  - `apps/main/lib/bootstrap.dart` (inisialisasi Isar)
  - `apps/variant/lib/bootstrap.dart` (inisialisasi Isar)

### Langkah Eksekusi (Step-by-step)

#### Langkah 1: Tambahkan Dependensi Isar
Di `packages/core/pubspec.yaml`:
```yaml
dependencies:
  isar: ^3.1.0+1
  isar_flutter_libs: ^3.1.0+1
  path_provider: ^2.1.4

dev_dependencies:
  isar_generator: ^3.1.0+1
  build_runner: ^2.4.13    # Mungkin sudah ada dari Tugas 1.1
```

#### Langkah 2: Buat Model Cache Entry
```dart
// packages/core/lib/src/storage/models/cache_entry.dart
import 'package:isar/isar.dart';

part 'cache_entry.g.dart';

@collection
class CacheEntry {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String key;

  late String jsonPayload;

  @Index()
  late DateTime createdAt;

  /// TTL (Time-to-Live) dalam detik. Null = tidak kedaluwarsa.
  int? ttlSeconds;

  /// Apakah entry ini sudah kedaluwarsa
  bool get isExpired {
    if (ttlSeconds == null) return false;
    return DateTime.now().difference(createdAt).inSeconds > ttlSeconds!;
  }
}
```

#### Langkah 3: Buat Isar Database Service
```dart
// packages/core/lib/src/storage/isar_database_service.dart
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'models/cache_entry.dart';

class IsarDatabaseService {
  late final Isar _isar;

  /// Inisialisasi database Isar
  Future<void> init({List<CollectionSchema<dynamic>> schemas = const []}) async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [CacheEntrySchema, ...schemas],
      directory: dir.path,
    );
  }

  /// Mendapatkan instance Isar (untuk akses langsung di feature)
  Isar get instance => _isar;

  /// Menyimpan data cache dengan key unik
  Future<void> writeCache(String key, String jsonPayload, {int? ttlSeconds}) async {
    final entry = CacheEntry()
      ..key = key
      ..jsonPayload = jsonPayload
      ..createdAt = DateTime.now()
      ..ttlSeconds = ttlSeconds;

    await _isar.writeTxn(() async {
      await _isar.cacheEntrys.put(entry);
    });
  }

  /// Membaca data cache berdasarkan key
  Future<String?> readCache(String key) async {
    final entry = await _isar.cacheEntrys
        .filter()
        .keyEqualTo(key)
        .findFirst();

    if (entry == null) return null;
    if (entry.isExpired) {
      // Hapus entry yang sudah kedaluwarsa
      await _isar.writeTxn(() async {
        await _isar.cacheEntrys.delete(entry.id);
      });
      return null;
    }
    return entry.jsonPayload;
  }

  /// Menghapus cache berdasarkan key
  Future<void> deleteCache(String key) async {
    await _isar.writeTxn(() async {
      await _isar.cacheEntrys.filter().keyEqualTo(key).deleteAll();
    });
  }

  /// Membersihkan seluruh entry yang sudah kedaluwarsa
  Future<int> evictExpired() async {
    int deleted = 0;
    await _isar.writeTxn(() async {
      final all = await _isar.cacheEntrys.where().findAll();
      for (final entry in all) {
        if (entry.isExpired) {
          await _isar.cacheEntrys.delete(entry.id);
          deleted++;
        }
      }
    });
    return deleted;
  }

  /// Membersihkan seluruh cache
  Future<void> clearAll() async {
    await _isar.writeTxn(() async {
      await _isar.cacheEntrys.clear();
    });
  }

  /// Menutup koneksi database
  Future<void> close() async {
    await _isar.close();
  }
}
```

#### Langkah 4: Generate File Isar
```bash
cd packages/core
dart run build_runner build --delete-conflicting-outputs
```

#### Langkah 5: Ekspor di Barrel File
Tambahkan ekspor di `packages/core/lib/core.dart`:
```dart
export 'src/storage/isar_database_service.dart';
export 'src/storage/models/cache_entry.dart';
```

#### Langkah 6: Buat Riverpod Provider untuk Isar Service
```dart
// packages/core/lib/src/storage/isar_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'isar_database_service.dart';

part 'isar_provider.g.dart';

@Riverpod(keepAlive: true)
IsarDatabaseService isarDatabase(IsarDatabaseRef ref) {
  // Instance ini harus di-init di bootstrap sebelum digunakan
  throw UnimplementedError(
    'isarDatabaseProvider must be overridden with a pre-initialized instance',
  );
}
```

Di bootstrap, override provider ini dengan instance yang sudah diinisialisasi.

#### Langkah 7: Inisialisasi Isar di Bootstrap
```dart
// Di apps/main/lib/bootstrap.dart
final isarService = IsarDatabaseService();
await isarService.init();

// Override provider dengan instance riil
runApp(
  ProviderScope(
    overrides: [
      isarDatabaseProvider.overrideWithValue(isarService),
    ],
    child: const MyApp(),
  ),
);
```

### Batasan Arsitektur (Architectural Constraints)
- Isar service dan model cache **harus** diletakkan di `packages/core`.
- Collection schema khusus fitur bisnis (misalnya `OrderCache`, `ProductCache`) **boleh** didefinisikan di `packages/features_shared` atau `apps/*`, namun harus di-register saat inisialisasi di bootstrap.
- Semua operasi database Isar yang menulis data **harus** dibungkus dalam `writeTxn`.
- File `.g.dart` hasil generate Isar **harus di-commit** ke repositori.

### Cara Verifikasi
```bash
# 1. Generate file Isar
cd packages/core && dart run build_runner build --delete-conflicting-outputs

# 2. Analisis statis bersih
dart run melos run analyze

# 3. Tes unit Isar service
dart run melos run test

# 4. Build dan jalankan app untuk verifikasi runtime
cd apps/main && flutter run --dart-define=ENV=dev
```

### Estimasi Effort
**L** (4-5 hari) — Membutuhkan perancangan arsitektur caching, pembuatan skema, integrasi dengan provider Riverpod, dan pengujian eviction policy.
