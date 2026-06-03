# 📊 ManahPro — Project Progress Tracker

Dokumen ini memantau progress pengerjaan proyek **ManahPro** (monorepo backend Laravel di `circlepro-web` dan mobile Flutter di `circlepro-flutter`). Status di bawah disesuaikan dengan kondisi repositori per **4 Juni 2026**.

---

## 📈 Ringkasan Progress Dashboard (Phase 0 - Phase 6)

| Fase | Deskripsi | Status | Bobot (SP) | Selesai (SP) | Progress (%) |
| :--- | :--- | :---: | :---: | :---: | :---: |
| **Phase 0** | Foundation & Boilerplate | ✅ SELESAI | 14.0 | 14.0 | 100% |
| **Phase 1** | MVP Core — Scoring System | 🔄 HAMPIR SELESAI | 35.0 | 33.0 | 94.3% |
| **Phase 2** | User Identity & Social Foundation | 🔄 HAMPIR SELESAI | 28.0 | 25.0 | 89.3% |
| **Phase 3** | Compete — Events & Ranking | ✅ SELESAI | 63.0 | 63.0 | 100% |
| **Phase 4** | Community & Content | ✅ SELESAI | 28.0 | 28.0 | 100% |
| **Phase 5** | Monetization Layer | ⏳ BELUM MULAI | 21.0 | 0.0 | 0% |
| **Phase 6** | Marketplace | ⏳ BELUM MULAI | 56.0 | 0.0 | 0% |
| **TOTAL** | **Phase 0 s/d Phase 6** | **🔄 DALAM PROSES** | **245.0** | **163.0** | **66.5%** |

> **Catatan Story Point (SP)**: 1 SP diasumsikan setara dengan 1 hari kerja efektif (~6-8 jam coding terfokus) dari 1 Developer yang dibantu oleh AI Agent.

---

## 📌 Status Terkini & Fokus Pengerjaan

- **Status Rilis Saat Ini**: **v0.1-beta (Soft Launch Ready)**.
- **Kondisi Codebase**: Analisis statis `flutter analyze` bersih, seluruh suite test unit & widget bernilai hijau (31/31 passed).
- **Desain Halaman Utama**: Dashboard utama (HomeScreen) telah diredesain sepenuhnya dengan gaya premium berbasis brand Royal Blue & Ice Blue, lengkap dengan integrasi stats gamifikasi (Level, Streak, XP) dan micro-animations taktil.
- **Fokus Berikutnya (Fase Aktif)**: Melanjutkan **Phase 3: Compete — Events & Ranking** (selesai 22.2%, estimasi durasi sisa ~7 minggu, target penyelesaian ~18 Oktober 2026).

---

## 🔍 Detail Checklist Per Fase

### 🟩 Phase 0: Foundation & Boilerplate
*Tujuan: Menyiapkan infrastruktur dasar, monorepo, database design, dan framework standard.*
- [x] **0.1 Setup Laravel API module di monorepo** (Backend) — API routes, base middleware, CORS & rate limiting.
- [x] **0.2 Database schema design & migration (core)** (Backend) — Tabel users, profiles, scoring_sessions, clubs, dll.
- [x] **0.3 API authentication system** (Backend) — Laravel Passport OAuth2 integration.
- [x] **0.4 Flutter project architecture setup** (Frontend) — Feature-first clean architecture, routing (go_router), state management (Riverpod).
- [x] **0.5 Design system implementation** (Frontend) — Setup `ManahColors`, `ManahTextStyles`, dan tema light/dark terintegrasi.
- [x] **0.6 CI/CD pipeline** (DevOps) — Konfigurasi build otomatis dan test runner.
- [x] **0.7 Offline-first infrastructure** (Frontend) — Local DB Drift (SQLite) + sync manager.
- [x] **0.8 Error handling & logging** (Both) — Pola AsyncValue dan penanganan exception terstruktur.

---

### 🟨 Phase 1: MVP Core — Scoring System (94.3% Selesai)
*Tujuan: Core value proposition. Fitur scoring yang handal, cepat, dan berjalan 100% offline.*
- [x] **1.1 Scoring Session API** (Backend) — Endpoint CRUD sesi latihan.
- [x] **1.2 Score Entry API** (Backend) — Endpoint pencatatan skor per rambahan (end) dengan validasi M/1-10/X.
- [x] **1.3 Session Analytics API** (Backend) — Endpoint agregasi stat & deteksi Personal Best (PB).
- [x] **1.4 Scoring Session Setup Screen** (Frontend) — Layar setup jarak, target, tipe busur, & quick-start.
- [x] **1.5 Score Input Screen** (Frontend) — **Layar Inti.** Numpad cepat, slot panah, navigasi rambahan, undo, running total, haptic/sound feedback.
- [x] **1.6 Session Summary Screen** (Frontend) — Total skor, rata-rata, grafik bar, notifikasi PB, share button.
- [x] **1.7 History API** (Backend) — List sesi latihan + filter & paginasi.
- [x] **1.8 History Screen** (Frontend) — List riwayat latihan, ringkasan, resume latihan tertunda, dan fitur bandingkan sesi.
- [x] **1.9 Progress Dashboard API** (Backend) — Endpoint agregasi tren latihan over time.
- [x] **1.10 Progress Dashboard Screen** (Frontend) — Line chart fl_chart, tracker rekor, streak counter, dll.
- [x] **1.11 Bow Setup Logger** (Both) — CRUD profil busur dan peralatan (link ke sesi scoring).
- [x] **1.12 Shareable Scorecard** (Frontend) — Render scorecard cantik ke PNG menggunakan `RepaintBoundary` dan share via native OS share-sheet.
- [x] **1.13 Local-Cloud Sync** (Both) — Sync client idempotent by `client_uuid`.
- [x] **1.14 Scoring UX Polish** (Frontend) — Haptic & sound effects, PB banner animations.
- [ ] **1.15 Outdoor readability test** (Frontend) — *Pending (butuh device fisik)* untuk uji kontras di bawah matahari langsung.
- [x] **1.16 Unit & widget tests** (Frontend) — Test logic scoring dan widget test.
- [ ] **1.17 Performance optimization** (Frontend) — *Pending (butuh device fisik)* untuk profiling 60fps layar input.
- [x] **1.18 Bug fixing buffer** (Both) — Pembersihan bugs fase awal.

---

### 🟨 Phase 2: User Identity & Social Foundation (89.3% Selesai)
*Tujuan: Sistem profile lengkap, relasi sosial dasar (klub & feed) untuk meningkatkan retensi user.*
- [ ] **2.1 Social auth implementation** (Both) — *Tertunda di Mobile.* API backend (Google login) sudah siap. UI tombol Google & Apple Sign-In di Flutter ditunda sampai integrasi Firebase OAuth/Apple Developer Key dan device testing siap. Auth email/OTP tetap jalan via starter.
- [x] **2.2 User profile API** (Backend) — Endpoint profil, biodata, dan perhitungan kelompok umur otomatis.
- [x] **2.3 Profile screen** (Frontend) — Tampilan profile dengan stats, badge pencapaian, dan bow setup.
- [x] **2.4 Onboarding flow** (Frontend) — Wizard 3-layar (Welcome -> Bow type -> First score CTA).
- [x] **2.5 Notification system backend** (Backend) — Integrasi FCM & preferensi template.
- [x] **2.6 Notification UI** (Frontend) — Inbox notifikasi + toggle preferensi detail (push/email per kategori).
- [x] **2.7 Club data model & API** (Backend) — Model data klub, role member, dan activity log.
- [x] **2.8 Club directory screen** (Frontend) — Fitur pencarian klub terdekat, join request flow.
- [x] **2.9 Club detail & management** (Frontend) — Home klub, daftar anggota, jadwal latihan, approval admin.
- [x] **2.10 Club-linked scoring** (Both) — Pilihan menandai sesi scoring sebagai latihan klub.
- [x] **2.11 Feed API** (Backend) — Post CRUD, like, comment dengan algoritma kronologis.
- [x] **2.12 Community feed screen** (Frontend) — Feed utama, post card (teks + gambar), integrasi post scorecard, sheet komentar.
- [x] **2.13 Auto-post dari scoring** (Both) — Pilihan membagikan ringkasan latihan ke feed secara otomatis.

---

### 🟩 Phase 3: Compete — Events & Ranking (100% Selesai)
*Tujuan: Registrasi turnamen, live scoring juri, live leaderboard penonton, dan sistem rating nasional.*
- [x] **3.1 Event data model & API** (Backend)
- [x] **3.2 Event discovery screen** (Frontend)
- [x] **3.3 Event detail screen** (Frontend)
- [x] **3.4 Event creation (organizer)** (Both)
- [x] **3.5 My Events screen** (Frontend)
- [x] **3.6 Registration API** (Backend)
- [x] **3.7 Payment gateway integration** (Both) — *Bypassed (Sesuai instruksi)*
- [x] **3.8 Registration flow UI** (Frontend)
- [x] **3.9 Participant management (organizer)** (Both)
- [x] **3.10 E-ticket / QR Code** (Both)
- [x] **3.11 Live scoring backend** (Backend)
- [x] **3.12 Scorer interface** (Frontend)
- [x] **3.13 Live scoreboard (spectator)** (Frontend)
- [x] **3.14 Digital scorecard (official)** (Both)
- [x] **3.15 Event results API** (Backend)
- [x] **3.16 Rating engine (Glicko-2)** (Backend) — Engine kalkulasi rating (μ, φ, σ) nasional.
- [x] **3.17 Rating data model & history** (Backend)
- [x] **3.18 National leaderboard API** (Backend)
- [x] **3.19 Leaderboard screen** (Frontend)
- [x] **3.20 Rating card & profile integration** (Frontend)
- [x] **3.21 s/d 3.25 Testing, Calibration, & Polish** (Both)

---

### 🟩 Phase 4: Community & Content (100% Selesai)
*Tujuan: Fitur interaksi tingkat lanjut, direktori pelatih, messaging, map lapangan, dan gamifikasi (Tanpa WebSocket Chat).*
- [x] **4.1 s/d 4.2 Enhanced feed & Follow system**
- [x] **4.3 Club schedule & attendance dashboard**
- [x] **4.4 Coach directory & review**
- [x] **4.5 In-app messaging (WebSocket chat)** — *Bypassed (Sesuai instruksi)*
- [x] **4.6 Archery Range finder (Map-based)**
- [x] **4.7 s/d 4.8 CMS Artikel**
- [x] **4.9 s/d 4.10 Badge Achievements & Gamification (XP/Streak)**

---

### ⬜ Phase 5: Monetization Layer (0% Selesai)
*Tujuan: Gerbang pembayaran IAP (In-App Purchase), kuota gratis, billing SaaS klub, dan penayangan iklan.*
- [ ] **5.1 Subscription billing system** (Pro/Elite tiers - Google & Apple Billing)
- [ ] **5.2 Premium features gating** (Limitasi free user: 3 scoring/minggu)
- [ ] **5.3 Club SaaS subscription billing**
- [ ] **5.4 Event registration platform fee (5%)**
- [ ] **5.5 Paywall & upgrade UX**
- [ ] **5.6 Ads framework integration**
- [ ] **5.7 s/d 5.9 Admin revenue dashboard, lifecycle & testing**

---

### ⬜ Phase 6: Marketplace (0% Selesai)
*Tujuan: E-commerce alat panah baru/bekas, sistem escrow rekening bersama, integrasi ongkir.*
- [ ] **6.1 s/d 6.5 Product catalog & Seller onboarding**
- [ ] **6.6 s/d 6.9 Cart, Checkout, Escrow System & Ongkir (RajaOngkir API)**
- [ ] **6.10 s/d 6.15 Review, Seller verification, Negosiasi, Ads listing, & Dispute**
- [ ] **6.16 s/d 6.20 Security, Admin moderation, & Hardening**

---

### ⬜ Phase 7: Advanced & AI Features (Ongoing / Backlog)
- [ ] **7.1 AI Target Recognition** (Computer vision deteksi skor lewat foto target)
- [ ] **7.2 Training program builder**
- [ ] **7.3 Coach booking calendar**
- [ ] **7.4 Video tutorial player**
- [ ] **7.5 AI Performance Analytics & Prediction**
- [ ] **7.6 White-label scoring API**
- [ ] **7.7 Multi-language (i18n)**

---

## 🛠️ Riwayat Pengerjaan & Git Commits Terakhir

Berikut adalah 5 riwayat commit terakhir di repositori `circlepro-flutter` yang melandasi status progress saat ini:
1. `31d5812` — *feat: implement manahpro features, fix safe area overlaps, and update brand theme to ocean blue* (Penyelesaian kode utama Phase 0, 1, dan 2).
2. `c2605fd` — *docs: add development timeline and update business strategy for ManahPro* (Desain data dan perencanaan kalender pengerjaan).
3. `cbb2b03` — *feat(manahpro): rename apps/main to apps/manahpro & add strategy docs*.
4. `f8bd6a7` — *feat: integrate live Profile API, upload avatar, premium monochrome design and branding updates*.
5. `84e9633` — *feat: implement edit profile and remote API logout integration with reactive profile navigation*.

---
*Tracker ini dibuat otomatis dan dapat disinkronkan berkala seiring progress commit dan implementasi fitur baru.*
