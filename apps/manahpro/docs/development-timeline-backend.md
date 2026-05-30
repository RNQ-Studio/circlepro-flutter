# ManahPro — Development Timeline (BACKEND / Laravel)
## Track Backend dari Timeline 1 Developer + AI Agent

> **Dokumen ini adalah _view backend_** dari [development-timeline.md](development-timeline.md) (timeline gabungan).
> Isinya **hanya task Laravel/API/DB/DevOps-backend**. Track mobile ada di
> [development-timeline-mobile.md](development-timeline-mobile.md).

> **Konteks**: Tetap **satu developer full-stack** yang sama mengerjakan backend **dan** mobile
> pada **kalender yang sama** (~8.5 bulan, Jun 2026 → Jan 2027). Pemisahan ini **bukan** untuk
> menambah orang — melainkan agar tiap disiplin bisa di-_track_ dan di-fokus-kan secara terpisah.
> Per fitur, urutan kerja yang disarankan: **backend (kontrak API) dulu → baru mobile** (lihat
> [§Prinsip Kontrak](#prinsip-kontrak-backend-first-per-fitur)).

> **Stack backend**: Laravel (API) + PostgreSQL + **Passport** (OAuth2) + Midtrans/Xendit + FCM.
> Skema DB acuan: [database-design.md](database-design.md) / [database-design.dbml](database-design.dbml) (~88 tabel, 9 modul).

---

## Daftar Isi

1. [Cara Membaca Bersama Track Mobile](#1-cara-membaca-bersama-track-mobile)
2. [Pembagian Beban per Fase](#2-pembagian-beban-per-fase)
3. [Prinsip Kontrak (Backend-First per Fitur)](#prinsip-kontrak-backend-first-per-fitur)
4. [Peta Fase ↔ Modul Database](#4-peta-fase--modul-database)
5. [Phase 0: Foundation & Boilerplate (Backend)](#phase-0-foundation--boilerplate-backend)
6. [Phase 1: Scoring System (Backend)](#phase-1-scoring-system-backend)
7. [Phase 2: Identity & Social (Backend)](#phase-2-identity--social-backend)
8. [Phase 3: Events & Ranking (Backend)](#phase-3-events--ranking-backend)
9. [Phase 4: Community & Content (Backend)](#phase-4-community--content-backend)
10. [Phase 5: Monetization (Backend)](#phase-5-monetization-backend)
11. [Phase 6: Marketplace (Backend)](#phase-6-marketplace-backend)
12. [Phase 7: Advanced & AI (Backend)](#phase-7-advanced--ai-backend)
13. [Risiko Khusus Backend](#13-risiko-khusus-backend)

---

## 1. Cara Membaca Bersama Track Mobile

- **Tanggal & milestone identik** di kedua file — karena dikerjakan 1 orang di 1 kalender.
  Yang berbeda hanya **daftar task** (di sini: backend saja).
- **SP backend + SP mobile = SP fase gabungan.** Task `Both` di timeline asli sudah dipecah
  menjadi porsi backend (di file ini) dan porsi mobile (di file mobile). Nomor task tetap
  mengikuti aslinya, dengan sufiks `a` (backend) / `b` (mobile) untuk task yang dipecah.
- **Backend memimpin per fitur.** Dalam satu fase, kerjakan endpoint + migrasi + kontrak respons
  lebih dulu, sehingga mobile bisa langsung integrasi tanpa menunggu (lihat §Prinsip Kontrak).
- **Pengecualian offline-first (Phase 1):** UI scoring mobile bisa jalan **mendahului** backend
  karena ULID & data di-generate di device; sync API menyusul. Lihat catatan di Phase 1.

---

## 2. Pembagian Beban per Fase

| Fase | Periode | **Backend SP** | Mobile SP | Total SP |
|------|---------|:-:|:-:|:-:|
| **P0** Foundation | 1 – 14 Jun 2026 | **7** | 7 | 14 |
| **P1** Scoring MVP | 15 Jun – 19 Jul 2026 | **13** | 22 | 35 |
| **P2** Identity & Social | 20 Jul – 16 Aug 2026 | **10.5** | 17.5 | 28 |
| **P3** Events & Ranking | 17 Aug – 18 Oct 2026 | **33** | 30 | 63 |
| **P4** Community & Content | 19 Oct – 15 Nov 2026 | **14** | 14 | 28 |
| **P5** Monetization | 16 Nov – 6 Dec 2026 | **12** | 9 | 21 |
| **P6** Marketplace | 7 Dec 2026 – 31 Jan 2027 | **32.5** | 23.5 | 56 |
| **TOTAL P0–6** | | **122** | 123 | 245 |

> **Insight beban backend:** ringan di awal (scoring API sederhana), lalu **memuncak di Phase 3**
> (Glicko-2 engine + live scoring + payment + events = 33 SP, fase terberat) dan **Phase 6**
> (escrow + order state machine + fraud = 32.5 SP). Phase 1 & 2 didominasi mobile, jadi di periode
> itu backend punya "slack" untuk mendahulukan desain kontrak API fase berikutnya.

---

## Prinsip Kontrak (Backend-First per Fitur)

Karena 1 orang mengerjakan dua sisi, hindari _context-switching_ bolak-balik. Pola per fitur:

```
1. DESIGN KONTRAK   → tentukan endpoint, request/response shape, kode error (AppException)
2. MIGRASI + MODEL  → tabel (ikut database-design.dbml), relasi, factory/seeder
3. ENDPOINT + TEST  → controller + validasi + feature test (PHPUnit/Pest)
4. SERAHKAN KE MOBILE→ kontrak final = dependency yang dibuka untuk task mobile sefase
5. INTEGRASI        → mobile konsumsi; bug integrasi diperbaiki bareng (buffer akhir fase)
```

- **Definisi "selesai" task backend** = endpoint ter-test + terdokumentasi (OpenAPI/Postman) +
  ter-deploy ke env dev. Inilah titik di mana task mobile yang bergantung padanya boleh mulai.
- **Kontrak dulu, optimasi nanti.** Untuk live scoring (3.11) mulai dari **polling** (lebih
  sederhana) sebelum naik ke WebSocket/SSE — sesuai mitigasi risiko di timeline gabungan.

---

## 4. Peta Fase ↔ Modul Database

Acuan: [database-design.md §11](database-design.md). Urutan migrasi mengikuti fase timeline.

| Fase | Modul DB yang dibangun | Tabel kunci |
|------|------------------------|-------------|
| **P0** | Modul 0 (Identity & Tenancy) + Modul 8 inti | `organizations`, `users`, `user_profiles`, `user_auth_providers`, `user_settings`, `organization_members`, `user_devices`, `media`, `notifications` |
| **P1** | Modul 1 (TRACK) | `equipment_profiles`, `scoring_session_groups`, `scoring_sessions`, `scoring_ends`, `scoring_arrows`, `personal_bests` |
| **P2** | Modul 5 (parsial) + Modul 0 (extend) + Modul 8 | `posts`, `post_likes`, `comments`, `follows`(seed), `notification_preferences`, `user_verifications`, `organization_members`(klub) |
| **P3** | Modul 2 (COMPETE) + Modul 3 (RANKING) + `payments`(event) | `events`, `event_divisions`, `event_registrations`, `event_staff`, `event_rounds`, `event_scorecards`, `event_results`, `digital_certificates`, `ratings`, `rating_history`, `rating_periods`, `rating_bands`, `payments` |
| **P4** | Modul 5 (lengkap) + Modul 6 (parsial) | `conversations`, `messages`, `club_schedules`, `club_attendances`, `coaches`, `ranges`, `articles`, `achievements`, `user_gamification`, `challenges` |
| **P5** | Modul 7 (MONETIZATION) | `subscription_plans`, `subscriptions`, `subscription_invoices`, `payouts`, `platform_fees`, `ad_campaigns`, `ads`, `sponsored_contents` |
| **P6** | Modul 4 (TRADE) | `stores`, `product_categories`, `products`, `product_variants`, `product_offers`, `shopping_carts`, `orders`, `order_items`, `escrow_transactions`, `order_shipments`, `product_reviews`, `marketplace_disputes`, `promoted_listings` |
| **P7** | Modul 6 (sisa) + AI + white-label | `tutorials`, `training_programs`, `coaching_bookings`, `audit_logs`(override), `organizations.settings`(white-label) |

> Karena PK **ULID** & `organization_id` sudah ada sejak Modul 0 (task 0.2), menambah modul
> belakangan **tidak** memaksa migrasi ulang tabel lama.

---

## Phase 0: Foundation & Boilerplate (Backend)
### 📅 1 – 14 Juni 2026 · Backend share: **7 SP** (dari 14 SP total fase)

> **Tujuan backend**: API base + skema inti + auth siap, sehingga endpoint fitur bisa
> langsung ditambahkan tanpa rework fondasi.

### Prioritas: 🔴 CRITICAL

| # | Task | SP | Detail |
|---|------|----|--------|
| 0.1 | **Setup Laravel API module di monorepo** | 2 | API routes, base controllers, middleware, CORS, rate limiting. Extend dari struktur CirclePro |
| 0.2 | **Database schema design & migration (core)** | 2 | Migrasi Modul 0 + 1 inti. `char(26)` ULID (`HasUlids`), enum PostgreSQL, `timestamptz`. Factory & seeder dasar |
| 0.3 | **API authentication system** | 1.5 | Laravel **Passport** (OAuth2 password grant), token + refresh, device tracking (`user_devices`), `user_auth_providers` |
| 0.6a | **CI/CD — sisi backend** | 0.75 | GitHub Actions: run PHPUnit/Pest, deploy API ke VPS, run migration otomatis |
| 0.8a | **Error handling & logging (backend)** | 0.5 | `AppException` mapping di `DioClient`-counterpart server, structured logging, Sentry (backend) |

### Deliverables Backend Phase 0:
- [x] Laravel API base menerima endpoint baru + auth jalan — **memakai Passport** (bukan Sanctum), sudah ada di starter `circlepro-web`
- [x] Migrasi **Modul 0** (organizations, user_profiles, user_settings, user_auth_providers, organization_members, user_verifications; `users` di-extend) + **Modul 8 inti** (media, notification_preferences) — _selesai lokal; deploy menyusul_
- [ ] Pipeline CI backend hijau (test + deploy) — _pipeline pre-existing; deploy belum dijalankan_

> **Catatan ID:** strategi **hybrid** — tabel ManahPro baru pakai ULID `char(26)`, `users` tetap bigint. Enum disimpan sebagai kolom `string` + cast PHP enum (`app/Support/Enums`), bukan enum native PG.

### 🤝 Kontrak yang dibuka untuk Mobile:
- Endpoint auth (`/auth/*`), shape token/refresh → dipakai task mobile 0.4 (arsitektur) & 2.1b.

### 🎯 AI Agent Leverage:
- Generate migration dari `database-design.dbml`, base repository/controller/model, CI YAML.

---

## Phase 1: Scoring System (Backend)
### 📅 15 Juni – 19 Juli 2026 · Backend share: **13 SP** (dari 35 SP total fase)

> **Tujuan backend**: Persistensi & analitik scoring + **sync idempotent** untuk offline-first.
> Ini fase **mobile-heavy** — backend relatif ringan, manfaatkan untuk mematangkan kontrak sync.

### Prioritas: 🔴 CRITICAL (North Star)

#### Minggu 1-2: Scoring API
| # | Task | SP | Detail |
|---|------|----|--------|
| 1.1 | **Scoring Session API** | 2 | CRUD sessions (jarak, bow type, arrows). Payload offline-compatible (terima ULID dari klien) |
| 1.2 | **Score Entry API** | 2 | Record per end/rambahan, validasi (M,1-10,X), auto end-total, running total, average |
| 1.3 | **Session Analytics API** | 2 | Stats per sesi: average, grouping consistency, deteksi PB, komparasi sesi sebelumnya |

#### Minggu 3-4: History, Dashboard, Sync
| # | Task | SP | Detail |
|---|------|----|--------|
| 1.7 | **History API** | 1.5 | List sessions + filter (date range, bow type, distance), pagination, search |
| 1.9 | **Progress Dashboard API** | 2 | Agregasi: weekly/monthly avg, trend, best scores, total sessions/arrows |
| 1.11a | **Bow Setup API** | 1 | CRUD `equipment_profiles` (bow model, draw weight, arrow specs), link ke sessions |
| 1.13a | **Sync endpoint (idempotent)** | 1 | Terima batch offline, dedup via `client_uuid`, set `synced_at`, conflict last-write-wins |

#### Minggu 5: Test & Buffer
| # | Task | SP | Detail |
|---|------|----|--------|
| 1.16a | **Backend unit/feature tests** | 1 | Logika kalkulasi skor, validasi, edge case (all X, all M, partial end) di sisi server |
| 1.18a | **Bug fixing buffer (backend)** | 0.5 | Akumulasi bug minggu 1-4 |

### 🔑 Catatan offline-first (dependency terbalik):
> Di fase ini **mobile boleh mendahului backend**. UI scoring (mobile 1.4–1.6) bekerja penuh
> dari **Drift lokal** dengan ULID di-generate device. Backend hanya perlu siap saat fitur sync
> (1.13) — desain `client_uuid` + agregat ter-cache (`total_score`, `x_count`) sesuai
> [database-design.md §8](database-design.md).

### Deliverables Backend Phase 1:
- [x] Scoring CRUD + analytics API ter-test — `ScoringService` + `ScoringSessionController` (store/show/update/destroy/summary) + `EquipmentProfileController`
- [x] Sync idempotent berfungsi (retry aman, tanpa sesi ganda) — `POST /v1/scoring/sessions/sync`, dedup by `client_uuid`
- [x] History & progress dashboard API siap dikonsumsi — `GET /v1/scoring/sessions` (filter/pagination) + `GET /v1/scoring/dashboard`

> **Verifikasi:** seluruh suite **183 test hijau di PostgreSQL nyata** (termasuk 6 feature test scoring `tests/Feature/Api/ScoringSessionTest.php`), Pint bersih. Migrasi sudah **diterapkan ke DB `circlepro_new`** + org platform ter-seed. Endpoint baru di bawah `/v1/scoring/*` (`auth:api`).
>
> ⚠️ Catatan PG: self-referential FK `organizations.parent_id` dipindah ke `Schema::table()` setelah `create()` (PostgreSQL menolaknya bila inline). Migrasi `assets` lama di-guard agar index GIN/partial hanya jalan di pgsql (membuat fallback SQLite test bisa jalan).

---

## Phase 2: Identity & Social (Backend)
### 📅 20 Juli – 16 Agustus 2026 · Backend share: **10.5 SP** (dari 28 SP total fase)

> **Tujuan backend**: Auth sosial, profil, notifikasi, klub (sebagai `organizations`), feed.
> Masih **mobile-heavy** — backend fokus menyiapkan kontrak yang banyak dikonsumsi UI.

### Prioritas: 🟠 HIGH

| # | Task | SP | Detail |
|---|------|----|--------|
| 2.1a | **Social auth backend** | 1.5 | Verifikasi token Google/Apple, OTP via SMS gateway, link ke `user_auth_providers`, deferred sign-up |
| 2.2 | **User profile API** | 2 | CRUD profil: name, avatar, bio, location, club, bow preferences, social links |
| 2.5 | **Notification system backend** | 2 | FCM integration, `notification_preferences`, templates, batch send |
| 2.7 | **Club data model & API** | 2 | Klub = `organizations` (type=club). CRUD, member via `organization_members`, roles, join/leave/invite |
| 2.10a | **Club-linked scoring (backend)** | 0.5 | Tag sesi sebagai "club practice", masuk activity feed klub |
| 2.11 | **Feed API** | 2 | Post CRUD (text+image polymorphic `media`), like, comment, algoritma feed (kronologis + prioritas klub) |
| 2.13a | **Auto-post dari scoring (backend)** | 0.5 | Generate post dari scorecard saat sesi selesai (`posts.shared_type=scoring_session`) |

### 🤝 Kontrak yang dibuka untuk Mobile:
- `/auth/social`, `/profile`, `/notifications`, `/clubs`, `/feed` → dikonsumsi mobile 2.1b–2.13b.

### Deliverables Backend Phase 2:
- [x] Auth sosial (server-side) — **Google** diimplementasi penuh: `SocialAuthService` verifikasi ID token (`HttpGoogleIdTokenVerifier` via tokeninfo, cek `aud`) → upsert `user_auth_providers` → token Passport via `AuthService::issueTokenForUser`. Config-gated `services.google.client_id` (`GOOGLE_CLIENT_ID`); jika kosong → `501 SOCIAL_AUTH_NOT_CONFIGURED`. **Apple** masih ditunda (butuh Apple key). Phone OTP + email sudah ada di starter.
- [x] Profil, klub (orgs), feed, notifikasi API siap — `ProfileController` (`/v1/profile`, stats + age_group) · `ClubController` + `ClubService` (directory/CRUD/membership/roles/activity) · `PostController`/`CommentController` (feed + like + komentar + auto-post `shared_type`) · `NotificationPreferenceController`. Migrasi **Modul 5** (posts/comments/likes/follows).

> **Verifikasi:** suite **196 test hijau di PostgreSQL nyata** (Phase 2: `IdentityProfileTest` incl. Google sign-in dgn fake verifier, `ClubTest`, `FeedTest`), Pint bersih, migrasi diterapkan ke `circlepro_new`. Catatan PG: FK self-ref `comments.parent_id` dibuat tanpa constraint (integritas di app layer) untuk menghindari limitasi self-reference PostgreSQL.

### 🎯 Checkpoint: SOFT LAUNCH (v0.1-beta) — ~16 Agustus 2026
> **Kesiapan backend:** scoring + sync, auth, profil, klub, feed, FCM. Deploy API stabil ke env
> beta. Belum: events, ranking, payment, marketplace.

---

## Phase 3: Events & Ranking (Backend)
### 📅 17 Agustus – 18 Oktober 2026 · Backend share: **33 SP** (dari 63 SP total fase)

> **Tujuan backend**: Engine event + **Glicko-2** + live scoring + **payment**. **FASE TERBERAT
> backend** — mulai integrasi payment & desain rating engine sedini mungkin (paling banyak edge case).

### Prioritas: 🔴 CRITICAL (diferensiasi utama)

#### Minggu 1-2: Event Foundation
| # | Task | SP | Detail |
|---|------|----|--------|
| 3.1 | **Event data model & API** | 3 | `events` + `event_divisions` (bow×gender×age×distance), tier S/A/B/C/D, status workflow (draft→…→rated) |
| 3.4a | **Event creation backend** | 1.5 | Persist multi-step (info→schedule→divisions→pricing), admin approval workflow |

#### Minggu 3-4: Registration & Payment
| # | Task | SP | Detail |
|---|------|----|--------|
| 3.6 | **Registration API** | 2 | Register/cancel/waitlist, slot management, division assignment, deadline enforcement |
| 3.7a | **Payment gateway backend** | 2.5 | Midtrans/Xendit: callback handler, status tracking, refund. `payments` polymorphic (payable=event_registration). VA/e-wallet/QRIS |
| 3.9a | **Participant management (backend)** | 1.5 | Approve/reject, export list, bulk notification, data check-in |
| 3.10a | **E-ticket / QR (backend)** | 1 | Generate `qr_code` di `event_registrations`, verifikasi saat check-in |

#### Minggu 5-6: Live Scoring
| # | Task | SP | Detail |
|---|------|----|--------|
| 3.11 | **Live scoring backend** | 4 | Koleksi skor real-time, validasi per scorer, **mulai polling → WebSocket/SSE**, kalkulasi placement otomatis. `event_scorecards` (arrow_values jsonb) + countback `tiebreak_key` |
| 3.14a | **Digital scorecard (backend)** | 1 | Result card resmi, `digital_certificates` + `verification_code` |
| 3.15 | **Event results API** | 2 | Standing final per divisi (`event_results`, `score_distribution`, `tiebreak_key`), generate PDF resmi, arsip |

#### Minggu 7-8: ELO Ranking (Glicko-2)
| # | Task | SP | Detail |
|---|------|----|--------|
| 3.16 | **Rating engine (Glicko-2)** | 5 | Implementasi [elo-ranking-system.md](elo-ranking-system.md): virtual pairwise, NPS, sigmoid differential, update μ/φ/σ, K-factor, SoF |
| 3.17 | **Rating data model & history** | 2 | `ratings` (uq_rating_scope per org×divisi), `rating_history` (before/after), `rating_periods`, decay cron bulanan |
| 3.18 | **National leaderboard API** | 2 | `idx_leaderboard`, filter (divisi/gender/age/region), keyset pagination, search nama |

#### Minggu 9: Anti-gaming, Test & Buffer
| # | Task | SP | Detail |
|---|------|----|--------|
| 3.21 | **Anti-gaming mechanisms** | 2 | Deteksi sandbagging, SoF, minimum participant threshold, verifikasi akun (`user_verifications`) |
| 3.22 | **Calibration mode** | 1 | "Silent rating": hitung tapi belum tampil publik. Dashboard validasi internal |
| 3.23a | **Integration testing (backend)** | 1 | E2E server: create event → register → live score → results → rating update |
| 3.24 | **Performance & stress test** | 1 | Live scoring 50+ archer concurrent (simulasi) |
| 3.25a | **Bug fixing buffer (backend)** | 0.5 | Akumulasi bug |

### 🤝 Kontrak yang dibuka untuk Mobile:
- `/events`, `/registrations`, `/payments`, `/live-scoring` (channel realtime), `/leaderboard`,
  `/ratings/{user}` → dikonsumsi mobile 3.2–3.20.

### Deliverables Backend Phase 3:
- [ ] Event + registration + payment (VA/e-wallet/QRIS) jalan end-to-end
- [ ] Live scoring (polling minimal) + results + certificate
- [ ] Glicko-2 engine + national leaderboard (calibration mode)

### 🎯 Checkpoint: PUBLIC LAUNCH (v1.0) — ~18 Oktober 2026
> **Kesiapan backend:** semua di atas + rating dalam mode kalibrasi. Payment gateway production-ready.

---

## Phase 4: Community & Content (Backend)
### 📅 19 Oktober – 15 November 2026 · Backend share: **14 SP** (dari 28 SP total fase)

> **Tujuan backend**: API komunitas lebih kaya + konten + gamification. Beban **seimbang** dengan mobile.

### Prioritas: 🟡 MEDIUM-HIGH

| # | Task | SP | Detail |
|---|------|----|--------|
| 4.1a | **Enhanced feed (backend)** | 1.5 | Rich post (gallery/video/poll), feed algorithm engagement-weighted |
| 4.2a | **Follow system (backend)** | 1 | `follows`, following vs discover feed, follower count |
| 4.3a | **Club enhanced (backend)** | 2 | `club_schedules` (RRULE), `club_attendances`, member stats, club leaderboard |
| 4.4a | **Coach directory (backend)** | 1.5 | `coaches` (spesialisasi, rate, rating), search, verified badge |
| 4.5a | **In-app messaging (backend)** | 2 | `conversations`/`messages`, real-time WebSocket, moderasi dasar |
| 4.6a | **Range finder (backend)** | 1 | `ranges` (geo lat/lng, fasilitas jsonb), pencarian radius |
| 4.7a | **Article/content system (backend)** | 1.5 | `articles` + `article_categories`, rich text, reading time, publish workflow |
| 4.8a | **Islamic content (backend)** | 0.5 | `articles.is_islamic`, referensi hadith, seksi khusus Sunnah |
| 4.9a | **Achievement system (backend)** | 1.5 | `achievements` (`criteria` jsonb), `user_achievements`, progress tracking |
| 4.10a | **Gamification (backend)** | 1 | `user_gamification` (XP/level/streak), `challenges`/`challenge_participations` |
| 4.11a | **Bug fixing (backend)** | 0.5 | Akumulasi bug |

### Deliverables Backend Phase 4:
- [ ] API: rich feed, follow, club schedule/attendance, coach, messaging, range, content, achievements, gamification

---

## Phase 5: Monetization (Backend)
### 📅 16 November – 6 Desember 2026 · Backend share: **12 SP** (dari 21 SP total fase)

> **Tujuan backend**: Aktifkan revenue stream non-marketplace. Backend-heavy (billing, ledger, lifecycle).

### Prioritas: 🔴 CRITICAL (revenue)

| # | Task | SP | Detail |
|---|------|----|--------|
| 5.1a | **Subscription billing (backend)** | 2.5 | `subscription_plans`/`subscriptions` (polymorphic user/org), validasi receipt Google Play + Apple IAP, feature gating |
| 5.2a | **Premium gating (backend)** | 1 | Enforce limit (free=3 scoring/minggu), flag fitur per tier (`features`/`limits` jsonb) |
| 5.3a | **Club SaaS subscription (backend)** | 2 | Tier Starter/Professional/Enterprise, billing level-org, dashboard pembayaran admin klub |
| 5.4a | **Event fee processing (backend)** | 1.5 | Platform fee 5% di registrasi, `platform_fees` ledger, `payouts` ke organizer |
| 5.6a | **Ads framework (backend)** | 0.5 | `ad_campaigns`/`ads`, targeting jsonb, frequency cap, exclude premium |
| 5.7 | **Revenue dashboard (admin)** | 2 | Tracking revenue, subscription analytics, churn, MRR/ARR |
| 5.8 | **Subscription lifecycle** | 2 | Grace period, dunning (retry gagal bayar), cancellation, reactivation, proration |
| 5.9a | **Testing & bug fix (backend)** | 0.5 | Payment edge case, subscription state machine |

### Deliverables Backend Phase 5:
- [ ] Billing subscription (user + club) + receipt validation
- [ ] Event platform fee + payout + `platform_fees` ledger
- [ ] Revenue admin dashboard + lifecycle (dunning/grace/proration)

### 🎯 Checkpoint: REVENUE LAUNCH (v1.5) — ~6 Desember 2026
> **Kesiapan backend:** subscription live, IAP/Play receipt validation, fee processing, ads serving.

---

## Phase 6: Marketplace (Backend)
### 📅 7 Desember 2026 – 31 Januari 2027 · Backend share: **32.5 SP** (dari 56 SP total fase)

> **Tujuan backend**: Marketplace + **escrow** + order state machine + fraud. **Fase terberat kedua**
> backend — escrow & payment edge case kompleks.

### Prioritas: 🟡 MEDIUM

#### Minggu 1-2: Foundation
| # | Task | SP | Detail |
|---|------|----|--------|
| 6.1 | **Product data model & API** | 3 | `products`/`product_variants`, kategori berjenjang, multi-image (`media`), specs jsonb, condition |
| 6.2a | **Seller onboarding (backend)** | 1 | `stores` (C2C/business), verifikasi, seller dashboard data |
| 6.4a | **Browse & search (backend)** | 1.5 | Filter (kategori/harga/kondisi/lokasi), sort, index `(bow_class, condition)` & `(province, city)` |

#### Minggu 3-4: Transaction
| # | Task | SP | Detail |
|---|------|----|--------|
| 6.6a | **Cart & checkout (backend)** | 1.5 | `shopping_carts`/`cart_items`, checkout (split 1 order = 1 store), snapshot harga |
| 6.7 | **Escrow payment system** | 4 | `escrow_transactions`: buyer bayar → dana ditahan → seller kirim → buyer konfirmasi → rilis. Dispute & refund |
| 6.8a | **Shipping integration (backend)** | 1.5 | RajaOngkir (ongkir, `rajaongkir_city_id`), `order_shipments` tracking |
| 6.9a | **Order management (backend)** | 2 | State machine (pending→paid→shipped→delivered→completed), riwayat transaksi |

#### Minggu 5-6: Trust & Review
| # | Task | SP | Detail |
|---|------|----|--------|
| 6.10a | **Review & rating (backend)** | 1.5 | `product_reviews` (hanya pembeli, `order_item_id` unik), rating seller, moderasi |
| 6.11a | **Seller verification (backend)** | 1 | Verified badge, KTP, izin toko, `trust_score` |
| 6.12a | **Offer & negotiation (backend)** | 1.5 | `product_offers`: tawar, counter, accept/reject, expiry |
| 6.13a | **Promoted listings (backend)** | 1 | `promoted_listings`, placement algorithm, link ke `payments` |
| 6.14 | **Equipment recommendation** | 2 | Rekomendasi by bow type, level, browsing history |
| 6.15a | **Dispute resolution (backend)** | 1 | `marketplace_disputes`/`dispute_evidences`, mediation workflow |

#### Minggu 7-8: Hardening
| # | Task | SP | Detail |
|---|------|----|--------|
| 6.16 | **Fraud prevention** | 3 | Deteksi listing mencurigakan, rate limiting, report system (`reports`), seller blacklist |
| 6.17 | **Marketplace admin dashboard** | 3 | Moderasi produk, manajemen seller, monitoring transaksi, handling dispute |
| 6.18a | **E2E testing (backend)** | 1.5 | Full flow server: list→buy→pay→ship→deliver→review |
| 6.19a | **Performance optimization (backend)** | 1 | Search performance, pagination tuning, CDN image |
| 6.20a | **Bug fixing buffer (backend)** | 1.5 | Payment edge case & state machine kompleks |

### Deliverables Backend Phase 6:
- [ ] Marketplace API + escrow + shipping (RajaOngkir) + order state machine
- [ ] Review, seller verification, offer, promoted, dispute, fraud, admin dashboard

### 🎯 Checkpoint: MARKETPLACE LAUNCH (v2.0) — ~31 Januari 2027

---

## Phase 7: Advanced & AI (Backend)
### 📅 Februari – Juni 2027 (Ongoing, modular)

> Dikerjakan berdasarkan prioritas bisnis & feedback. Estimasi SP kasar, porsi backend saja.

| # | Task | Backend SP (≈) | Detail backend |
|---|------|:-:|--------|
| 7.1 | **AI Target Recognition** | 12–15 | ML model training, edge/inference API, pipeline foto→skor. **Bisa di-outsource/partnership** |
| 7.2 | **Training program builder** | 4 | `training_programs`/`items`, `program_enrollments`/`progress` |
| 7.3 | **1-on-1 coaching booking** | 5 | `coach_availabilities`/`coaching_bookings`, payment + commission |
| 7.4 | **Video tutorial platform** | 3 | `tutorials` (`is_premium` gating), hosting/transcoding integration |
| 7.5 | **Advanced analytics (AI)** | 5 | Weakness detection, improvement suggestion, performance prediction |
| 7.6 | **White-label scoring** | 4 | API + `organizations.settings` (tema/branding/fitur), leaderboard per-tenant |
| 7.7 | **Multi-language** | 1 | i18n payload, konten EN |
| 7.8 | **Brand partnership dashboard** | 3 | `sponsored_contents`, analytics brand, campaign tracking |
| 7.9 | **Admin super-dashboard** | 6 | User mgmt, moderasi, analytics, laporan keuangan |
| 7.10 | **Performance & scalability** | 5 | Optimasi query, Redis cache, CDN, load test |

---

## 13. Risiko Khusus Backend

| Risiko | Probabilitas | Impact | Mitigasi |
|--------|-------------|--------|----------|
| **Payment gateway complexity** | Medium | Tinggi | Mulai integrasi di **minggu 1 Phase 3** (bukan akhir). Test callback & refund di sandbox dulu |
| **Glicko-2 bugs** | Medium | Tinggi | Calibration/silent mode. Unit test ekstensif + spot-check manual vs contoh di [elo-ranking-system.md](elo-ranking-system.md) |
| **Real-time live scoring** | Medium | Medium | Mulai **polling**, naikkan ke WebSocket/SSE bila perlu. MVP boleh refresh manual |
| **Escrow & order state machine** | Medium | Tinggi | Modelkan state secara eksplisit, test tiap transisi + edge case refund/dispute |
| **Infrastructure scaling** | Rendah (awal) | Medium | VPS cukup 0–10k user. Plan upgrade ke cloud saat mendekati 50k. Pertimbangkan Redis + keyset pagination |
| **Polymorphic tanpa FK** | Rendah | Medium | Integritas dijaga di app layer; validasi `type` via enum; index `(*_type, *_id)` wajib (lihat [database-design.md §9](database-design.md)) |

---

*Living document — update tiap 2 minggu. Pasangan: [development-timeline-mobile.md](development-timeline-mobile.md). Sumber: [development-timeline.md](development-timeline.md), [database-design.md](database-design.md), [elo-ranking-system.md](elo-ranking-system.md).*

*Dibuat: 29 Mei 2026 · Track Backend (Laravel) · 1 developer + AI Agent (kalender bersama dengan track mobile)*
