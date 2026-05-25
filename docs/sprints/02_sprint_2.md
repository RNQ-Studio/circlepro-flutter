# 🎨 Fase 02: Sprint 2 — UX & Security (2-4 Minggu)

> Dokumen ini berisi spesifikasi detail untuk Sprint 2 yang berfokus pada peningkatan keamanan sesi dan pengalaman pengguna (UX):
> 1. Auto-Refresh Token (401 Interceptor)
> 2. Premium Splash Screen & Onboarding UI
> 3. Autentikasi Biometrik (Sidik Jari / Wajah)
>
> **Prasyarat**: Seluruh tugas di [Fase 01: Sprint 1](01_sprint_1.md) harus terselesaikan 100%.

---

## Daftar Tugas

- [x] [Tugas 2.1: Auto-Refresh Token (401 Interceptor)](#tugas-21-auto-refresh-token-401-interceptor)
- [x] [Tugas 2.2: Premium Splash Screen & Onboarding UI](#tugas-22-premium-splash-screen--onboarding-ui)
- [x] [Tugas 2.3: Autentikasi Biometrik](#tugas-23-autentikasi-biometrik)

---

## Tugas 2.1: Auto-Refresh Token (401 Interceptor)

### Deskripsi & Konteks
Saat ini, `DioClient` di `packages/core` menangkap HTTP status 401 dan memetakannya sebagai `UnauthorizedException`, namun **tidak memiliki mekanisme auto-refresh token**. Ketika access token kedaluwarsa, pengguna langsung dipaksa logout tanpa ada upaya pembaruan token di latar belakang. Ini menghasilkan pengalaman pengguna yang buruk, terutama pada sesi panjang.

### Lokasi Berkas
- **Package**: `packages/core`
- **File yang harus dimodifikasi**:
  - `packages/core/lib/src/network/dio_client.dart` (atau lokasi `AuthInterceptor`)
  - `packages/core/lib/src/network/auth_interceptor.dart` (jika terpisah)
- **File baru yang mungkin dibuat**:
  - `packages/core/lib/src/network/token_refresh_interceptor.dart`

### Langkah Eksekusi (Step-by-step)

#### Langkah 1: Identifikasi Kontrak Refresh Token
Tentukan endpoint backend untuk refresh token:
```
POST /api/auth/refresh
Headers: { "Authorization": "Bearer <refresh_token>" }
Response: { "access_token": "...", "refresh_token": "..." }
```

#### Langkah 2: Buat Token Refresh Interceptor
```dart
// packages/core/lib/src/network/token_refresh_interceptor.dart
import 'dart:async';
import 'package:dio/dio.dart';
import '../storage/secure_storage_service.dart';
import '../constants/app_constants.dart';

class TokenRefreshInterceptor extends QueuedInterceptor {
  final Dio _dio;
  final SecureStorageService _storage;
  final String _refreshEndpoint;
  final Future<void> Function()? _onLogout;

  TokenRefreshInterceptor({
    required Dio dio,
    required SecureStorageService storage,
    required String refreshEndpoint,
    Future<void> Function()? onLogout,
  })  : _dio = dio,
        _storage = storage,
        _refreshEndpoint = refreshEndpoint,
        _onLogout = onLogout;

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        // 1. Baca refresh token dari secure storage
        final refreshToken = await _storage.read(AppConstants.keyRefreshToken);
        if (refreshToken == null) {
          await _onLogout?.call();
          return handler.reject(err);
        }

        // 2. Kirim request refresh token (tanpa interceptor untuk menghindari loop)
        final refreshDio = Dio(BaseOptions(baseUrl: _dio.options.baseUrl));
        final response = await refreshDio.post(
          _refreshEndpoint,
          options: Options(
            headers: {'Authorization': 'Bearer $refreshToken'},
          ),
        );

        // 3. Simpan token baru
        final newAccessToken = response.data['access_token'] as String;
        final newRefreshToken = response.data['refresh_token'] as String?;

        await _storage.write(AppConstants.keyAuthToken, newAccessToken);
        if (newRefreshToken != null) {
          await _storage.write(AppConstants.keyRefreshToken, newRefreshToken);
        }

        // 4. Retry request awal dengan token baru
        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer $newAccessToken';
        final retryResponse = await _dio.fetch(opts);
        return handler.resolve(retryResponse);
      } catch (e) {
        // Refresh gagal → paksa logout
        await _onLogout?.call();
        return handler.reject(err);
      }
    }
    return handler.next(err);
  }
}
```

**Catatan penting**: Gunakan `QueuedInterceptor` (bukan `Interceptor` biasa) agar multiple request 401 yang terjadi bersamaan tidak memicu refresh token berkali-kali.

#### Langkah 3: Integrasikan ke DioClient
Di file `dio_client.dart`, tambahkan `TokenRefreshInterceptor` ke chain interceptor Dio:
```dart
_dio.interceptors.addAll([
  AuthInterceptor(storage: _storage),
  TokenRefreshInterceptor(
    dio: _dio,
    storage: _storage,
    refreshEndpoint: '/api/auth/refresh',
    onLogout: () async {
      // Trigger global logout event
      await _storage.deleteAll();
    },
  ),
  // ... interceptor lainnya
]);
```

#### Langkah 4: Tambahkan Konstanta Refresh Token
Di `app_constants.dart`, tambahkan:
```dart
static const String keyRefreshToken = 'refresh_token';
```

#### Langkah 5: Update Flow Login
Pastikan saat login berhasil, **refresh token** juga disimpan ke secure storage:
```dart
// Di auth_notifier.dart atau auth_repository_impl.dart
await _storage.write(AppConstants.keyAuthToken, response.accessToken);
await _storage.write(AppConstants.keyRefreshToken, response.refreshToken);
```

### Batasan Arsitektur (Architectural Constraints)
- Token refresh interceptor **harus** diletakkan di `packages/core`, bukan di `features_shared` atau `apps`.
- Gunakan `QueuedInterceptor` untuk mencegah race condition saat banyak request gagal 401 secara bersamaan.
- Logika logout global **tidak boleh** langsung memanipulasi UI — gunakan mekanisme event/callback yang di-listen oleh presentation layer.
- Jangan buat instance `Dio` baru di interceptor yang mengarah ke interceptor chain yang sama (untuk menghindari infinite loop).

### Cara Verifikasi
```bash
# 1. Analisis statis bersih
dart run melos run analyze

# 2. Unit test interceptor
dart run melos run test

# 3. Testing manual:
#    a. Login → dapatkan token
#    b. Tunggu token expire (atau mock expiration di backend)
#    c. Lakukan API call → verifikasi token di-refresh otomatis tanpa logout
```

### Estimasi Effort
**M** (2 hari) — Logika interceptor cukup kompleks karena harus menangani race condition dan error cascading, namun pattern-nya sudah mapan.

---

## Tugas 2.2: Premium Splash Screen & Onboarding UI

### Deskripsi & Konteks
Saat ini aplikasi boot langsung dari frame callback ke halaman login tanpa layar splash branding maupun onboarding. Ini memberikan kesan "mentah" bagi pengguna baru. Tugas ini menambahkan splash screen premium dengan animasi branding dan layar onboarding intro untuk pengalaman pertama kali yang impresif.

### Lokasi Berkas
- **Package**: `packages/features_shared`
- **File baru yang harus dibuat**:
  - `packages/features_shared/lib/src/onboarding/presentation/splash_screen.dart`
  - `packages/features_shared/lib/src/onboarding/presentation/onboarding_screen.dart`
  - `packages/features_shared/lib/src/onboarding/presentation/onboarding_notifier.dart`
  - `packages/features_shared/lib/src/onboarding/domain/onboarding_repository.dart`
  - `packages/features_shared/lib/src/onboarding/data/onboarding_repository_impl.dart`
- **File yang harus dimodifikasi**:
  - `apps/main/lib/app_router.dart` (tambah rute splash & onboarding)
  - `apps/variant/lib/app_router.dart`
  - `packages/core/lib/src/storage/shared_preferences_storage.dart` (tambah key onboarding)

### Langkah Eksekusi (Step-by-step)

#### Langkah 1: Buat Struktur Folder Onboarding
```
packages/features_shared/lib/src/onboarding/
├── data/
│   └── onboarding_repository_impl.dart
├── domain/
│   └── onboarding_repository.dart
└── presentation/
    ├── splash_screen.dart
    ├── onboarding_screen.dart
    └── onboarding_notifier.dart
```

#### Langkah 2: Implementasi Splash Screen
Buat layar splash dengan animasi fade-in logo dan loading indicator:
```dart
// packages/features_shared/lib/src/onboarding/presentation/splash_screen.dart
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();

    // Navigasi setelah 2 detik
    Future.delayed(const Duration(seconds: 2), _checkNavigation);
  }

  void _checkNavigation() {
    // Cek status: sudah onboarding? sudah login?
    // Arahkan ke halaman yang sesuai
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo animasi
              Icon(Icons.rocket_launch, size: 80,
                  color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 24),
              Text('Your App Name',
                  style: Theme.of(context).textTheme.headlineMedium),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

#### Langkah 3: Implementasi Onboarding Screen
Buat layar onboarding dengan PageView dot-indicator (3-4 halaman intro):
- Halaman 1: Pengenalan fitur utama
- Halaman 2: Keunggulan produk
- Halaman 3: Call-to-action "Mulai Sekarang"

#### Langkah 4: Implementasi Onboarding Notifier
```dart
// Simpan status onboarding di SharedPreferences
@riverpod
class OnboardingNotifier extends _$OnboardingNotifier {
  @override
  bool build() {
    // Baca dari SharedPreferences apakah sudah pernah onboarding
    return false;
  }

  Future<void> completeOnboarding() async {
    // Simpan flag ke SharedPreferences
    await ref.read(sharedPreferencesStorageProvider).setBool(
      'has_completed_onboarding', true);
    state = true;
  }
}
```

#### Langkah 5: Update Router
Tambahkan rute splash dan onboarding di `app_router.dart`:
```dart
GoRoute(
  path: '/',
  builder: (context, state) => const SplashScreen(),
),
GoRoute(
  path: '/onboarding',
  builder: (context, state) => const OnboardingScreen(),
),
```

#### Langkah 6: Siapkan Aset
- Buat folder `assets/images/` di `packages/core` atau `apps/main`.
- Tambahkan logo aplikasi dan gambar ilustrasi onboarding.
- Daftarkan aset di `pubspec.yaml`.

### Batasan Arsitektur (Architectural Constraints)
- Layar splash dan onboarding **harus** diletakkan di `packages/features_shared` agar dapat digunakan oleh semua flavor.
- Navigasi dari splash ke onboarding/login **harus** menggunakan `GoRouter.go()` (bukan `push`) agar pengguna tidak bisa kembali ke splash via tombol back.
- Status "sudah onboarding" harus persisten di `SharedPreferences` agar tidak ditampilkan ulang.
- Aset gambar bisa diletakkan di `apps/*/assets/` (per flavor) atau `packages/core/assets/` (shared).

### Cara Verifikasi
```bash
# 1. Analisis statis bersih
dart run melos run analyze

# 2. Widget test splash dan onboarding
dart run melos run test

# 3. Verifikasi visual di emulator:
#    a. Fresh install → harus tampil splash → onboarding → login
#    b. Install kedua kali → splash → langsung login (skip onboarding)
#    c. Sudah login → splash → langsung home
```

### Estimasi Effort
**M** (3 hari) — Desain UI onboarding membutuhkan perhatian estetika, animasi yang halus, dan pengelolaan state persisten.

---

## Tugas 2.3: Autentikasi Biometrik

### Deskripsi & Konteks
Menambahkan fitur login cepat menggunakan sidik jari (fingerprint) atau pengenalan wajah (Face ID) sebagai alternatif memasukkan password. Fitur ini meningkatkan keamanan dan kenyamanan pengguna secara signifikan pada aplikasi mobile SaaS.

### Lokasi Berkas
- **Package**: `packages/features_shared`
- **File baru yang harus dibuat**:
  - `packages/features_shared/lib/src/auth/data/biometric_auth_service.dart`
  - `packages/features_shared/lib/src/auth/presentation/biometric_login_screen.dart` (atau terintegrasi di login screen)
- **File yang harus dimodifikasi**:
  - `packages/features_shared/lib/src/auth/presentation/auth_notifier.dart` (tambah method biometric login)
  - `packages/features_shared/lib/src/settings/presentation/settings_screen.dart` (toggle enable/disable biometric)
  - `apps/main/pubspec.yaml` (tambah dependensi `local_auth`)
  - `apps/main/android/app/src/main/AndroidManifest.xml` (permission biometric)

### Langkah Eksekusi (Step-by-step)

#### Langkah 1: Tambahkan Dependensi
Di `packages/features_shared/pubspec.yaml`:
```yaml
dependencies:
  local_auth: ^2.3.0
```

#### Langkah 2: Buat Biometric Auth Service
```dart
// packages/features_shared/lib/src/auth/data/biometric_auth_service.dart
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class BiometricAuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Cek apakah device mendukung biometric
  Future<bool> isDeviceSupported() async {
    return await _localAuth.isDeviceSupported();
  }

  /// Cek apakah ada biometric yang terdaftar di device
  Future<bool> canCheckBiometrics() async {
    return await _localAuth.canCheckBiometrics;
  }

  /// Dapatkan daftar biometric yang tersedia
  Future<List<BiometricType>> getAvailableBiometrics() async {
    return await _localAuth.getAvailableBiometrics();
  }

  /// Authenticate menggunakan biometric
  Future<bool> authenticate({
    required String localizedReason,
  }) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } on PlatformException {
      return false;
    }
  }
}
```

#### Langkah 3: Konfigurasi Platform Native

**Android** (`apps/main/android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
```

**Android** — Tambahkan di `MainActivity.kt`:
```kotlin
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity: FlutterFragmentActivity() {
    // FlutterFragmentActivity diperlukan untuk dialog biometric
}
```

**iOS** (`apps/main/ios/Runner/Info.plist`):
```xml
<key>NSFaceIDUsageDescription</key>
<string>Kami menggunakan Face ID untuk login cepat dan aman.</string>
```

#### Langkah 4: Integrasikan dengan Auth Notifier
Tambahkan method baru di `AuthNotifier`:
```dart
Future<void> loginWithBiometric() async {
  state = const AuthLoading();

  final biometricService = ref.read(biometricAuthServiceProvider);
  final isSupported = await biometricService.isDeviceSupported();

  if (!isSupported) {
    state = const AuthError('Biometric tidak didukung di perangkat ini');
    return;
  }

  final authenticated = await biometricService.authenticate(
    localizedReason: 'Verifikasi identitas Anda untuk masuk',
  );

  if (authenticated) {
    // Ambil token tersimpan dari secure storage
    // dan verifikasi masih valid
    await checkCurrentUser();
  } else {
    state = const AuthError('Verifikasi biometric gagal');
  }
}
```

#### Langkah 5: Tambahkan Toggle di Settings
Di layar Settings, tambahkan opsi untuk mengaktifkan/menonaktifkan biometric login:
```dart
SwitchListTile(
  title: Text('Login Biometrik'),
  subtitle: Text('Gunakan sidik jari atau Face ID untuk masuk'),
  value: isBiometricEnabled,
  onChanged: (value) {
    // Simpan preferensi ke SharedPreferences
  },
),
```

#### Langkah 6: Tampilkan Opsi Biometric di Login Screen
Tambahkan tombol biometric di bawah form login:
```dart
if (isBiometricAvailable && isBiometricEnabled)
  IconButton(
    icon: const Icon(Icons.fingerprint, size: 48),
    onPressed: () => ref.read(authNotifierProvider.notifier).loginWithBiometric(),
  ),
```

### Batasan Arsitektur (Architectural Constraints)
- `BiometricAuthService` **harus** diletakkan di `packages/features_shared` (bukan `core`) karena ini adalah fitur yang spesifik ke auth flow.
- Biometric login **hanya boleh aktif** jika pengguna sudah pernah login dengan email/password sebelumnya (token tersimpan valid).
- Android `MainActivity` **harus** meng-extend `FlutterFragmentActivity` (bukan `FlutterActivity`) untuk mendukung dialog biometric native.
- Jangan menyimpan password pengguna di secure storage untuk biometric — gunakan token yang sudah ada.

### Cara Verifikasi
```bash
# 1. Analisis statis bersih
dart run melos run analyze

# 2. Unit test biometric service (mock local_auth)
dart run melos run test

# 3. Testing manual di device fisik (biometric tidak bisa di-test di emulator standar):
#    a. Login normal → aktifkan biometric di settings
#    b. Logout → di login screen, tekan ikon fingerprint
#    c. Verifikasi sidik jari → berhasil masuk tanpa password
#    d. Disable biometric di settings → ikon fingerprint hilang dari login
```

### Estimasi Effort
**M** (2 hari) — Integrasi plugin `local_auth` cukup langsung, namun membutuhkan konfigurasi platform native dan testing di device fisik.
