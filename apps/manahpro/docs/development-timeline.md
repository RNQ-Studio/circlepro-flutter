# ManahPro — Development Timeline
## Timeline Realistis: 1 Developer + AI Agent

> **Konteks**: Timeline ini disusun untuk **satu programmer full-stack** (Laravel backend + Flutter frontend) yang bekerja **8–10 jam/hari termasuk weekend**, dibantu oleh **AI Agent** untuk accelerate coding, testing, dan dokumentasi.

> **Mulai**: Juni 2026  
> **Infrastruktur**: VPS/server siap, domain siap, Laravel monorepo (CirclePro) sudah ada  
> **Design**: Code-first berdasarkan wireframe di UI/UX Design Guide

---

## 🟢 Status Implementasi (update: 4 Juni 2026)

> Repo: **`circlepro-flutter`** (app `apps/manahpro`) + **`circlepro-web`** (backend Laravel — _bukan_ `circlepro-laravel`; folder aktualnya `circlepro-web`).

**Keputusan arsitektur (dikonfirmasi):**
- **ID hybrid** — tabel domain ManahPro baru memakai **ULID `char(26)`** (offline-first); tabel `users` & tabel starter lama tetap **bigint** (Passport terikat ke sana). `user_id` = FK bigint, FK ManahPro lain = ULID.
- **Tema app-level** — design system ManahPro (Forest Green/Amber) ada di `apps/manahpro/lib/theme/` (`Manah*`), tidak mengubah `packages/core` (dipakai `apps/variant`).
- **Eksekusi vertical-slice** — fondasi + alur scoring inti end-to-end dulu, baru fitur turunan.

**✅ Selesai & terverifikasi**

| Area | Hasil |
|------|-------|
| **Phase 0 — Backend** | Migrasi **Modul 0** (organizations, user_profiles, user_settings, user_auth_providers, organization_members, user_verifications; `users` di-extend) + **Modul 8 inti** (media, notification_preferences) + **Modul 1** scoring. Model ULID, factory, seeder org platform. Enum domain di `app/Support/Enums`. **Migrasi sudah diterapkan ke DB `circlepro_new` + org platform ter-seed.** |
| **Phase 1 — Backend (penuh)** | `ScoringService` (recompute agregat, deteksi PB, upsert idempotent) + endpoint: equipment-profiles CRUD (1.11a), sessions CRUD + score entry (1.1/1.2), summary (1.3), history+filter (1.7), dashboard (1.9), **sync idempotent by `client_uuid`** (1.13a). **Tes: seluruh suite 183 test hijau di PostgreSQL nyata; Pint bersih.** |
| **Phase 0 — Mobile** | Design system ManahPro (`ManahColors/ManahSpacing/ManahRadius/ManahTextStyles/ManahTheme`, light/dark) ter-wire di `App`. `ScoringDatabase` (Drift) offline. |
| **Phase 1 — Mobile (LENGKAP)** | Clean-arch fitur `scoring` (domain/data/presentation), offline-first via Drift + ULID device-generated, sync client. Layar: **Setup (+ equipment opsional) → Score Input (layar inti, M/1-10/X, slot panah, undo, haptic + sound, auto-advance) → Summary (total, agregat, bar per-end, animasi PB celebration)** · **History** (list + filter busur) · **Statistik** (1.10, line chart `fl_chart`, streak, derive lokal) · **Bow Setup** (1.11b, equipment CRUD online) · **Shareable Scorecard** (1.12, render → PNG → **Bagikan via OS share-sheet** `share_plus` + Simpan via `path_provider`). Entry di Home. **`flutter analyze` 0 error/0 warning; 7 unit test scoring hijau; codegen sukses.** |
| **Phase 1 — Polish (1.14)** | Feedback per panah: `SystemSound.click` + haptic (mediumImpact untuk X/10, selectionClick lainnya); heavy haptic saat selesai/PB; animasi scale+fade pada PB banner di Summary. |
| **Phase 2 — Backend (penuh)** | **Profile API** (2.2: `/v1/profile` GET/PUT + public + stats + age_group otomatis) · **Notification preferences** (2.5) · **Club API** (2.7: directory/search, CRUD, membership join/leave, roles, remove, activity klub) · **Feed API** (2.11: posts CRUD + like + komentar + auto-post `shared_type=scoring_session` 2.13a). Migrasi **Modul 5** (posts, post_likes, comments, comment_likes, follows). **Tes: seluruh suite 196 hijau di PostgreSQL nyata; Pint bersih; migrasi diterapkan ke `circlepro_new`.** |
| **Phase 2 — Mobile (penuh)** | Online (Dio) clean-arch: **Profil** (view + edit) · **Klub** (direktori + search + "Klub Saya" + detail + anggota + gabung/keluar + buat klub) · **Komunitas/Feed** (list + buat post + like optimistik + komentar sheet + kartu scorecard) · **Share-to-Feed** dari Summary scoring (2.13b). Entry Home: Profil/Klub/Komunitas. **`flutter analyze` 0 error/0 warning.** |
| **Phase 2 — Minor (selesai)** | **2.1 Google sign-in (backend)**: `SocialAuthService` verifikasi ID token Google (config-gated `GOOGLE_CLIENT_ID`) → upsert `user_auth_providers` → token Passport via `AuthService::issueTokenForUser`. Aktif begitu client ID diisi (terverifikasi via fake verifier). **2.4 Onboarding ManahPro** 3-layar (override route `/onboarding`). **2.6 Notification UI**: layar Notifikasi (list + mark read) + Preferensi (toggle push/email per kategori). |
| **Phase 3 — Backend (sebagian besar)** | **Event CRUD** (`EventController`) + **event divisions** + status workflow. **Registration API** (`EventRegistrationController`: register, check-in, participant mgmt, status update). **Live Scoring** (`EventScoringController`: assign targets, save end scores per target butt, leaderboard per divisi). **Glicko-2 Rating Engine** (`RatingEngine.php`, 20KB: virtual pairwise, NPS, sigmoid differential, μ/φ/σ update). **Rating data model** (migrasi `ratings`/`rating_history`/`rating_periods`/`rating_bands`). **Leaderboard + finalize ratings** (`RatingController`). Tes: `EventTest`, `EventRegistrationTest`, `EventScoringTest`, `RatingEngineTest` hijau. |
| **Phase 3 — Mobile (sebagian besar)** | **13 screen** di `features/events/`: `event_discovery_screen` · `event_detail_screen` · `create_event_screen` · `my_events_screen` · `registration_flow_screen` · `participant_management_screen` · `ticket_detail_screen` (e-ticket QR) · `multi_archer_scorer_screen` + `scorer_target_selector_screen` (scorer interface) · `live_scoreboard_screen` · `digital_scorecard_screen` · `national_leaderboard_screen` · `rating_history_screen`. Providers + routes + event card widget. **`flutter analyze` 0 error/0 warning.** |
| **Phase 4 — Backend (sebagian besar)** | **Follow system** (`FollowController`: follow/unfollow/followers/following). **Coach directory** (`CoachController` + `CoachReviewController`: CRUD + reviews). **Club enhanced** (`ClubScheduleController` + `ClubAttendanceController`: schedules RRULE + attendance tracking). **Range finder** (`ArcheryRangeController`: CRUD `archery_ranges`). **Article system** (`ArticleController` + categories + tags). **Gamification** (`GamificationController` + `GamificationService`: stats/achievements/streaks). Tes: `FollowSystemTest`, `CoachSystemTest`, `ClubScheduleAndAttendanceTest`, `ArcheryRangeTest`, `GamificationTest` hijau. |
| **Phase 4 — Mobile (sebagian)** | **Coach** (`features/coaches/`: `coach_directory_screen` + `coach_detail_screen`). **Club enhanced** (`club_schedule_screen` 23KB + `club_attendance_dashboard_screen`). **Range finder** (`range_finder_screen` 17KB). **Article reader** (`article_list_screen` + `article_reader_screen`). **Achievement** (`achievement_dashboard_widget` 12KB). **Gamification** (providers + widget). |
| **Bonus (di luar timeline awal)** | **Stories** (Instagram-style): `StoryController` backend + `story_viewer_screen`/`story_picker_preview_screen` mobile + migrasi `stories`/`story_views`. Tes: `StoryTest` hijau. · **Quotes**: `QuoteController` (love/unlove) + full clean-arch `features/quotes/` mobile + migrasi `quotes`/`quote_loves` + seeder 150 quotes. · **Target Face management**: `TargetFaceController` + migrasi `target_faces` + enhanced scoring setup (pilih target face dengan preview visual). |

**🚧 Yang benar-benar belum:**
- **Phase 1–2 (device):** 1.15 uji keterbacaan outdoor **terukur** · 1.17 profiling 60fps.
- **Phase 3 (sisa):** 3.21 **Anti-gaming** (sandbagging detection, SoF) · 3.22 **Calibration mode** (silent rating) · 3.23/3.24 **E2E integration & stress testing** live scoring.
- **Phase 4 (sisa):** 4.1 **Enhanced feed** (rich post types: gallery/video/poll) · 4.8 **Islamic content** (dedicated section, hadith references).

> ~~Payment gateway (3.7)~~, ~~in-app messaging (4.5)~~, dan ~~Apple sign-in~~ **dihapus dari scope**. Google sign-in mobile sudah berjalan lancar.

> **Base URL API:** `https://circlepro.web.id/api/` (3 environment) di `apps/manahpro/lib/config/main_config.dart`.

> **Catatan dependency:** `share_plus` butuh `win32 ^5` (khusus Windows desktop) padahal `package_info_plus` butuh `win32 ^6`. Karena app menargetkan Android/iOS (win32 tak dipakai), ditambahkan `dependency_overrides: win32: ^6.0.1` di pubspec root. Evaluasi ulang bila kelak menargetkan Windows desktop.

> Catatan: banyak butir Phase 0 (API base, auth Passport, CI, offline infra, error handling) **sudah ada di starter** dan dipakai-ulang/di-extend, bukan dibuat dari nol.

---

## Daftar Isi

1. [Asumsi & Estimation Framework](#1-asumsi--estimation-framework)
2. [Executive Summary — Timeline Overview](#2-executive-summary--timeline-overview)
3. [Phase 0: Foundation & Boilerplate](#phase-0-foundation--boilerplate)
4. [Phase 1: MVP Core — Scoring System](#phase-1-mvp-core--scoring-system)
5. [Phase 2: User Identity & Social Foundation](#phase-2-user-identity--social-foundation)
6. [Phase 3: Compete — Events & Ranking](#phase-3-compete--events--ranking)
7. [Phase 4: Community & Content](#phase-4-community--content)
8. [Phase 5: Monetization Layer](#phase-5-monetization-layer)
9. [Phase 6: Marketplace](#phase-6-marketplace)
10. [Phase 7: Advanced & AI Features](#phase-7-advanced--ai-features)
11. [Buffer, Risk & Contingency](#buffer-risk--contingency)
12. [Milestone & Launch Checkpoints](#milestone--launch-checkpoints)
13. [Dependency Map](#dependency-map)

---

## 1. Asumsi & Estimation Framework

### Produktivitas dengan AI Agent

```
TANPA AI Agent (estimasi tradisional):
├── Boilerplate & CRUD         : 100% waktu normal
├── UI Implementation          : 100% waktu normal
├── Business Logic Kompleks    : 100% waktu normal
├── Testing                    : Sering diskip / minimal
└── Total: baseline

DENGAN AI Agent (estimasi realistis):
├── Boilerplate & CRUD         : ~40% waktu (AI generate 60%)
├── UI Implementation          : ~50% waktu (AI generate widget, layout)
├── Business Logic Kompleks    : ~70% waktu (AI bantu tapi perlu review manual)
├── Algoritma (ELO/Glicko-2)  : ~60% waktu (AI sangat membantu formula)
├── Testing                    : ~40% waktu (AI generate test cases)
├── Debugging & Integration    : ~80% waktu (AI kurang efektif di sini)
├── DevOps & Deployment        : ~70% waktu (config spesifik environment)
└── Estimated overall speedup  : ~1.8x - 2.2x lebih cepat

CATATAN PENTING:
├── AI Agent TIDAK menghilangkan complexity, hanya mempercepat
├── Review & testing tetap tanggung jawab developer
├── Integration bugs tetap perlu debugging manual
├── Domain knowledge (panahan) tetap perlu input developer
└── Diminishing returns — semakin kompleks, semakin sedikit speedup
```

### Estimation Unit

```
1 Story Point (SP) ≈ 1 hari kerja efektif (6-7 jam focused coding)
                    = 8-10 jam termasuk planning, review, break

Dengan AI Agent, 1 SP bisa menghasilkan output setara ~1.5-2 SP
tradisional, sehingga timeline sudah memasukkan percepatan ini.

Estimation sudah termasuk:
├── Planning & research per fitur
├── Backend (Laravel API + database + tests)
├── Frontend (Flutter UI + state management + tests)
├── Integration testing
├── Bug fixing (20% buffer per phase)
└── Documentation (minimal, AI-assisted)
```

### Key Assumptions

| Asumsi | Detail |
|--------|--------|
| Jam kerja | 8-10 jam/hari, 7 hari/minggu |
| Burnout mitigation | 1 hari off setiap 2 minggu (~2 hari off/bulan) |
| Hari efektif/bulan | ~28 hari (30 - 2 off days) |
| SP per bulan | ~28 SP |
| Laravel monorepo | Sudah ada auth, base structure, bisa diextend |
| Flutter project | Sudah initialized (manahpro app ada di monorepo) |
| VPS/Server | Sudah ready, tidak perlu procurement |
| Payment Gateway | Midtrans/Xendit (SDK tersedia, integrasi ~3-5 hari) |
| Push Notification | Firebase Cloud Messaging (sudah di-setup) |

---

## 2. Executive Summary — Timeline Overview

```
═══════════════════════════════════════════════════════════════════════
                    MANAHPRO DEVELOPMENT TIMELINE
         1 Developer + AI Agent | Jun 2026 → | Update 4 Jun 2026
═══════════════════════════════════════════════════════════════════════
  ✅ = selesai   🔶 = sebagian besar selesai   ⬚ = belum mulai

✅ P0  ▐████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▌
         Foundation & Boilerplate
         Jun 1–14 → SELESAI (akhir Mei)

✅ P1  ▐░░░░░░░░████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▌
         MVP Core — Scoring System
         Jun 15 – Jul 19 → SELESAI (akhir Mei)

✅ P2  ▐░░░░░░░░░░░░░░░░████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▌
         User Identity & Social Foundation
         Jul 20 – Aug 16 → SELESAI (akhir Mei)

🔶 P3  ▐░░░░░░░░░░░░░░░░░░░░██████████░░░░░░░░░░░░░░░░░░░░░░░░▌
         Compete — Events & Ranking (~90% selesai)
         Aug 17 – Oct 18 → Kode selesai awal Jun; SISA: anti-gaming, testing

         ──── 🚀 SOFT LAUNCH (v0.1-beta) : ~Pertengahan Juli 2026 ────
         (dimajukan dari Agustus — Phase 3 sudah sebagian besar jadi)

🔶 P4  ▐░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░████░░░░░░░░░░░░░░░░░░░▌
         Community & Content (~70% selesai)
         Oct 19 – Nov 15 → Kode selesai awal Jun; SISA: Islamic, enhanced feed

         ──── 🚀 PUBLIC LAUNCH (v1.0) : ~Agustus–September 2026 ────
         (dimajukan dari Oktober — tinggal polish + testing)

⬚ P5  ▐░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██░░░░░░░░░░░░░░░░░▌
         Monetization Layer
         Sep – Oct 2026 (3 minggu, 21 SP)

         ──── 🚀 REVENUE LAUNCH (v1.5) : ~Oktober–November 2026 ────
         Premium subscription + Club SaaS + Event fees

⬚ P6  ▐░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██████░░░░░░░░░▌
         Marketplace
         Nov – Jan 2027 (8 minggu, 56 SP)

         ──── 🚀 MARKETPLACE LAUNCH (v2.0) : ~Akhir Januari 2027 ────

⬚ P7  ▐░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░████████████▌
         Advanced & AI Features
         Feb 2027 – Jun 2027 (ongoing)

═══════════════════════════════════════════════════════════════════════
 PROGRESS: Phase 0–2 ✅ | Phase 3 🔶 90% | Phase 4 🔶 70% ≈ 72% total
 AHEAD OF SCHEDULE: ~2.5 bulan lebih cepat dari timeline awal!
 Sisa: anti-gaming + polish/testing + Phase 5–6
═══════════════════════════════════════════════════════════════════════
```

### Alignment dengan Business Strategy

| Business Strategy Target | Timeline Target | Status |
|--------------------------|-----------------|--------|
| Q1 2026 (Jul-Sep): MVP & Soft Launch | v0.1-beta: **Pertengahan Juli 2026** (dimajukan) | ✅ Ahead of schedule |
| 1.000-3.000 users | Soft launch → gather feedback | ✅ Achievable |
| Q2 2026 (Oct-Dec): Club Tools & Events | v1.0: **Agustus–September 2026** (dimajukan) | ✅ Ahead of schedule |
| 5.000-10.000 users, 50 clubs | Post public launch + monetization | ✅ Achievable |
| Q3 2027 (Jan-Mar): Marketplace & Premium | v2.0: Januari 2027 | ✅ Aligned |
| Revenue Bulan ke-12: Rp 41 jt/bulan | Juni 2027 | ⚠️ Depends on traction |

---

## Phase 0: Foundation & Boilerplate
### 📅 1 – 14 Juni 2026 (2 Minggu, 14 SP) — ✅ SELESAI

> **Tujuan**: Menyiapkan seluruh fondasi teknis agar development fitur berjalan lancar tanpa hambatan infrastruktur.

### Prioritas: 🔴 CRITICAL — Tanpa ini, semua phase lain terhambat

| # | Task | SP | Backend/Frontend | Detail |
|---|------|----|-----------------|--------|
| 0.1 | **Setup Laravel API module di monorepo** | 2 | Backend | API routes, base controllers, middleware, CORS, rate limiting. Extend dari CirclePro structure |
| 0.2 | **Database schema design & migration (core)** | 2 | Backend | Users, profiles, scoring_sessions, scores, clubs, events — design semua tabel inti di awal |
| 0.3 | **API authentication system** | 1.5 | Backend | Laravel **Passport** (OAuth2 password grant), token + refresh, device tracking |
| 0.4 | **Flutter project architecture setup** | 2 | Frontend | Feature-first folder structure, design system tokens (dari UI/UX guide), theme light/dark, routing (go_router), state management (Riverpod/Bloc) |
| 0.5 | **Design system implementation** | 2 | Frontend | AppColors, AppSpacing, AppTypography, component tokens sesuai UI/UX Design Guide Section 3 |
| 0.6 | **CI/CD pipeline** | 1.5 | DevOps | GitHub Actions atau Fastlane: auto build APK, run tests, deploy API ke VPS |
| 0.7 | **Offline-first infrastructure** | 2 | Frontend | Local database (Isar/Drift), sync queue, connectivity detection, optimistic UI pattern |
| 0.8 | **Error handling & logging** | 1 | Both | Sentry/Crashlytics integration, structured logging Laravel, Flutter error boundaries |

### Deliverables Phase 0:
- [x] Laravel API base siap menerima endpoint baru
- [x] Flutter app bisa run dengan design system lengkap
- [x] Offline storage layer ready
- [x] CI/CD pipeline berjalan
- [x] Dark/light theme functional

### 🎯 AI Agent Leverage Points:
- Generate migration files dari schema design
- Generate boilerplate: base repository, base controller, base model
- Generate design token Dart files dari spesifikasi UI/UX guide
- Generate CI/CD YAML config

---

## Phase 1: MVP Core — Scoring System
### 📅 15 Juni – 19 Juli 2026 (5 Minggu, 35 SP)

> **Tujuan**: Fitur scoring yang bisa digunakan untuk latihan sehari-hari. Ini adalah **core value proposition** ManahPro — jika scoring experience buruk, app gagal.

### Prioritas: 🔴 CRITICAL — North Star Metric bergantung pada ini

#### Minggu 1-2: Backend Scoring API + Basic Flutter Scoring UI (14 SP)

| # | Task | SP | Backend/Frontend | Detail |
|---|------|----|-----------------|--------|
| 1.1 | **Scoring Session API** | 2 | Backend | CRUD sessions: create (setup jarak, bow type, arrows), update, finish, delete. Offline-compatible payload design |
| 1.2 | **Score Entry API** | 2 | Backend | Record score per end (rambahan), validation rules (M,1-10,X), auto-calculate end total, running total, average |
| 1.3 | **Session Analytics API** | 2 | Backend | Per-session stats: average, grouping consistency, personal best detection, comparison with previous sessions |
| 1.4 | **Scoring Session Setup Screen** | 2 | Frontend | Pilih distance, bow type, jumlah arrows per end, target face. Quick-start dengan default terakhir |
| 1.5 | **Score Input Screen** | 4 | Frontend | SCREEN TERPENTING! Number pad (M,1-10,X), arrow slots, end navigation, running total, haptic feedback, undo. Harus bisa dioperasikan 1 tangan, < 3 detik per arrow. **Full offline support** |
| 1.6 | **Session Summary Screen** | 2 | Frontend | Total score, average per end, chart per-end scores, personal best notification, share scorecard |

#### Minggu 3-4: Analytics Dashboard + History (14 SP)

| # | Task | SP | Backend/Frontend | Detail |
|---|------|----|-----------------|--------|
| 1.7 | **History API** | 1.5 | Backend | List sessions with filters (date range, bow type, distance), pagination, search |
| 1.8 | **History Screen** | 2 | Frontend | Session list by date, session detail (score per end, notes), compare 2 sessions |
| 1.9 | **Progress Dashboard API** | 2 | Backend | Aggregate data: weekly/monthly avg, trend line, best scores, total sessions, total arrows |
| 1.10 | **Progress Dashboard Screen** | 3 | Frontend | Line chart (score over time), weekly bar chart, personal best tracker, consistency index, streak counter |
| 1.11 | **Bow Setup Logger** | 2 | Backend + Frontend | CRUD equipment profiles: bow model, draw weight, arrow specs, tuning notes. Link ke sessions |
| 1.12 | **Shareable Scorecard** | 2 | Frontend | Beautiful scorecard image generation (untuk share ke IG/WA). Brand watermark ManahPro. **Viral loop trigger!** |
| 1.13 | **Local-Cloud Sync** | 1.5 | Both | Sync offline sessions ke server saat online. Conflict resolution. Queue management |

#### Minggu 5: Polish, Testing & Bug Fix (7 SP)

| # | Task | SP | Detail |
|---|------|----|--------|
| 1.14 | **Scoring UX polish** | 2 | Micro-animations (score pop, end transition, PB celebration), sound effects, haptic tuning |
| 1.15 | **Outdoor readability test** | 1 | Test high contrast mode, font sizes, sunlight visibility. Adjust colors jika perlu |
| 1.16 | **Unit & widget tests** | 2 | Test scoring logic, calculation accuracy, edge cases (all X, all M, partial end) |
| 1.17 | **Performance optimization** | 1 | Profile score input screen: 60fps target, memory check, widget rebuild minimization |
| 1.18 | **Bug fixing buffer** | 1 | Accumulated bugs dari minggu 1-4 |

### Deliverables Phase 1:
- [x] Scoring input yang super cepat (< 3 detik/arrow)
- [x] Full offline scoring capability
- [x] Analytics dashboard dengan charts
- [x] Shareable scorecard (viral loop)
- [x] Session history & comparison
- [x] Bow setup logger

### 🎯 AI Agent Leverage Points:
- Generate score calculation logic & validation
- Generate chart widgets (fl_chart config)
- Generate image generation code untuk shareable scorecard
- Generate unit tests untuk scoring edge cases

---

## Phase 2: User Identity & Social Foundation
### 📅 20 Juli – 16 Agustus 2026 (4 Minggu, 28 SP)

> **Tujuan**: Sistem user lengkap + fondasi sosial agar app terasa "hidup" dan mendorong retensi.

### Prioritas: 🟠 HIGH — Prerequisite untuk semua fitur berikutnya

#### Minggu 1-2: Auth, Profile & Onboarding (14 SP)

| # | Task | SP | Backend/Frontend | Detail |
|---|------|----|-----------------|--------|
| 2.1 | **Social auth implementation** | 3 | Both | Google Sign-In, Phone number (OTP via SMS gateway). Deferred sign-up flow (sesuai UI/UX guide). ~~Apple Sign-In dihapus dari scope~~ |
| 2.2 | **User profile API** | 2 | Backend | Profile CRUD: name, avatar, bio, location, club, bow type preferences, social links |
| 2.3 | **Profile screen** | 3 | Frontend | Avatar & banner, rating card (placeholder), stats summary, achievements section, bow setup, edit profile |
| 2.4 | **Onboarding flow** | 2 | Frontend | 3 screen max: Welcome → Bow type selection → First score CTA. Sesuai UI/UX guide Section 7 |
| 2.5 | **Notification system backend** | 2 | Backend | FCM integration, notification preferences, notification templates, batch send capability |
| 2.6 | **Notification UI** | 2 | Frontend | Notification bell, notification list screen, read/unread state, deep link from notification |

#### Minggu 3: Club Foundation (8 SP)

| # | Task | SP | Backend/Frontend | Detail |
|---|------|----|-----------------|--------|
| 2.7 | **Club data model & API** | 2 | Backend | Club CRUD, member management (join/leave/invite), roles (admin/member), club profile |
| 2.8 | **Club directory screen** | 2 | Frontend | Search & filter clubs by location/name, club card with member count, join request flow |
| 2.9 | **Club detail & management** | 3 | Frontend | Club home, member list, basic schedule, club info. Admin: approve members, edit info |
| 2.10 | **Club-linked scoring** | 1 | Both | Option to tag scoring session as "club practice", show in club activity feed |

#### Minggu 4: Community Feed Foundation (6 SP)

| # | Task | SP | Backend/Frontend | Detail |
|---|------|----|-----------------|--------|
| 2.11 | **Feed API** | 2 | Backend | Post CRUD (text + images), like, comment, feed algorithm (chronological + club priority) |
| 2.12 | **Community feed screen** | 3 | Frontend | Post card (avatar, text, images, like/comment counts), create post (text + photo), basic comment thread |
| 2.13 | **Auto-post dari scoring** | 1 | Both | Option "Share to feed" setelah scoring session selesai, auto-generate post dengan scorecard |

### Deliverables Phase 2:
- [x] Full auth system (Google, Apple, Phone)
- [x] Rich user profiles
- [x] 3-screen onboarding
- [x] Club directory & basic management
- [x] Community feed (post, like, comment)
- [x] Push notifications

### 🎯 Checkpoint: SOFT LAUNCH (v0.1-beta) — ~Pertengahan Agustus 2026

```
SOFT LAUNCH CHECKLIST:
├── ✅ Scoring yang bisa dipakai latihan (offline + online)
├── ✅ User registration & profile
├── ✅ Club directory & join
├── ✅ Community feed
├── ✅ Push notifications
├── ✅ Shareable scorecard
├── ❌ Events & registration (Phase 3)
├── ❌ Ranking system (Phase 3)
├── ❌ Marketplace (Phase 6)
└── ❌ Premium subscription (Phase 5)

TARGET: Deploy ke Play Store (internal/closed testing)
        Invite 20-30 beta testers (atlet + coach)
        Gather feedback intensive 2 minggu
```

---

## Phase 3: Compete — Events & Ranking
### 📅 17 Agustus – 18 Oktober 2026 (9 Minggu, 63 SP)

> **Tujuan**: Event discovery, registration, live scoring, dan sistem ranking nasional. Ini adalah **stickiness driver** utama — yang membuat user tidak bisa pindah platform.

### Prioritas: 🔴 CRITICAL — Diferensiasi utama ManahPro

#### Minggu 1-2: Event Foundation (14 SP)

| # | Task | SP | Backend/Frontend | Detail |
|---|------|----|-----------------|--------|
| 3.1 | **Event data model & API** | 3 | Backend | Event CRUD, event types (tournament/fun/latih tanding), tier system (S/A/B/C/D), divisions, status workflow (draft→published→registration→live→completed→rated) |
| 3.2 | **Event discovery screen** | 3 | Frontend | Event cards with date, location, tier badge, division. Filter by location/date/tier/division. Calendar view toggle |
| 3.3 | **Event detail screen** | 3 | Frontend | Hero image, info chips, capacity bar, tabs (About/Schedule/Participants), sticky CTA "Daftar". Sesuai wireframe UI/UX guide Section 6.3 |
| 3.4 | **Event creation (organizer)** | 3 | Both | Multi-step form: basic info → schedule → divisions & rules → pricing → preview → publish. Admin approval workflow |
| 3.5 | **My Events screen** | 2 | Frontend | Tabs: Registered (upcoming), In Progress, Completed. Event status cards |

#### Minggu 3-4: Event Registration (10 SP)

| # | Task | SP | Backend/Frontend | Detail |
|---|------|----|-----------------|--------|
| 3.6 | **Registration API** | 2 | Backend | Register, cancel, waitlist. Slot management, division assignment, registration deadline enforcement |
| ~~3.7~~ | ~~**Payment gateway integration**~~ | ~~4~~ | ~~Both~~ | ~~DIHAPUS DARI SCOPE — registrasi event gratis/transfer manual~~ |
| 3.8 | **Registration flow UI** | 3 | Frontend | Select division → confirm details → confirmation. Order summary |
| 3.9 | **Participant management (organizer)** | 3 | Backend + Frontend | View participants, approve/reject, export list, send bulk notification, check-in system |
| 3.10 | **E-ticket / QR Code** | 2 | Both | Generate e-ticket with QR code, scan for check-in at event |

#### Minggu 5-6: Live Scoring (14 SP)

| # | Task | SP | Backend/Frontend | Detail |
|---|------|----|-----------------|--------|
| 3.11 | **Live scoring backend** | 4 | Backend | Real-time score collection, validation per scorer, WebSocket/SSE for live updates, automatic placement calculation |
| 3.12 | **Scorer interface** | 3 | Frontend | Special UI for designated scorers: select archer → input scores per end → submit. Similar to personal scoring tapi multi-archer |
| 3.13 | **Live scoreboard (spectator)** | 3 | Frontend | Real-time leaderboard, follow specific archer, end-by-end updates, auto-refresh |
| 3.14 | **Digital scorecard (official)** | 2 | Both | Official event result card, digital certificate for podium finishers, shareable to social media |
| 3.15 | **Event results API** | 2 | Backend | Final standings, score details, generate official PDF results, archive |

#### Minggu 7-8: ELO Ranking System (14 SP)

| # | Task | SP | Backend/Frontend | Detail |
|---|------|----|-----------------|--------|
| 3.16 | **Rating engine (Glicko-2)** | 5 | Backend | Implementasi Modified Glicko-2 sesuai elo-ranking-system.md: virtual pairwise, score normalization (NPS), sigmoid differential, full μ/φ/σ update cycle, K-factor system, SoF adjustment |
| 3.17 | **Rating data model & history** | 2 | Backend | Rating table (per division), rating history table, rated event table. Monthly decay cron job |
| 3.18 | **National leaderboard API** | 2 | Backend | Leaderboard with filters (division, gender, age group, region), pagination, search by name |
| 3.19 | **Leaderboard screen** | 3 | Frontend | National ranking list, filter tabs, my position highlight, archer detail → profile link |
| 3.20 | **Rating card & profile integration** | 2 | Frontend | Rating display di profile: μ display rating, badge (Diamond/Gold/Silver/Bronze/Iron), trend chart, confidence indicator, division breakdown |

#### Minggu 9: Anti-gaming, Testing & Polish (7 SP)

| # | Task | SP | Detail |
|---|------|----|--------|
| 3.21 | **Anti-gaming mechanisms** | 2 | Sandbagging detection, SoF factor, minimum participant threshold, account verification |
| 3.22 | **Calibration mode** | 1 | "Silent rating" mode: compute but don't display publicly. Internal validation dashboard |
| 3.23 | **Integration testing** | 2 | End-to-end: create event → register → live score → results → rating update |
| 3.24 | **Performance & stress test** | 1 | Live scoring with 50+ concurrent archers simulation |
| 3.25 | **Bug fixing buffer** | 1 | Accumulated bugs |

### Deliverables Phase 3 (status per 4 Jun 2026 — ~90% selesai):
- [x] Event discovery, detail, & calendar
- [x] Event registration (gratis / transfer manual)
- [x] Live scoring system (scorer interface + spectator leaderboard)
- [x] Digital scorecard & certificates
- [x] Modified Glicko-2 ranking engine
- [x] National leaderboard
- [x] Rating card & history
- [x] E-ticket / QR check-in
- [x] Participant management (organizer)
- [ ] 🚧 Anti-gaming mechanisms (sandbagging detection, SoF)
- [ ] 🚧 Calibration mode (silent rating)
- [ ] 🚧 E2E integration & stress testing

> ~~Payment gateway (3.7) dihapus dari scope~~ — registrasi event gratis atau pembayaran via transfer manual.

### 🎯 Checkpoint: PUBLIC LAUNCH (v1.0) — **~Agustus–September 2026** (dimajukan dari Oktober)

```
PUBLIC LAUNCH CHECKLIST:
├── ✅ Everything from Soft Launch
├── ✅ Event discovery & registration
├── ✅ Live scoring at events
├── ✅ National ranking system
├── 🚧 Calibration mode — BELUM
├── ✅ Digital scorecards & certificates
├── ✅ E-ticket with QR check-in
├── ❌ Premium subscription (Phase 5)
├── ❌ Marketplace (Phase 6)
└── ❌ AI features (Phase 7)

TARGET: Full Play Store + App Store launch
        Ambassador program (20 atlet/coach)
        Onboarding 50 klub gratis (6 bulan free)
        Hadir di 3-5 turnamen besar untuk demo
        Target: 1.000-3.000 users di bulan pertama
```

---

## Phase 4: Community & Content
### 📅 19 Oktober – 15 November 2026 (4 Minggu, 28 SP)

> **Tujuan**: Memperdalam engagement dengan fitur komunitas yang lebih kaya dan konten edukasi.

### Prioritas: 🟡 MEDIUM-HIGH — Meningkatkan retention & viral growth

| # | Task | SP | Backend/Frontend | Detail |
|---|------|----|-----------------|--------|
| 4.1 | **Enhanced community feed** | 3 | Both | Rich post types: image gallery, video embed, poll. Improved feed algorithm (engagement-weighted) |
| 4.2 | **Follow system** | 2 | Both | Follow/unfollow archers, following feed vs discover feed, follower count on profile |
| 4.3 | **Club enhanced features** | 4 | Both | Club schedule management (training days), attendance tracking, member stats dashboard, club leaderboard |
| 4.4 | **Coach directory** | 3 | Both | Coach profiles (specialization, experience, rate, rating), search by location/specialty, verified coach badge |
| ~~4.5~~ | ~~**In-app messaging**~~ | ~~4~~ | ~~Both~~ | ~~DIHAPUS DARI SCOPE — gunakan WhatsApp/Telegram untuk komunikasi~~ |
| 4.6 | **Range/lapangan finder** | 2 | Both | Map-based search for archery ranges, range profile (address, facilities, hours, photos), directions via Google Maps |
| 4.7 | **Article/tips content system** | 3 | Both | CMS-like: admin publish articles, categories (technique/mental/equipment/sunnah), rich text with images, reading time |
| 4.8 | **Islamic archery content** | 1 | Content | Dedicated section for Sunnah archery content, hadith references, Islamic community features |
| 4.9 | **Achievement & badge system** | 3 | Both | Achievement definitions (first 300, 10 streak, 100 sessions, etc.), progress tracking, badge display on profile, unlock celebrations |
| 4.10 | **Gamification layer** | 2 | Both | Streak system (🔥), weekly challenges, XP system, level progression. Emotional hooks sesuai UI/UX guide |
| 4.11 | **Bug fixing & polish** | 1 | Both | Accumulated bugs + UI polish |

### Deliverables Phase 4 (status per 4 Jun 2026 — ~70% selesai):
- [ ] 🚧 Rich community feed (rich post types: gallery/video/poll belum)
- [x] Follow system
- [x] Enhanced club management (schedules + attendance)
- [x] Coach directory (+ reviews)
- [x] Range finder
- [x] Content/article system
- [ ] 🚧 Islamic archery content (BELUM — dedicated section)
- [x] Achievements & gamification
- [x] 🎁 BONUS: Stories (Instagram-style) — di luar timeline awal

> ~~In-app messaging (4.5) dihapus dari scope~~ — komunikasi via WhatsApp/Telegram.

---

## Phase 5: Monetization Layer
### 📅 16 November – 6 Desember 2026 (3 Minggu, 21 SP)

> **Tujuan**: Aktivasi semua revenue stream yang bisa dijalankan tanpa marketplace.

### Prioritas: 🔴 CRITICAL — Revenue generation

| # | Task | SP | Backend/Frontend | Detail |
|---|------|----|-----------------|--------|
| 5.1 | **Subscription billing system** | 4 | Both | Subscription tiers (Free/Pro/Elite), Google Play Billing, receipt validation, feature gating per tier |
| 5.2 | **Premium features gating** | 2 | Both | Unlimited scoring (free = 3/minggu), advanced analytics, AI insights placeholder, no ads, export data, priority event registration |
| 5.3 | **Club SaaS subscription** | 3 | Both | Club tiers (Starter/Professional/Enterprise), club-level billing, feature gating per tier, payment dashboard for club admin |
| ~~5.4~~ | ~~**Event fee processing**~~ | ~~2~~ | ~~Both~~ | ~~DIHAPUS — tidak ada payment gateway; event gratis/transfer manual~~ |
| 5.5 | **Paywall & upgrade UX** | 3 | Frontend | Beautiful upgrade screens, feature comparison, trial offers, paywall triggers at natural points (not annoying) |
| 5.6 | **Ads framework** | 2 | Both | AdMob/Meta Audience Network integration, ad placements (feed between posts, event list), frequency cap, no ads for premium |
| 5.7 | **Revenue dashboard (admin)** | 2 | Backend | Admin panel: revenue tracking, subscription analytics, churn rate, MRR/ARR projections |
| 5.8 | **Subscription lifecycle** | 2 | Backend | Grace period, dunning (failed payment retry), cancellation flow, reactivation, proration |
| 5.9 | **Testing & bug fix** | 1 | Both | Payment edge cases, subscription state machine testing |

### Deliverables Phase 5:
- [x] Premium subscription (Pro/Elite)
- [x] Club SaaS subscription
- [x] Event platform fee
- [x] Ad monetization (free tier)
- [x] Revenue admin dashboard

### 🎯 Checkpoint: REVENUE LAUNCH (v1.5) — ~Awal Desember 2026

```
REVENUE LAUNCH CHECKLIST:
├── ✅ Premium subscription live di Play Store + App Store
├── ✅ Club SaaS subscription active
├── ✅ Event registration fees processing
├── ✅ Ads serving for free tier
├── Target Revenue Bulan ke-6 (Des 2026): Rp 5-10 jt/bulan
└── Sesuai business strategy projection ✅
```

---

## Phase 6: Marketplace
### 📅 7 Desember 2026 – 31 Januari 2027 (8 Minggu, 56 SP)

> **Tujuan**: Marketplace equipment panahan (baru + bekas) dengan sistem escrow dan review.

### Prioritas: 🟡 MEDIUM — Revenue stream tambahan, butuh user base dulu

#### Minggu 1-2: Marketplace Foundation (14 SP)

| # | Task | SP | Backend/Frontend | Detail |
|---|------|----|-----------------|--------|
| 6.1 | **Product data model & API** | 3 | Backend | Product CRUD, categories (bows, arrows, accessories, apparel), images (multiple), specs, pricing, condition (new/used) |
| 6.2 | **Seller onboarding** | 2 | Both | Seller registration, store profile, verification (for shops), seller dashboard |
| 6.3 | **Product listing creation** | 3 | Frontend | Multi-step: photos → category → details & specs → pricing → preview → publish |
| 6.4 | **Browse & search** | 3 | Both | Category grid, search with filters (category, price range, condition, location), sort (price, newest, rating) |
| 6.5 | **Product detail screen** | 3 | Frontend | Photo gallery, description, specs, seller info, reviews, related products, "Buy" / "Make Offer" CTA |

#### Minggu 3-4: Transaction System (14 SP)

| # | Task | SP | Backend/Frontend | Detail |
|---|------|----|-----------------|--------|
| 6.6 | **Cart & checkout** | 3 | Both | Add to cart, cart management, checkout flow (shipping → payment → confirm) |
| 6.7 | **Escrow payment system** | 4 | Backend | Buyer pays → funds held → seller ships → buyer confirms → funds released. Dispute flow. Refund handling |
| 6.8 | **Shipping integration** | 3 | Both | Shipping cost calculation (RajaOngkir API), shipping label, tracking number input, delivery confirmation |
| 6.9 | **Order management** | 4 | Both | Order status workflow (pending→paid→shipped→delivered→completed), buyer & seller dashboards, order detail, transaction history |

#### Minggu 5-6: Trust & Review System (14 SP)

| # | Task | SP | Backend/Frontend | Detail |
|---|------|----|-----------------|--------|
| 6.10 | **Review & rating system** | 3 | Both | Buyer reviews (only after purchase), star rating + text + photos, seller overall rating, review moderation |
| 6.11 | **Seller verification** | 2 | Both | Verified seller badge, KTP verification, shop license (for toko), trust score |
| 6.12 | **Offer & negotiation** | 3 | Both | "Make Offer" feature, counter-offer, accept/reject, offer expiry |
| 6.13 | **Promoted listings** | 2 | Both | Paid product boost, promoted badge, placement algorithm, listing promotion purchase flow |
| 6.14 | **Equipment recommendation** | 2 | Backend | Basic recommendation based on bow type, level, and browsing history |
| 6.15 | **Dispute resolution** | 2 | Both | Dispute filing, evidence upload, admin mediation dashboard, resolution workflow |

#### Minggu 7-8: Testing, Polish & Buffer (14 SP)

| # | Task | SP | Detail |
|---|------|----|--------|
| 6.16 | **Fraud prevention** | 3 | Suspicious listing detection, rate limiting, report system, seller blacklist |
| 6.17 | **Marketplace admin dashboard** | 3 | Product moderation, seller management, transaction monitoring, dispute handling |
| 6.18 | **E2E testing marketplace** | 3 | Full flow: list → browse → buy → pay → ship → deliver → review |
| 6.19 | **Performance optimization** | 2 | Image optimization (compress, CDN), search performance, pagination tuning |
| 6.20 | **Bug fixing buffer** | 3 | Marketplace bugs are complex (payment edge cases, state machines) |

### Deliverables Phase 6:
- [x] Full marketplace (new + second-hand)
- [x] Escrow payment system
- [x] Shipping integration
- [x] Review & rating system
- [x] Seller verification
- [x] Offer/negotiation
- [x] Promoted listings
- [x] Dispute resolution

### 🎯 Checkpoint: MARKETPLACE LAUNCH (v2.0) — ~Akhir Januari 2027

```
MARKETPLACE LAUNCH:
├── ✅ Full marketplace operational
├── Target: 50+ sellers onboarded
├── Target GMV: Rp 50-100 jt/bulan (start)
├── Revenue: 3-5% commission per transaction
└── Sesuai business strategy Q3 2027 target ✅
```

---

## Phase 7: Advanced & AI Features
### 📅 Februari 2027 – Juni 2027 (Ongoing)

> **Tujuan**: Fitur advanced yang meningkatkan value proposition dan moat.

### Prioritas: 🟢 NICE-TO-HAVE → Menjadi IMPORTANT seiring growth

| # | Task | Estimasi SP | Detail |
|---|------|-------------|--------|
| 7.1 | **AI Target Recognition** | 15-20 | Computer vision: foto target → auto-detect score. ML model training, edge inference. **Paling kompleks — bisa di-outsource/partnership** |
| 7.2 | **Training program builder** | 8 | Structured training programs (pemula → mahir), weekly/daily plans, progress tracking |
| 7.3 | **1-on-1 coaching booking** | 10 | Coach availability calendar, booking flow, payment (coach commission), video call integration |
| 7.4 | **Video tutorial platform** | 6 | Video hosting, categories, progress tracking, coach-uploaded content |
| 7.5 | **Advanced analytics (AI)** | 8 | AI-powered insights: weakness detection, improvement suggestions, performance prediction |
| 7.6 | **White-label scoring** | 6 | API & customizable scoring for organizations/PERPANI |
| 7.7 | **Multi-language** | 4 | English support, RTL consideration, i18n infrastructure |
| 7.8 | **Brand partnership dashboard** | 5 | Sponsored content management, analytics for brands, campaign tracking |
| 7.9 | **Admin super-dashboard** | 8 | Comprehensive admin: user management, content moderation, analytics, financial reports |
| 7.10 | **Performance & scalability** | 5 | Database optimization, caching layer (Redis), CDN, load testing, query optimization |

> **Catatan**: Phase 7 bersifat modular — dikerjakan berdasarkan prioritas bisnis dan feedback user saat itu. Tidak semua harus selesai di H1 2027.

---

## Buffer, Risk & Contingency

### Built-in Buffer per Phase

```
BUFFER ALLOCATION:
═══════════════════

Phase 0: 0 buffer (fondasi tidak bisa delay)
Phase 1: 7 SP built-in (minggu 5 = polish + bugs)
Phase 2: 3 SP slack (estimasi konservatif di auth)
Phase 3: 7 SP built-in (minggu 9 = testing + bugs)
Phase 4: 1 SP explicit buffer
Phase 5: 1 SP explicit buffer
Phase 6: 6 SP built-in (minggu 7-8 = testing + bugs)

Total buffer: ~25 SP ≈ 3.5 minggu

CONTINGENCY BUFFER TAMBAHAN:
├── 2 minggu antara Phase 2 & 3 jika soft launch delay
├── 1 minggu antara Phase 5 & 6 untuk stabilization
└── Total contingency: ~3 minggu

GRAND TOTAL BUFFER: ~6.5 minggu (18% dari total timeline)
→ Industri standar 15-25%, kita di sweet spot ✅
```

### Risiko & Mitigasi

| Risiko | Probabilitas | Impact | Mitigasi |
|--------|-------------|--------|----------|
| **Developer burnout** (8-10 hr/day, 7 days) | Tinggi | Sangat Tinggi | **Wajib ambil 1 hari off/2 minggu.** Jika burnout terasa, turunkan ke 6 jam/hari dan extend timeline. Kesehatan > deadline |
| **Scope creep** | Tinggi | Tinggi | Strict phase boundaries. Jika fitur baru muncul → masuk Phase 7 backlog. TIDAK boleh menambah scope mid-phase |
| **Payment gateway complexity** | Medium | Tinggi | Mulai integrasi payment di minggu 1 Phase 3, bukan minggu terakhir. Payment paling banyak edge cases |
| **App Store rejection** | Medium | Medium | Siapkan privacy policy, terms of service di awal. Follow Apple guidelines. Submit iOS 2 minggu sebelum target launch |
| **Real-time system (live scoring)** | Medium | Medium | Mulai dengan polling (simpler), upgrade ke WebSocket jika perlu. MVP live scoring bisa non-realtime (refresh manual) |
| **ELO/Glicko-2 bugs** | Medium | Tinggi | Calibration period (silent mode). Extensive unit testing. Manual spot-check dengan contoh perhitungan di doc |
| **Infrastructure scaling** | Rendah (awal) | Medium | VPS cukup untuk 0-10k users. Plan upgrade path ke cloud (GCP/AWS) saat mendekati 50k users |

### Fitur yang Bisa Dipotong jika Behind Schedule

```
FITUR CUTTABLE (bisa di-defer tanpa mengganggu core value):
├── 4.5  In-app messaging       → Pakai WhatsApp deep link dulu
├── 4.6  Range finder           → Defer ke Phase 7
├── 4.8  Islamic content        → Cukup label/tag di community feed
├── 4.10 Gamification layer     → Basic streak saja, XP/level nanti
├── 6.12 Offer & negotiation    → Fixed price only di v1
├── 6.13 Promoted listings      → Defer, fokus organic dulu
└── 6.14 Equipment recommendation → Defer ke Phase 7

Saving: ~16 SP (≈ 2.3 minggu)
```

---

## Milestone & Launch Checkpoints

### Timeline Visual dengan Milestones

```
Jun 2026         Jul              Aug              Sep
│────────────────│────────────────│────────────────│──
│ Phase 0 │    Phase 1          │ Phase 2  │ Phase 3
│ Foundation    Scoring MVP     │ Auth +    │ Events ──
│               │                │ Social    │  
│               │                │           │
│               │                🚀 v0.1β   │
│               │                SOFT       │
│               │                LAUNCH     │

Oct              Nov              Dec              Jan 2027
──────────────────│────────────────│────────────────│────
── Phase 3 ──────│ Phase 4       │ Phase 5  │ Phase 6 ──
   Events +      │ Community +   │ Revenue  │ Marketplace
   Ranking       │ Content       │ Launch   │
                 │               │          │
🚀 v1.0         │               🚀 v1.5   │
PUBLIC           │               REVENUE   │
LAUNCH           │               LAUNCH    🚀 v2.0
                 │                          MARKETPLACE
                 │                          LAUNCH

Feb 2027 ───────────────────────────► ongoing
Phase 7: Advanced & AI Features
```

### Key Dates Summary

| Milestone | Target Awal | **Target Revisi** | Status |
|-----------|------------|-------------------|--------|
| Phase 0 complete | 14 Juni 2026 | **✅ Akhir Mei 2026** | 🟢 SELESAI |
| Phase 1 complete (Scoring MVP) | 19 Juli 2026 | **✅ Akhir Mei 2026** | 🟢 SELESAI |
| Phase 2 complete (Identity & Social) | 16 Agustus 2026 | **✅ Akhir Mei 2026** | 🟢 SELESAI |
| Phase 3 ~90% (Events + Ranking) | 18 Oktober 2026 | **🔶 4 Juni 2026** | 🟢 Sisa: anti-gaming, testing |
| Phase 4 ~70% (Community) | 15 November 2026 | **🔶 4 Juni 2026** | 🟢 Sisa: Islamic, enhanced feed |
| **🚀 Soft Launch (v0.1-beta)** | **~16 Agustus 2026** | **~Pertengahan Juli 2026** | 🟢 95% |
| **🚀 Public Launch (v1.0)** | **~18 Oktober 2026** | **~Agustus–September 2026** | 🟢 90% |
| **🚀 Revenue Launch (v1.5)** | **~6 Desember 2026** | **~Oktober–November 2026** | 🟡 80% |
| Phase 6 complete (Marketplace) | 31 Januari 2027 | **~Desember 2026 – Jan 2027** | 🟡 75% |
| **🚀 Marketplace Launch (v2.0)** | **~31 Januari 2027** | **~Januari 2027** | 🟡 75% |

> **Catatan Confidence (update)**: Confidence **meningkat** karena Phase 0–4 sebagian besar sudah jadi,
> menghilangkan risiko kumulatif delay di fase awal. Risiko yang masih ada:
> 1. App Store review (submit iOS 2 minggu sebelum target)
> 2. Feedback dari soft launch bisa memaksa re-prioritization
> 3. Burnout risk — sudah bekerja intensif, perlu pace yang sustainable

---

## Dependency Map

```
DEPENDENCY GRAPH (apa yang harus selesai sebelum apa):
═════════════════════════════════════════════════════

Phase 0 ─────────────┐
  Foundation         │
  (WAJIB pertama)    │
                     ▼
Phase 1 ─────────────┐
  Scoring MVP        │──────────────────────────────────┐
  (Core value)       │                                  │
                     ▼                                  │
Phase 2 ─────────────┐                                  │
  Auth + Social      │                                  │
  (User identity)    │                                  │
        │            │                                  │
        │            ▼                                  ▼
        │     Phase 3 ──────────────────┐        Phase 6
        │       Events + Ranking        │        Marketplace
        │       (butuh Auth + Scoring)  │        (butuh Auth)
        │            │                  │              │
        ▼            ▼                  ▼              │
   Phase 4      Phase 5 ◄──────────────┘              │
   Community    Monetization                           │
   (butuh Auth  (subscription +                        │
    + Feed)      premium gating)                       │
                     │                                  │
                     └──────────────────────────────────┘

PARALLELIZABLE (bisa di-overlap jika ada capacity):
├── Phase 4 (Community) bisa mulai parallel dengan akhir Phase 3
├── Phase 6 (Marketplace) independen dari payment gateway
└── Phase 7 items independen — bisa dikerjakan kapan saja
```

---

## Rekomendasi Weekly Rhythm

```
WEEKLY ROUTINE YANG DIREKOMENDASIKAN:
═════════════════════════════════════

Senin    : Planning sprint mingguan (30 min) → Backend heavy day
Selasa   : Backend development (API + database)
Rabu     : Frontend development (Flutter UI)
Kamis    : Frontend + integration testing
Jumat    : Backend + Frontend (fitur yang bridging)
Sabtu    : Polish, bug fix, PR review, testing
Minggu   : Light work (docs, planning next week) atau OFF

DAILY ROUTINE:
├── 08:00-09:00  : Review yesterday, plan today
├── 09:00-12:00  : Deep work block #1 (3 jam uninterrupted)
├── 12:00-13:00  : Break
├── 13:00-16:00  : Deep work block #2 (3 jam uninterrupted)
├── 16:00-16:30  : Break
├── 16:30-18:30  : Deep work block #3 (2 jam)
├── 18:30-19:30  : Break/dinner
└── 19:30-21:00  : Light work (testing, docs, planning) — OPTIONAL

BURNOUT PREVENTION:
├── ⚠️ WAJIB ambil 1 hari FULL OFF setiap 2 minggu
├── ⚠️ Jika merasa burnout, turunkan ke 6 jam/hari
├── ⚠️ Exercise / outdoor activity minimal 30 min/hari
└── ⚠️ Review pacing setiap 2 minggu — adjust jika perlu
```

---

## Summary: Apa yang Didapat di Setiap Milestone

| Milestone | Tanggal Target | Apa yang User Dapat | Revenue Stream Aktif |
|-----------|---------------|---------------------|---------------------|
| **v0.1-beta** | ~~16 Aug~~ → **~Jul 2026** | Scoring + Profile + Club + Feed + Events + Coach + Ranges | ❌ Belum ada |
| **v1.0** | ~~18 Oct~~ → **~Aug–Sep 2026** | + Live Scoring + Ranking + Articles | ❌ Belum ada (event gratis) |
| **v1.5** | ~~6 Dec~~ → **~Oct–Nov 2026** | + Premium Sub + Club SaaS + Ads | Premium, Club SaaS, Ads, Event fee |
| **v2.0** | ~Jan 2027 | + Full Marketplace + Escrow | + Marketplace commission (3-5%) |
| **v2.x** | Feb-Jun 2027 | + AI features + Coaching + Training | + Coaching commission, Brand partnership |

```
REVENUE TRAJECTORY (estimated, revised):
════════════════════════════════════════

Bulan ke-2  (Jul 2026) : Rp 0 (beta, free for all)
Bulan ke-3  (Aug 2026) : Rp 0-1 jt (event fees mulai masuk)
Bulan ke-5  (Oct 2026) : Rp 3-8 jt (premium + club SaaS + events)
Bulan ke-7  (Dec 2026) : Rp 10-20 jt (+ marketplace early)
Bulan ke-12 (May 2027) : Rp 35-50 jt (all streams active, growing)

→ Target business strategy Rp 41 jt/bulan di bulan ke-12: ✅ ACHIEVABLE
→ Revenue start lebih cepat karena launch dimajukan!
```

---

*Dokumen ini adalah living document. Update setiap 2 minggu berdasarkan actual progress vs planned.*

*Dibuat: 29 Mei 2026*  
*Update terakhir: **4 Juni 2026** — audit codebase menunjukkan Phase 3+4 sebagian besar selesai (~68% total)*  
*Konteks: 1 developer (Laravel + Flutter) + AI Agent, 8-10 jam/hari*  
*Baseline: Business Strategy & UI/UX Design Guide ManahPro*
