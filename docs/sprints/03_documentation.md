# 📝 Fase 03: Dokumentasi & AI Agent Guide

> Dokumen ini berisi outline dan tugas pembuatan dokumen panduan baru untuk meningkatkan developer experience dan AI Agent friendliness:
> 1. Pembuatan `CLAUDE.md` — Panduan Instan untuk AI Agent
> 2. Pembuatan `docs/firebase-setup.md` — Panduan Integrasi Firebase Multi-Flavor
>
> **Prasyarat**: Idealnya dikerjakan setelah [Fase 01: Sprint 1](01_sprint_1.md) selesai (terutama integrasi Firebase), namun bisa dikerjakan paralel.

---

## Daftar Tugas

- [x] [Tugas 3.1: Buat `CLAUDE.md` (Panduan Instan AI Agent)](#tugas-31-buat-claudemd-panduan-instan-ai-agent)
- [x] [Tugas 3.2: Buat `docs/firebase-setup.md` (Panduan Integrasi Firebase)](#tugas-32-buat-docsfirebase-setupmd-panduan-integrasi-firebase)

---

## Tugas 3.1: Buat `CLAUDE.md` (Panduan Instan AI Agent)

### Deskripsi & Konteks
Proyek ini dirancang agar ramah AI Agent, namun saat ini **tidak ada berkas panduan khusus untuk AI** yang menyediakan ringkasan perintah instan, aturan arsitektur, dan konvensi penulisan kode. Dokumen `CLAUDE.md` (yang juga dikenal sebagai `AGENTS.md`) diletakkan di root repositori dan menjadi referensi pertama yang dibaca oleh AI Agent seperti Claude, Gemini, atau GPT saat mulai bekerja di proyek ini.

### Lokasi Berkas
- **File baru**: Root repositori `CLAUDE.md`

### Langkah Eksekusi (Step-by-step)

#### Langkah 1: Buat File `CLAUDE.md` di Root
Buat file `CLAUDE.md` di root repositori dengan konten berikut (sesuaikan dengan kondisi proyek saat ini):

```markdown
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
│   └── features_shared/    ← Fitur bersama (auth, profile, settings, notifications)
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
dart run melos bootstrap

# Generate file localization (L10n)
cd packages/core && flutter gen-l10n

# Generate file code (Riverpod, Isar, Freezed, dll.)
dart run melos exec -- "dart run build_runner build --delete-conflicting-outputs"

# Analisis statis seluruh workspace
dart run melos run analyze

# Format kode
dart run melos run format

# Jalankan semua test
dart run melos run test

# Jalankan app main (dev environment)
cd apps/main && flutter run --dart-define=ENV=dev

# Jalankan app variant (dev environment)
cd apps/variant && flutter run --dart-define=ENV=dev

# Build APK release
cd apps/main && flutter build apk --release --dart-define=ENV=prod --obfuscate --split-debug-info=build/debug-info
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
    └── notifiers/      ← Riverpod Notifier/AsyncNotifier
```

---

## 📋 Konvensi Penulisan Kode

### State Management (Riverpod)
- Gunakan anotasi `@riverpod` dari `riverpod_annotation`
- Notifier harus meng-extend `_$NamaNotifier` (generated)
- Provider yang harus persisten: gunakan `@Riverpod(keepAlive: true)`
- Akses di `build()`: gunakan `ref.watch()`
- Akses di method aksi: gunakan `ref.read()`

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
- Network error ditangani oleh `DioClient` → dipetakan ke `AppException`
- Presentation layer menangani error melalui `AsyncValue.when()` pattern

---

## ⚙️ Environment & Flavor

| Konsep | Penjelasan |
| :--- | :--- |
| **Flavor** | Aplikasi mana yang dijalankan (`apps/main` vs `apps/variant`) |
| **Environment** | Backend mana yang dipakai (`dev`, `staging`, `prod`) via `--dart-define=ENV=...` |

---

## ⚠️ Hal-Hal yang HARUS DIHINDARI

1. ❌ Jangan import file dari `apps/main` ke `apps/variant` atau sebaliknya
2. ❌ Jangan hardcode URL API — gunakan `AppConfig` / `MainConfig` / `VariantConfig`
3. ❌ Jangan simpan data sensitif (token, password) di `SharedPreferences` — gunakan `SecureStorageService`
4. ❌ Jangan commit file `google-services.json`, `.env`, atau `*.jks` ke Git
5. ❌ Jangan menulis provider secara manual (vanilla) — gunakan `@riverpod` generator
```

#### Langkah 2: Verifikasi Akurasi Konten
Setelah membuat file, pastikan semua perintah CLI, aturan arsitektur, dan konvensi yang dicantumkan **sesuai dengan kondisi aktual proyek saat ini**. Update konten jika ada perubahan dari Sprint 0 dan Sprint 1.

#### Langkah 3: Tambahkan Referensi di README.md
Di `README.md` root, tambahkan link ke `CLAUDE.md`:
```markdown
## 🤖 Panduan untuk AI Agent
Lihat [CLAUDE.md](CLAUDE.md) untuk panduan lengkap bagi AI Agent yang bekerja di proyek ini.
```

### Batasan Arsitektur (Architectural Constraints)
- File `CLAUDE.md` **harus** diletakkan di root repositori (bukan di `docs/`) karena AI Agent seperti Claude secara default mencari file ini di root.
- Konten harus **ringkas dan to-the-point** — AI Agent membutuhkan informasi yang bisa langsung dieksekusi, bukan penjelasan panjang.
- Jika proyek memiliki aturan yang berubah-ubah antar sprint, pastikan `CLAUDE.md` selalu di-update setiap akhir sprint.

### Cara Verifikasi
```bash
# Pastikan file ada di root
ls CLAUDE.md

# Pastikan isi file lengkap dan tidak ada placeholder
cat CLAUDE.md | head -50
```

### Estimasi Effort
**S** (< 1 hari) — Penulisan dokumentasi berdasarkan informasi yang sudah ada.

---

## Tugas 3.2: Buat `docs/firebase-setup.md` (Panduan Integrasi Firebase)

### Deskripsi & Konteks
Saat ini tidak ada dokumentasi langkah-langkah integrasi Firebase untuk proyek ini. Developer yang fork repositori ini tidak memiliki panduan cara menghubungkan aplikasi ke Firebase Console, mengunduh kredensial, dan mengaktifkan layanan seperti FCM, Crashlytics, dan Analytics. Dokumen ini menjadi pelengkap penting setelah integrasi Firebase riil di Sprint 1.

### Lokasi Berkas
- **File baru**: `docs/firebase-setup.md`

### Langkah Eksekusi (Step-by-step)

#### Langkah 1: Buat File `docs/firebase-setup.md`
Tulis dokumen panduan dengan outline berikut:

```markdown
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

---

## Langkah 2: Konfigurasi via FlutterFire CLI

### Untuk `apps/main`:
```bash
cd apps/main
flutterfire configure \
  --project=your-firebase-project-id \
  --platforms=android,ios \
  --android-package-name=com.yourcompany.main \
  --ios-bundle-id=com.yourcompany.main
```

### Untuk `apps/variant`:
```bash
cd apps/variant
flutterfire configure \
  --project=your-firebase-project-id-variant \
  --platforms=android,ios \
  --android-package-name=com.yourcompany.variant \
  --ios-bundle-id=com.yourcompany.variant
```

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

---

## Langkah 4: Aktifkan Layanan Firebase

### Firebase Cloud Messaging (FCM)
1. Di Firebase Console → pilih proyek → Cloud Messaging
2. Untuk iOS: Upload APNs key dari Apple Developer Console

### Crashlytics
1. Di Firebase Console → Crashlytics → Setup
2. Ikuti instruksi untuk mengaktifkan

### Analytics
- Otomatis aktif saat Firebase Core diinisialisasi

---

## Langkah 5: Verifikasi

```bash
# Build dan jalankan
cd apps/main && flutter run --dart-define=ENV=dev

# Cek log untuk memastikan Firebase terinitialisasi
# Anda harus melihat log: "Firebase initialized successfully"
# dan "FCM Token: <token_string>"
```

---

## ⚠️ Keamanan

- **JANGAN** commit `google-services.json` atau `GoogleService-Info.plist` ke Git
- File-file ini sudah ditambahkan ke `.gitignore`
- Untuk CI/CD, simpan file ini sebagai secret environment variable
```

#### Langkah 2: Sesuaikan dengan Implementasi Aktual
Setelah Sprint 1 (Tugas 1.2 Integrasi Firebase) selesai, review dan sesuaikan panduan ini dengan konfigurasi aktual yang digunakan di proyek.

#### Langkah 3: Tambahkan Referensi
Di `docs/STARTER_GUIDE.md`, tambahkan link ke `docs/firebase-setup.md`:
```markdown
## Firebase Setup
Untuk integrasi Firebase, lihat [Panduan Firebase Setup](firebase-setup.md).
```

### Batasan Arsitektur (Architectural Constraints)
- Dokumen harus berada di folder `docs/` sesuai konvensi dokumentasi proyek.
- Panduan harus mencakup **kedua flavor** (`main` dan `variant`) secara eksplisit.
- Jangan cantumkan project ID atau package name riil — gunakan placeholder yang jelas.

### Cara Verifikasi
```bash
# Pastikan file ada
ls docs/firebase-setup.md

# Pastikan konten tidak kosong
wc -l docs/firebase-setup.md
```

### Estimasi Effort
**S** (< 1 hari) — Penulisan dokumentasi berbasis outline yang sudah jelas.
