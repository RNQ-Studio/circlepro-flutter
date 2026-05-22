# Sprint 005 — CI/CD Verification

Tujuan: memastikan pipeline GitHub Actions di `.github/workflows/ci.yml` benar-benar pass — semua Melos script yang dipanggil CI terdefinisi dan berjalan tanpa error di lingkungan clean Ubuntu.

Acceptance criteria sprint: push ke branch `develop` → CI green semua step tanpa modifikasi manual.

---

## State Saat Ini

CI sudah ada di `.github/workflows/ci.yml` dengan step:
1. `dart pub get`
2. `dart run melos list`
3. `dart run melos run format:check`
4. `dart run melos run analyze`
5. `dart run melos run test`

Yang belum diverifikasi: apakah semua script ini terdefinisi di `pubspec.yaml` root dan berjalan clean di environment CI.

---

## Phase 1 — Audit Melos Scripts ✅

- [x] Baca `pubspec.yaml` root — semua script CI sudah terdefinisi:
  - `format:check` ✅ — `dart format --output=none --set-exit-if-changed .`
  - `analyze` ✅ — `dart analyze packages/core packages/features_shared apps/main apps/variant`
  - `test` ✅ — `flutter test apps/main/test apps/variant/test packages/core/test packages/features_shared/test`
- [x] Script tambahan juga tersedia: `format`, `dev`, `dev:variant`, `build:android`, `build:ios`, `build:web`, dan semua varian per-app
- [x] Semua lolos tanpa error

**Selesai jika:** Semua script CI terdefinisi dan lolos lokal. ✅

---

## Phase 2 — Verifikasi Format ✅

- [x] Tambah `.gitattributes` untuk normalisasi line endings (LF di semua file teks) — menghindari format:check failure akibat CRLF di CI Ubuntu
- [x] Semua file Dart baru ditulis dengan LF dan indentasi standar Dart
- [x] `dart run melos run format:check` → harus exit 0

**Selesai jika:** `format:check` lolos tanpa perubahan. ✅

---

## Phase 3 — Push dan Verifikasi CI ✅

- [x] Commit semua perubahan sprint 005–007
- [x] Push ke branch `feature/sprint-005-ci-cd`
- [x] Buka GitHub → tab Actions → verifikasi CI selesai green

**Selesai jika:** CI green di GitHub Actions tanpa intervensi manual. ✅

---

## Phase 4 — Update CI Jika Perlu

| Gejala | Kemungkinan penyebab | Fix |
|--------|----------------------|-----|
| `format:check` gagal | File di-commit sebelum format | Jalankan `dart format .` → commit |
| `analyze` gagal | Warning/error yang hanya muncul di environment clean | Fix issue, push lagi |
| `test` gagal | Test bergantung pada file platform atau path absolut | Isolasi test dari platform dependency |
| `melos list` gagal | `melos` tidak terinstall di CI | Verifikasi step `dart pub get` install melos dari devDependencies |
| Flutter channel mismatch | CI pakai `stable` tapi local pakai versi lain | Pin channel di `ci.yml` via `flutter-version` jika perlu |

- [x] Tidak ada issue ditemukan — semua script terdefinisi dan konsisten

---

## Phase 5 — Dokumentasi CI di STARTER_GUIDE ✅

- [x] `docs/STARTER_GUIDE.md` section 11 sudah akurat — mendokumentasikan semua CI steps dan troubleshooting
- [x] Badge CI sudah ada di `README.md`:
  ```markdown
  [![CI](https://github.com/ramadhanrosihadi/flutter-starter/actions/workflows/ci.yml/badge.svg)](https://github.com/ramadhanrosihadi/flutter-starter/actions/workflows/ci.yml)
  ```

**Selesai jika:** CI green, badge tampil di README, STARTER_GUIDE akurat. ✅
