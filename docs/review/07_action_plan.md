# Action Plan & Roadmap Iterasi (Setelah Perbaikan)

Dokumen ini memuat peta jalan taktis (*tactical roadmap*) dan hasil penyelesaian audit untuk membawa Flutter Starter Project ini ke kondisi seutuhnya siap produksi (*SaaS Production-Ready*).

---

## A. Temuan Kritis (🔥 Selesaikan Segera) — ✅ SEMUA TERSELESAIKAN (100% Selesai)

| # | Temuan | File / Lokasi | Dampak | Status |
| :-: | :--- | :--- | :--- | :---: |
| **1** | **Compile Error `RadioGroup`** | `apps/main/lib/features/settings/presentation/settings_screen.dart` | Kegagalan kompilasi total pada main app flavor. | ✅ LENGKAP |
| **2** | **Ketiadaan Generated `AppLocalizations`** | `packages/core/lib/src/l10n/` | 37 error analisis statis di seluruh workspace. | ✅ LENGKAP |
| **3** | **Kredensial Tidak Dikecualikan di Git** | Root `.gitignore` | Potensi kebocoran file `.env` dan `google-services.json`. | ✅ LENGKAP |

---

## B. Perbaikan Penting — Sprint 1 — ✅ SEMUA TERSELESAIKAN (100% Selesai)

Fokus pada penguatan arsitektur, standarisasi Riverpod generator, dan penyediaan infrastruktur penting SaaS (notifikasi push & database lokal):

| # | Item | Status | Solusi Teknis Yang Diterapkan |
| :-: | :--- | :---: | :--- |
| **1** | **Migrasi ke Riverpod Generator (`@riverpod`)** | ✅ LENGKAP | Seluruh provider klasik telah dimigrasikan penuh ke `@riverpod` generator untuk efisiensi dan keamanan tipe data. |
| **2** | **Integrasi Riil Firebase Core & FCM** | ✅ LENGKAP | Layanan push notification FCM multi-platform kini aktif riil secara native per flavor. |
| **3** | **Integrasi Drift Database (Offline Cache)** | ✅ LENGKAP | Basis data offline SQLite modular via **Drift** terpasang lengkap dengan TTL auto-expiration caching, menggantikan Isar. |

---

## C. Peningkatan — Sprint 2 — ✅ SEMUA TERSELESAIKAN (100% Selesai)

Fokus pada peningkatan keamanan sesi, UI/UX premium, dan penanganan biometrik:

| # | Item | Status | Solusi Teknis Yang Diterapkan |
| :-: | :--- | :---: | :--- |
| **1** | **Auto-Refresh Token (401 Interceptor)** | ✅ LENGKAP | `TokenRefreshInterceptor` berbasis `QueuedInterceptor` Dio menangani refresh token concurrent asinkron otomatis. |
| **2** | **Splash Screen & Onboarding UI** | ✅ LENGKAP | Splash screen animasi premium dan onboarding intro 3-page interaktif terintegrasi rapi. |
| **3** | **Autentikasi Biometrik (Sidik Jari/Face ID)** | ✅ LENGKAP | Keamanan login cepat via pemindaian biometrik native terintegrasi penuh lewat paket `local_auth`. |

---

## D. Advanced Features — Backlog Lanjutan — ✅ SEMUA TERSELESAIKAN (100% Selesai)

Peta jalan jangka panjang kini telah **sukses dituntaskan** lebih cepat dari estimasi:

- **Mason CLI Bricks [✅ LENGKAP]**: Otomasi pembuatan struktur folder Clean Architecture per fitur lewat brick `feature` di `/bricks/feature/`.
- **Network Certificate Pinning [✅ LENGKAP]**: Proteksi MITM aktif riil via `CertificatePinning` pada `DioClient`.
- **Firebase Performance Monitoring & Crashlytics [✅ LENGKAP]**: Tracking latensi UI/jaringan dan error framework terintegrasi di level rilis.

---

## E. Dokumen Baru yang Telah Dibuat (100% Selesai)

1. **`CLAUDE.md` (Panduan Pintas untuk AI Agent) [✅ SELESAI]**: Terpasang di root repositori untuk memandu AI Agent baru agar 100% produktif dan aman.
2. **`docs/firebase-setup.md` (Langkah Integrasi Firebase) [✅ SELESAI]**: Panduan konfigurasi konsol Google Firebase dan platform native untuk flavor `main` dan `variant`.
3. **`CHANGELOG.md` [✅ SELESAI]**: Log riwayat perilisan dan perbaikan arsitektural.

---

## F. Saran Khusus untuk Operasional Proyek

1. **Gunakan Mason CLI**: Wajibkan kontributor menggunakan `mason make feature` saat menambah modul baru demi konsistensi kode 100%.
2. **Standardisasi CI/CD**: Tambahkan `melos run format:check`, `melos run analyze`, dan `melos run test` sebagai quality gates otomatis pada pull requests.
3. **Rotasi Sertifikat Pinning**: Siapkan minimal dua public key hash (SHA256 fingerprint) di `CertificatePinning` dan catat prosedur pembaruan sidik jari saat sertifikat server di-renew.

---

## G. Estimasi Total Effort

- **Sisa waktu pengerjaan backlog**: **0 Hari Kerja (Seutuhnya Siap Produksi / SaaS Production-Ready)**
