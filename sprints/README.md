# Sprints

Direktori ini berisi **dokumen perencanaan** yang dibuat sebelum eksekusi, lalu dijalankan menggunakan Claude Code. File-file ini bukan to-do list untuk dikerjakan secara manual — seluruh implementasinya sudah selesai dan hasilnya ada di codebase.

File sprint bisa dijadikan referensi untuk memahami keputusan desain dan urutan pembangunan starter ini, atau sebagai template untuk merencanakan sprint serupa di project lain.

---

## Daftar Sprint

| Sprint | File | Tujuan | Acceptance Criteria |
|--------|------|--------|---------------------|
| 001 | [001_setup.md](001_setup.md) | Fondasi monorepo | Kedua app (`main` & `variant`) bisa di-run tanpa error |
| 002 | [002_feature_settings.md](002_feature_settings.md) | Fitur Settings | Theme & language switch bekerja real-time, tersimpan antar sesi |
| 003 | [003_l10n.md](003_l10n.md) | L10n end-to-end | Ganti bahasa di Settings → seluruh teks UI berubah tanpa restart |
| 004 | [004_testing.md](004_testing.md) | Unit & widget tests | `flutter test` dari root pass, coverage happy path & error path |
| 005 | [005_ci_cd.md](005_ci_cd.md) | CI/CD verification | Push ke branch → GitHub Actions CI green semua step |
| 006 | [006_profile_feature.md](006_profile_feature.md) | Fitur Profile | Profile screen tampil di kedua app, data dari sesi auth |
| 007 | [007_release_prep.md](007_release_prep.md) | Release preparation | Identitas app terganti, signing config siap, README diupdate |
| 008 | [008_home_screen.md](008_home_screen.md) | Home screen apps/main | Header user + grid 15 menu tampil, tap menu memunculkan SnackBar |
| 009 | [009_ui_gallery.md](009_ui_gallery.md) | UI Component Gallery | Menu "UI Gallery" di Home membuka 8 layar demo interaktif tanpa error |

---

## Ringkasan per Sprint

### Sprint 001 — Project Setup
Membangun fondasi monorepo dengan struktur Melos workspace. Mencakup setup `apps/main`, `apps/variant`, `packages/core`, dan `packages/features_shared` dengan dependency utama (Riverpod, Dio, GoRouter, dll).

### Sprint 002 — Feature: Settings
Menambahkan fitur Settings ke kedua app — theme (light/dark/system) dan language (Indonesia/English) dengan persistent storage via `SharedPreferences`.

### Sprint 003 — L10n End-to-End
Menghubungkan locale switching ke UI nyata. Semua teks hardcode diganti dengan key `AppLocalizations` sehingga ganti bahasa di Settings langsung mengubah seluruh teks app.

### Sprint 004 — Testing
Menambahkan test bermakna: unit test untuk repository, notifier, dan usecase; widget test untuk screen. Bukan sekadar smoke test, tapi mencakup happy path dan error path.

### Sprint 005 — CI/CD Verification
Memastikan pipeline GitHub Actions pass di environment clean Ubuntu. Verifikasi semua Melos script (`format:check`, `analyze`, `test`) terdefinisi dan berjalan tanpa error.

### Sprint 006 — Profile Feature
Implementasi fitur Profile dengan full Clean Architecture: domain (entity, repository, usecase), data layer, dan presentation (Riverpod provider, screen). Ditampilkan di kedua app dengan data dari sesi auth yang sudah ada.

### Sprint 007 — Release Preparation
Persiapan sebelum publish — ganti identitas app (`applicationId`, `namespace`), tambah template `key.properties` untuk Android signing, dan update README project. Sprint ini dijalankan ulang setiap kali starter di-fork untuk project baru.

### Sprint 008 — Home Screen (apps/main)
Mengganti `HomeScreen` stub di `apps/main` dengan tampilan nyata: header informasi pengguna (data fake/konstanta) dan grid 15 menu navigasi dengan ikon dan warna beragam. Tap menu menampilkan SnackBar stub.

### Sprint 009 — UI Component Gallery
Menambahkan UI Component Gallery ke `apps/main` — mini showcase interaktif berisi 8 layar demo: Dialog & Popup, Form & Input, Cards & Lists, Navigation & Tab, Loading & Empty State, Animation, Feedback & Input, dan Utilities. Dibangun tanpa dependency baru; shimmer diimplementasi manual via `ShaderMask`. Seluruh state UI lokal menggunakan `StatefulWidget` + `setState`.

---

## Catatan Sprint 007

Sprint 007 (Release Preparation) bersifat berbeda dari sprint lainnya — dirancang untuk dijalankan ulang setiap kali starter ini di-fork menjadi project baru, bukan hanya sekali di starter.
