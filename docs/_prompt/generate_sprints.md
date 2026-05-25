Kamu adalah senior AI Agent pengembang mobile (Flutter & Dart Expert).

Tugas utama kamu adalah menganalisis seluruh dokumen review yang ada di dalam folder `docs/review/` pada project Flutter Starter ini. Setelah memahami konteksnya secara mendalam, kamu harus menyusun rencana aksi teknis yang didelegasikan secara modular ke dalam beberapa berkas terpisah di folder `docs/sprints/`, agar **sangat mudah dibaca dan dieksekusi oleh AI Agent berikutnya secara independen**.

### DOKUMEN YANG HARUS DIANALISIS:
Baca dan analisis dokumen-dokumen berikut di `docs/review/` secara berurutan:
1. `docs/review/00_SUMMARY.md` (Ringkasan Eksekutif & Scorecard)
2. `docs/review/01_starter_readiness.md` (Analisis Kesiapan Starter)
3. `docs/review/02_ai_agent_friendliness.md` (Analisis Keramahan terhadap AI Agent)
4. `docs/review/03_best_practice.md` (Analisis Praktik Terbaik Flutter/Riverpod)
5. `docs/review/04_documentation_completeness.md` (Evaluasi Kelengkapan Dokumentasi)
6. `docs/review/05_feature_completeness.md` (Evaluasi Kelengkapan Fitur)
7. `docs/review/06_priority_areas.md` (Detail Temuan & Area Prioritas)
8. `docs/review/07_action_plan.md` (Peta Jalan Taktis & Roadmap Iterasi)

### RANCANGAN STRUKTUR OUTPUT:
Kamu harus membuat dan mengatur file-file berikut di dalam direktori `docs/`:

1. **`docs/todo.md` (Master Dashboard)**
   Berisi tabel ringkasan status kelulusan project, daftar checklist utama yang merujuk langsung ke file sprint masing-masing di dalam folder `docs/sprints/`, serta instruksi global cara menggunakan dokumen ini.

2. **`docs/sprints/00_critical.md`**
   Berisi spesifikasi teknis dan instruksi langkah kerja detail untuk menyelesaikan bug kompilasi kritis, error static analysis l10n, dan kerentanan `.gitignore` kredensial.

3. **`docs/sprints/01_sprint_1.md`**
   Berisi spesifikasi detail untuk Sprint 1 (Boilerplate Riverpod Generator `@riverpod`, Integrasi Riil Firebase Core & FCM, serta Database Offline Isar).

4. **`docs/sprints/02_sprint_2.md`**
   Berisi spesifikasi detail untuk Sprint 2 (Auto-Refresh Token Dio Interceptor, Premium Splash & Onboarding, Biometric Auth).

5. **`docs/sprints/03_documentation.md`**
   Berisi outline dan tugas pembuatan panduan baru seperti `CLAUDE.md` untuk panduan AI Agent instan dan panduan setup Firebase.

6. **`docs/sprints/04_backlog.md`**
   Berisi backlog jangka panjang seperti otomasi kode Mason CLI Bricks, Firebase Crashlytics & Performance, dan Network Certificate Pinning.

---

### SPESIFIKASI DETAIL UNTUK SETIAP FILE DI FOLDER `docs/sprints/`:
Untuk setiap file sprint di folder `docs/sprints/`, kamu harus menuliskan setiap tugas secara detail dengan struktur:
- **Judul Tugas**: Nama tugas yang jelas.
- **Deskripsi & Konteks**: Penjelasan masalah dan apa yang ingin diselesaikan.
- **Lokasi Berkas**: Lokasi package (`core`, `features_shared`, `apps/main`, dll) atau file path yang terpengaruh.
- **Langkah Eksekusi (Step-by-step)**: Alur kerja teknis langkah demi langkah yang harus dilakukan Agen AI untuk menyelesaikan tugas tersebut.
- **Batasan Arsitektur (Architectural Constraints)**: Batasan monorepo / Clean Architecture (misal: dilarang import package silang, gunakan relative import untuk internal package, dll).
- **Cara Verifikasi**: Perintah CLI konkret untuk memvalidasi keberhasilan tugas (misal: `dart run melos run analyze`, `flutter test`, dll).
- **Estimasi Effort**: Tingkat kesulitan (`S` / `M` / `L`).

---

### CONTOH FORMAT YANG DIHARAPKAN:

#### 1. Contoh format `docs/todo.md` (Master Dashboard):
```markdown
# 📋 Rencana Aksi & Daftar TODO - Kesiapan Flutter Starter

Dokumen ini adalah cetak biru teknis dan master dashboard untuk menyempurnakan **Flutter Starter Project** agar siap produksi.

## 🚀 Ringkasan Status
- [ ] [Fase 00: Temuan Kritis (Segera)](file:///docs/sprints/00_critical.md) — `0/3 Terselesaikan`
- [ ] [Fase 01: Sprint 1 (Fondasi & Core)](file:///docs/sprints/01_sprint_1.md) — `0/3 Terselesaikan`
- [ ] [Fase 02: Sprint 2 (UX & Security)](file:///docs/sprints/02_sprint_2.md) — `0/3 Terselesaikan`
- [ ] [Fase 03: Dokumentasi & AI Agent](file:///docs/sprints/03_documentation.md) — `0/2 Terselesaikan`
- [ ] [Fase 04: Backlog (Nice-to-Have)](file:///docs/sprints/04_backlog.md) — `0/3 Terselesaikan`

---

## 🛠️ Panduan Eksekusi untuk AI Agent
1. Buka berkas [Fase 00: Temuan Kritis](file:///docs/sprints/00_critical.md).
2. Kerjakan tugas satu per satu dari atas ke bawah.
3. Setelah satu tugas selesai dan terverifikasi sukses, ubah status `[ ]` menjadi `[x]` di berkas detail fase tersebut, dan perbarui counter status di master dashboard ini.
4. Jangan berpindah ke Sprint berikutnya sebelum Fase sebelumnya terselesaikan 100%.
