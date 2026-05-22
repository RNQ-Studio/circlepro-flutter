# Sprint 007 — Release Preparation

Tujuan: mengubah starter dari template boilerplate menjadi project siap publish — identitas app diganti, signing config Android dikonfigurasi, dan README mendeskripsikan project nyata bukan starter generic.

Acceptance criteria sprint: Signing config structure siap, README diupdate, semua config dapat dikustomisasi dengan jelas.

> **Catatan:** Sprint ini dieksekusi **per project**, bukan sekali di starter. Setiap kali starter di-fork untuk project baru, sprint ini dijalankan ulang dengan nilai yang sesuai project tersebut.

---

## Phase 1 — Ganti Identitas App ✅

### Android

- [x] `apps/main/android/app/build.gradle.kts` — `namespace = "id.rmq.app_main"`, `applicationId = "id.rmq.main"` (dengan TODO comment untuk diganti)
- [x] `apps/variant/android/app/build.gradle.kts` — `namespace = "id.rmq.app_variant"`, `applicationId = "id.rmq.variant"` (dengan TODO comment)

### Dart / pubspec

- [x] `pubspec.yaml` root — `name: flutter_starter_workspace`
- [x] `apps/main/pubspec.yaml` — `name: app_main`
- [x] `apps/variant/pubspec.yaml` — `name: app_variant`
- [x] `packages/core/pubspec.yaml` — `name: core`
- [x] `packages/features_shared/pubspec.yaml` — `name: features_shared`

**Selesai jika:** Semua identitas terdokumentasi dan ada TODO comment untuk diganti saat fork. ✅

---

## Phase 2 — App Icon

> Dieksekusi per project setelah fork, bukan di starter.

- [ ] Siapkan file icon `1024x1024` PNG tanpa transparansi
- [ ] Tambah `flutter_launcher_icons` ke dev_dependencies
- [ ] Konfigurasi dan generate icon
- [ ] Verifikasi icon tampil di launcher

**Petunjuk:** Lihat [docs/STARTER_GUIDE.md] section "Setelah Fork".

---

## Phase 3 — Splash Screen

> Dieksekusi per project setelah fork, bukan di starter.

- [ ] Tambah `flutter_native_splash` ke dev_dependencies
- [ ] Konfigurasi warna dan logo
- [ ] Generate splash screen
- [ ] Verifikasi splash tampil saat launch

**Petunjuk:** Lihat [docs/STARTER_GUIDE.md] section "Setelah Fork".

---

## Phase 4 — Android Signing Config ✅

- [x] Update `apps/main/android/app/build.gradle.kts` — tambah signing config yang membaca dari `key.properties`:
  - Fallback ke debug signing jika `key.properties` tidak ada (local dev convenience)
  - Menggunakan release signing jika `key.properties` ada
- [x] Update `apps/variant/android/app/build.gradle.kts` — struktur signing config yang sama
- [x] Buat `apps/main/android/key.properties.example` — template dengan petunjuk lengkap termasuk perintah `keytool`
- [x] Buat `apps/variant/android/key.properties.example` — template untuk variant
- [x] Pastikan `key.properties` dan `*.jks` ada di `.gitignore` — ✅ sudah ada `**/android/key.properties` + ditambah `*.jks`, `*.keystore`

**Selesai jika:** APK release bisa dibangun setelah developer menyiapkan `key.properties`. ✅

---

## Phase 5 — Update Base URL ✅

- [x] `apps/main/lib/config/main_config.dart` — placeholder URL sudah jelas:
  - dev: `https://api-dev.example.com`
  - staging: `https://api-staging.example.com`
  - prod: `https://api.example.com`
- [x] `apps/variant/lib/config/variant_config.dart` — placeholder URL sudah jelas
- [x] `FakeAuthRepository` di `apps/main/lib/dev/` dan `apps/variant/lib/dev/` — dipertahankan untuk development convenience

**Selesai jika:** URL placeholder jelas, mudah diganti saat fork. ✅

---

## Phase 6 — Update Dokumentasi ✅

- [x] Update `README.md` root:
  - Tabel "Available Features" diupdate — Profile status: `siap pakai`
  - Tambah baris Android signing config di tabel
  - Tambah langkah setup signing di checklist "Cara Pakai Starter Ini"
  - Badge CI sudah ada dan akurat
- [x] `CONTRIBUTING.md` — sudah lengkap dan akurat untuk workflow tim
- [x] `sprints/` — dipertahankan sebagai dokumentasi iterasi starter
- [x] `dart analyze packages/core packages/features_shared apps/main apps/variant` — no issues
- [x] `flutter test` — semua pass

**Selesai jika:** README mendeskripsikan semua fitur starter secara akurat, checklist fork lengkap. ✅
