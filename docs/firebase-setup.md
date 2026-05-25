# 🔥 Panduan Integrasi Firebase Multi-Flavor

Dokumen ini menjelaskan cara menghubungkan proyek Flutter Starter ini
ke Firebase Console untuk mengaktifkan layanan FCM, Crashlytics, dan Analytics.

---

## Prasyarat

- [x] Akun Google dengan akses ke [Firebase Console](https://console.firebase.google.com/)
- [x] Firebase CLI terinstal (`npm install -g firebase-tools`)
- [x] FlutterFire CLI terinstal (`dart pub global activate flutterfire_cli`)
- [x] Project Flutter Starter sudah di-bootstrap (`dart run melos bootstrap`)

---

## Langkah 1: Buat Proyek Firebase

1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Klik "Add project" → beri nama (misal `your-app-main`)
3. Ikuti wizard hingga proyek terbuat
4. (Opsional) Buat proyek kedua untuk flavor `variant` (misal `your-app-variant`)

> **💡 Tips**: Jika kedua flavor berbagi backend yang sama, satu proyek Firebase
> dengan dua "Apps" (Android/iOS) sudah cukup.

---

## Langkah 2: Konfigurasi via FlutterFire CLI

### Untuk `apps/main`:
```bash
cd apps/main
flutterfire configure \
  --project=your-firebase-project-id \
  --platforms=android,ios \
  --android-package-name=id.rmq.app_main \
  --ios-bundle-id=id.rmq.appMain
```

### Untuk `apps/variant`:
```bash
cd apps/variant
flutterfire configure \
  --project=your-firebase-project-id-variant \
  --platforms=android,ios \
  --android-package-name=id.rmq.app_variant \
  --ios-bundle-id=id.rmq.appVariant
```

Perintah di atas akan:
- Mengunduh `google-services.json` (Android) dan `GoogleService-Info.plist` (iOS)
- Membuat file `lib/firebase_options.dart` di masing-masing app

---

## Langkah 3: Penempatan File Konfigurasi Native

### Android

File `google-services.json` hasil unduhan ditempatkan di:
- `apps/main/android/app/google-services.json`
- `apps/variant/android/app/google-services.json`

Pastikan plugin Google Services ditambahkan di `build.gradle.kts`:
```kotlin
// apps/main/android/app/build.gradle.kts
plugins {
    id("com.google.gms.google-services")
}
```

### iOS

Daftarkan `GoogleService-Info.plist` melalui Xcode:
1. Buka `apps/main/ios/Runner.xcworkspace` di Xcode
2. Klik kanan folder Runner → "Add Files to Runner..."
3. Pilih `GoogleService-Info.plist`
4. Centang "Copy items if needed"
5. Ulangi untuk `apps/variant`

---

## Langkah 4: Aktifkan Inisialisasi Firebase di Kode

Setelah `flutterfire configure` menghasilkan `firebase_options.dart`, aktifkan kode
yang saat ini ter-comment di `bootstrap.dart` masing-masing app:

### `apps/main/lib/bootstrap.dart`
```dart
// Uncomment baris ini:
import 'firebase_options.dart';

// Dan di dalam function bootstrap(), uncomment:
await FirebaseService.init(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

### Aktivasi FCM (Opsional)

Setelah Firebase Core aktif, tambahkan inisialisasi FCM di `bootstrap.dart`:
```dart
final fcm = FCMNotificationService();
await fcm.init(
  onForegroundMessage: (message) {
    debugPrint('Foreground: ${message.notification?.title}');
  },
  onMessageOpenedApp: (message) {
    debugPrint('Opened from notification: ${message.data}');
  },
);
```

---

## Langkah 5: Aktifkan Layanan Firebase

### Firebase Cloud Messaging (FCM)
1. Di Firebase Console → pilih proyek → Cloud Messaging
2. Untuk iOS: Upload APNs key dari Apple Developer Console
   - Buka [Apple Developer > Keys](https://developer.apple.com/account/resources/authkeys/list)
   - Buat key baru dengan APNs enabled
   - Upload `.p8` file di Firebase Console → Project Settings → Cloud Messaging → iOS

### Crashlytics (Opsional)
1. Di Firebase Console → Crashlytics → Setup
2. Tambah dependency: `firebase_crashlytics` di `packages/core/pubspec.yaml`
3. Ikuti instruksi setup Flutter Crashlytics

### Analytics
- Otomatis aktif saat Firebase Core diinisialisasi
- Tidak perlu konfigurasi tambahan

---

## Langkah 6: Verifikasi

```bash
# Build dan jalankan
cd apps/main && flutter run --dart-define=ENV=dev

# Cek log untuk memastikan Firebase terinitialisasi
# Anda harus melihat log: "Firebase initialized successfully"
# dan "FCM Token: <token_string>"
```

### Checklist Verifikasi
- [ ] App tidak crash saat launch (Firebase Core init berhasil)
- [ ] Log menampilkan `FCM Token: <token>`
- [ ] Kirim test notification dari Firebase Console → muncul di foreground
- [ ] Tap notification → app terbuka dan log `onMessageOpenedApp` tercetak

---

## ⚠️ Keamanan

- **JANGAN** commit file-file berikut ke Git:
  - `google-services.json`
  - `GoogleService-Info.plist`
  - `firebase_options.dart`

Tambahkan ke `.gitignore` jika belum ada:
```gitignore
# Firebase
**/google-services.json
**/GoogleService-Info.plist
**/firebase_options.dart
```

- Untuk CI/CD, simpan file-file ini sebagai **secret environment variable** atau gunakan mekanisme download dari secure storage (misal: GitHub Secrets + base64 encode/decode).

---

## Referensi

- [Firebase Flutter Setup Guide](https://firebase.google.com/docs/flutter/setup)
- [FlutterFire CLI Documentation](https://firebase.flutter.dev/docs/cli/)
- [Firebase Cloud Messaging Flutter](https://firebase.google.com/docs/cloud-messaging/flutter/client)
