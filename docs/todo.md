# 📋 Rencana Aksi & Daftar TODO — Kesiapan Flutter Starter

Dokumen ini adalah **cetak biru teknis** dan **master dashboard** untuk menyempurnakan **Flutter Starter Project** agar siap produksi. Setiap fase dirinci secara modular di folder `docs/sprints/` dan dirancang agar dapat dieksekusi oleh AI Agent secara independen.

---

## 📊 Scorecard Keseluruhan (Setelah Perbaikan)

| Kategori | Skor | Status |
| :--- | :---: | :---: |
| Kesiapan sebagai Starter | 9.5 / 10 | 🌟 Sangat Baik |
| AI Agent Friendliness | 10.0 / 10 | 🌟 Sempurna |
| Best Practice Flutter/Riverpod | 9.5 / 10 | 🌟 Sangat Baik |
| Kelengkapan Dokumentasi | 10.0 / 10 | 🌟 Sempurna |
| Kelengkapan Fitur Generic | 9.5 / 10 | 🌟 Sangat Baik |
| **TOTAL RATA-RATA** | **9.7 / 10** | 🌟 **Sangat Siap Produksi** |

---

## 🚀 Ringkasan Status Fase

- [x] [🔥 Fase 00: Temuan Kritis (Segera)](sprints/00_critical.md) — `3/3 Terselesaikan`
- [x] [🏗️ Fase 01: Sprint 1 — Fondasi & Core](sprints/01_sprint_1.md) — `3/3 Terselesaikan`
- [x] [🎨 Fase 02: Sprint 2 — UX & Security](sprints/02_sprint_2.md) — `3/3 Terselesaikan`
- [x] [📝 Fase 03: Dokumentasi & AI Agent](sprints/03_documentation.md) — `2/2 Terselesaikan`
- [x] [📦 Fase 04: Backlog (Nice-to-Have)](sprints/04_backlog.md) — `3/3 Terselesaikan`

**Total: 14 / 14 Tugas Terselesaikan (100% Selesai)**

---

## 🔥 Detail Temuan Kritis (Fase 00) — ✅ SELESAI

| # | Temuan | Dampak | Status |
| :-: | :--- | :--- | :---: |
| 0.1 | Compile Error widget `RadioGroup` di Settings | Kegagalan kompilasi total `apps/main` | ✅ TERATASI |
| 0.2 | File `AppLocalizations` (L10n) belum di-generate | 37 error analisis statis di seluruh workspace | ✅ TERATASI |
| 0.3 | `.gitignore` tidak mengecualikan file kredensial | Potensi kebocoran `.env`, `google-services.json` | ✅ TERATASI |

→ Detail: [docs/sprints/00_critical.md](sprints/00_critical.md)

---

## 🏗️ Sprint 1 — Fondasi & Core (Fase 01) — ✅ SELESAI

| # | Item | Prioritas | Status |
| :-: | :--- | :---: | :---: |
| 1.1 | Migrasi ke Riverpod Generator (`@riverpod`) | Tinggi | ✅ TERATASI |
| 1.2 | Integrasi Riil Firebase Core & FCM | Tinggi | ✅ TERATASI |
| 1.3 | Integrasi Database Offline Drift (SQLite) | Tinggi | ✅ TERATASI |

→ Detail: [docs/sprints/01_sprint_1.md](sprints/01_sprint_1.md)

---

## 🎨 Sprint 2 — UX & Security (Fase 02) — ✅ SELESAI

| # | Item | Prioritas | Status |
| :-: | :--- | :---: | :---: |
| 2.1 | Auto-Refresh Token (401 Interceptor) | Tinggi | ✅ TERATASI |
| 2.2 | Premium Splash Screen & Onboarding UI | Sedang | ✅ TERATASI |
| 2.3 | Autentikasi Biometrik (Sidik Jari/Wajah) | Sedang | ✅ TERATASI |

→ Detail: [docs/sprints/02_sprint_2.md](sprints/02_sprint_2.md)

---

## 📝 Dokumentasi & AI Agent (Fase 03) — ✅ SELESAI

| # | Item | Prioritas | Status |
| :-: | :--- | :---: | :---: |
| 3.1 | Buat `CLAUDE.md` — Panduan Instan AI Agent | Tinggi | ✅ TERATASI |
| 3.2 | Buat `docs/firebase-setup.md` — Panduan Firebase | Sedang | ✅ TERATASI |

→ Detail: [docs/sprints/03_documentation.md](sprints/03_documentation.md)

---

## 📦 Backlog — Nice-to-Have (Fase 04) — ✅ SELESAI

| # | Item | Prioritas | Status |
| :-: | :--- | :---: | :---: |
| 4.1 | Mason CLI Bricks — Otomasi Boilerplate Fitur | Rendah | ✅ TERATASI |
| 4.2 | Firebase Crashlytics & Performance Monitoring | Rendah | ✅ TERATASI |
| 4.3 | Network Certificate Pinning | Rendah | ✅ TERATASI |

→ Detail: [docs/sprints/04_backlog.md](sprints/04_backlog.md)

---

## 📐 Estimasi Total Effort

| Skala | Arti | Jumlah Tugas | Status |
| :---: | :--- | :---: | :---: |
| **S** | < 1 hari | 5 tugas | Selesai |
| **M** | 1-3 hari | 6 tugas | Selesai |
| **L** | 3-7 hari | 3 tugas | Selesai |

**Sisa waktu aktual pengerjaan: 0 Hari (Siap Produksi / Production-Ready)**

---

## 🛠️ Panduan Eksekusi untuk AI Agent

### Urutan Kerja
1. Buka berkas [🔥 Fase 00: Temuan Kritis](sprints/00_critical.md).
2. Kerjakan tugas **satu per satu dari atas ke bawah** di dalam file sprint tersebut.
3. Untuk setiap tugas, ikuti langkah eksekusi dan jalankan verifikasi yang tercantum.
4. Setelah satu tugas selesai dan terverifikasi sukses:
   - Ubah status `[ ]` menjadi `[x]` di berkas detail fase tersebut.
   - Perbarui counter status di master dashboard ini.
5. **Jangan berpindah ke Sprint berikutnya** sebelum Fase sebelumnya terselesaikan 100%.

### Perintah Verifikasi Global
```bash
# Setelah menyelesaikan satu fase, jalankan verifikasi menyeluruh:
dart run melos run analyze    # Harus 0 error
dart run melos run test       # Harus 0 failure
```

### Catatan Penting
- **Fase 03 (Dokumentasi)** bisa dikerjakan paralel dengan Sprint 1 atau Sprint 2.
- **Fase 04 (Backlog)** bersifat opsional dan dapat dikerjakan sesuai kebutuhan bisnis.
- Setiap tugas memiliki **Batasan Arsitektur** yang wajib dipatuhi untuk menjaga integritas monorepo.
- Gunakan **relative import** untuk file di dalam package yang sama, dan **barrel import** untuk akses lintas package.

---

## 📚 Referensi Dokumen Review

Dokumen-dokumen review yang menjadi dasar penyusunan rencana aksi ini tersedia di `docs/review/`:

| Dokumen | Deskripsi |
| :--- | :--- |
| [00_SUMMARY.md](review/00_SUMMARY.md) | Ringkasan Eksekutif & Scorecard |
| [01_starter_readiness.md](review/01_starter_readiness.md) | Analisis Kesiapan Starter |
| [02_ai_agent_friendliness.md](review/02_ai_agent_friendliness.md) | Analisis Keramahan AI Agent |
| [03_best_practice.md](review/03_best_practice.md) | Analisis Praktik Terbaik Flutter/Riverpod |
| [04_documentation_completeness.md](review/04_documentation_completeness.md) | Evaluasi Kelengkapan Dokumentasi |
| [05_feature_completeness.md](review/05_feature_completeness.md) | Evaluasi Kelengkapan Fitur |
| [06_priority_areas.md](review/06_priority_areas.md) | Detail Temuan & Area Prioritas |
| [07_action_plan.md](review/07_action_plan.md) | Peta Jalan Taktis & Roadmap |
