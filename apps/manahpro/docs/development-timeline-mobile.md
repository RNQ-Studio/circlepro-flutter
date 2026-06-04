# ManahPro — Development Timeline (MOBILE / Flutter)
## Track Mobile dari Timeline 1 Developer + AI Agent

> **Dokumen ini adalah _view mobile_** dari [development-timeline.md](development-timeline.md) (timeline gabungan).
> Isinya **hanya task Flutter/UI/state/offline-first**. Track backend ada di
> [development-timeline-backend.md](development-timeline-backend.md).

> **Konteks**: Tetap **satu developer full-stack** yang sama mengerjakan backend **dan** mobile
> pada **kalender yang sama** (~8.5 bulan, Jun 2026 → Jan 2027). Pemisahan ini **bukan** untuk
> menambah orang — melainkan agar tiap disiplin bisa di-_track_ dan di-fokus-kan secara terpisah.
> Per fitur, mobile umumnya **mengonsumsi kontrak API yang sudah disiapkan backend** lebih dulu
> (lihat [§Pola Dependency](#pola-dependency-mobile-mengikuti-kontrak)).

> **Stack mobile**: Flutter + Riverpod (generator) + go_router + Drift (offline) + Dio.
> Acuan desain: [ui-ux-design-guide.md](ui-ux-design-guide.md). Arsitektur monorepo & konvensi: [CLAUDE.md](../../../CLAUDE.md).

---

## Daftar Isi

1. [Cara Membaca Bersama Track Backend](#1-cara-membaca-bersama-track-backend)
2. [Pembagian Beban per Fase](#2-pembagian-beban-per-fase)
3. [Pola Dependency (Mobile Mengikuti Kontrak)](#pola-dependency-mobile-mengikuti-kontrak)
4. [Prinsip Mobile Lintas-Fase](#4-prinsip-mobile-lintas-fase)
5. [Phase 0: Foundation & Boilerplate (Mobile)](#phase-0-foundation--boilerplate-mobile)
6. [Phase 1: Scoring System (Mobile)](#phase-1-scoring-system-mobile)
7. [Phase 2: Identity & Social (Mobile)](#phase-2-identity--social-mobile)
8. [Phase 3: Events & Ranking (Mobile)](#phase-3-events--ranking-mobile)
9. [Phase 4: Community & Content (Mobile)](#phase-4-community--content-mobile)
10. [Phase 5: Monetization (Mobile)](#phase-5-monetization-mobile)
11. [Phase 6: Marketplace (Mobile)](#phase-6-marketplace-mobile)
12. [Phase 7: Advanced & AI (Mobile)](#phase-7-advanced--ai-mobile)
13. [Risiko Khusus Mobile](#13-risiko-khusus-mobile)

---

## 1. Cara Membaca Bersama Track Backend

- **Tanggal & milestone identik** di kedua file — karena dikerjakan 1 orang di 1 kalender.
  Yang berbeda hanya **daftar task** (di sini: mobile saja).
- **SP mobile + SP backend = SP fase gabungan.** Task `Both` di timeline asli sudah dipecah
  menjadi porsi mobile (di file ini) dan porsi backend (di file backend). Sufiks `b` = mobile,
  `a` = backend.
- **Mobile mengikuti kontrak.** Dalam satu fase, task mobile yang menyentuh API sebaiknya mulai
  **setelah** endpoint terkait di-deploy ke env dev (definisi "selesai" task backend).
- **Pengecualian (Phase 1):** scoring UI **boleh mendahului** backend karena offline-first
  (ULID + Drift di device). Lihat catatan di Phase 1.

---

## 2. Pembagian Beban per Fase

| Fase | Periode | Backend SP | **Mobile SP** | Total SP |
|------|---------|:-:|:-:|:-:|
| **P0** Foundation | 1 – 14 Jun 2026 | 7 | **7** | 14 |
| **P1** Scoring MVP | 15 Jun – 19 Jul 2026 | 13 | **22** | 35 |
| **P2** Identity & Social | 20 Jul – 16 Aug 2026 | 10.5 | **17.5** | 28 |
| **P3** Events & Ranking | 17 Aug – 18 Oct 2026 | 33 | **30** | 63 |
| **P4** Community & Content | 19 Oct – 15 Nov 2026 | 14 | **14** | 28 |
| **P5** Monetization | 16 Nov – 6 Dec 2026 | 12 | **9** | 21 |
| **P6** Marketplace | 7 Dec 2026 – 31 Jan 2027 | 32.5 | **23.5** | 56 |
| **TOTAL P0–6** | | 122 | **123** | 245 |

> **Insight beban mobile:** **memuncak di Phase 1 & 2** (22 + 17.5 SP) — fase ini didominasi UI
> (Scoring screen, profil, klub, feed). Score Input Screen (1.5) sendiri = **4 SP**, layar
> terpenting di seluruh app. Phase 3 & 6 tetap besar (banyak screen event & marketplace) tapi di
> sana backend yang memimpin, jadi mobile menyusul integrasi.

---

## Pola Dependency (Mobile Mengikuti Kontrak)

Karena 1 orang mengerjakan dua sisi secara bergantian, alur per fitur:

```
Backend  : DESIGN KONTRAK → MIGRASI → ENDPOINT + TEST → deploy dev  ──┐
                                                                       │ kontrak final
Mobile   :                                          ┌──────────────────┘
           UI + STATE (Riverpod) → integrasi Dio → empty/error/loading state → widget test
```

- **Sebelum endpoint siap**, mobile tetap bisa maju dengan: membangun **UI + state dengan data
  mock/fixture**, lalu tukar ke API saat kontrak final. Ini mengurangi waktu idle.
- **Definisi "selesai" task mobile** = UI sesuai [ui-ux-design-guide.md](ui-ux-design-guide.md),
  state lengkap (`AsyncValue.when` loading/error/data), terintegrasi API nyata, widget test lulus.
- **Konvensi wajib** (lihat [CLAUDE.md](../../../CLAUDE.md)): Riverpod `@riverpod` generator,
  `context.go/push`, error via `AppException`, data sensitif di `SecureStorageService`,
  offline/cache di Drift `AppDatabase`, barrel export di-update.

---

## 4. Prinsip Mobile Lintas-Fase

Berlaku di semua fase, bukan task tersendiri:

- **Offline-first** — scoring & cache pakai Drift; ULID di-generate device; sync via outbox queue,
  konflik last-write-wins per `client_uuid` (lihat [database-design.md §8](database-design.md)).
- **Design system** — semua layar memakai token `AppColors`/`AppSpacing`/`AppTypography` dari
  [ui-ux-design-guide.md](ui-ux-design-guide.md); dukung light/dark sejak awal.
- **Performa** — target 60fps di layar interaktif (terutama Score Input), minimkan rebuild.
- **Outdoor readability** — high-contrast & font besar untuk visibilitas di bawah sinar matahari.

---

## Phase 0: Foundation & Boilerplate (Mobile)
### 📅 1 – 14 Juni 2026 · Mobile share: **7 SP** (dari 14 SP total fase)

> **Tujuan mobile**: Arsitektur Flutter, design system, dan layer offline siap, sehingga fitur
> bisa langsung dibangun di atas fondasi yang konsisten.

### Prioritas: 🔴 CRITICAL

| # | Task | SP | Detail |
|---|------|----|--------|
| 0.4 | **Flutter project architecture setup** | 2 | Feature-first folder, go_router, Riverpod (generator), tema light/dark, integrasi Dio + token Passport (bearer) (dari backend 0.3) |
| 0.5 | **Design system implementation** | 2 | `AppColors`, `AppSpacing`, `AppTypography`, component tokens sesuai [ui-ux-design-guide.md](ui-ux-design-guide.md) §3 |
| 0.7 | **Offline-first infrastructure** | 2 | Drift (`AppDatabase`), sync queue/outbox, connectivity detection, pola optimistic UI |
| 0.6b | **CI/CD — sisi mobile** | 0.75 | GitHub Actions/Fastlane: auto build APK, run flutter test |
| 0.8b | **Error handling (mobile)** | 0.5 | Flutter error boundaries, Crashlytics, pola `AsyncValue.when` |

### ⛓️ Menunggu dari Backend:
- Endpoint auth + shape token (backend 0.3) untuk dipasang di Dio interceptor.

### Deliverables Mobile Phase 0:
- [x] App run dengan design system lengkap + dark/light theme — **ManahPro app-level** (`apps/manahpro/lib/theme/`: `ManahColors/ManahSpacing/ManahRadius/ManahTextStyles/ManahTheme`), ter-wire di `App`; `packages/core` tak diubah (aman untuk `variant`)
- [x] Layer offline (Drift) + sync queue ready — `ScoringDatabase` (Drift) + outbox via flag `isSynced`/`syncAction` di repository scoring
- [ ] CI build APK hijau — _pipeline pre-existing; belum dijalankan ulang_

> Arsitektur Flutter (Riverpod/go_router/Dio/Drift) **sudah ada di starter** dan dipakai-ulang.

### 🎯 AI Agent Leverage:
- Generate design token Dart dari spec UI/UX, boilerplate Riverpod notifier, konfigurasi CI mobile.

---

## Phase 1: Scoring System (Mobile)
### 📅 15 Juni – 19 Juli 2026 · Mobile share: **22 SP** (dari 35 SP total fase)

> **Tujuan mobile**: Core value proposition. **FASE TERBERAT mobile.** Score Input Screen harus
> super cepat (< 3 detik/panah), bisa 1 tangan, dan **jalan penuh offline**.

### Prioritas: 🔴 CRITICAL (North Star)

#### Minggu 1-2: Scoring UI
| # | Task | SP | Detail |
|---|------|----|--------|
| 1.4 | **Scoring Session Setup Screen** | 2 | Pilih distance, bow type, jumlah arrow/end, target face. Quick-start dengan default terakhir |
| 1.5 | **Score Input Screen** | 4 | **LAYAR TERPENTING.** Number pad (M,1-10,X), arrow slots, navigasi end, running total, haptic, undo. 1 tangan, < 3 detik/panah. **Full offline (Drift)** |
| 1.6 | **Session Summary Screen** | 2 | Total skor, average/end, chart per-end, notifikasi PB, share scorecard |

#### Minggu 3-4: History, Dashboard, Sync Client
| # | Task | SP | Detail |
|---|------|----|--------|
| 1.8 | **History Screen** | 2 | List sesi by date, detail (skor/end, notes), bandingkan 2 sesi |
| 1.10 | **Progress Dashboard Screen** | 3 | Line chart (skor over time), bar chart mingguan, PB tracker, consistency index, streak (fl_chart) |
| 1.11b | **Bow Setup UI** | 1 | UI CRUD equipment profile, link ke sesi |
| 1.12 | **Shareable Scorecard** | 2 | Generate gambar scorecard cantik (share IG/WA), watermark ManahPro. **Viral loop trigger** |
| 1.13b | **Offline sync client** | 0.5 | Outbox queue, push batch saat online, konsumsi sync endpoint (backend 1.13a) |

#### Minggu 5: Polish & Test
| # | Task | SP | Detail |
|---|------|----|--------|
| 1.14 | **Scoring UX polish** | 2 | Micro-animation (score pop, end transition, PB celebration), sound, haptic tuning |
| 1.15 | **Outdoor readability test** | 1 | High contrast mode, font sizes, sunlight visibility |
| 1.16b | **Widget tests** | 1 | Test logika input skor di UI, edge case (all X, all M, partial end) |
| 1.17 | **Performance optimization** | 1 | Profil Score Input: 60fps, memory, minim rebuild |
| 1.18b | **Bug fixing buffer (mobile)** | 0.5 | Akumulasi bug minggu 1-4 |

### 🔑 Catatan offline-first (boleh mendahului backend):
> Scoring UI (1.4–1.6) bekerja penuh dari **Drift lokal** tanpa menunggu API. Integrasi sync
> (1.13b) menyusul saat sync endpoint backend siap. Manfaatkan ini agar mobile tidak idle.

### Deliverables Mobile Phase 1:
- [x] Scoring input super cepat, full offline — alur **Setup → Score Input → Summary** (`lib/features/scoring/`), ULID di device, sync client; layar inti: number pad M/1-10/X, slot panah, undo, haptic, auto-advance end, running total
- [x] Analytics dashboard dengan charts — **Statistik** (`progress_dashboard_screen.dart`) line chart `fl_chart` + stat tiles + streak, di-derive lokal dari sesi offline
- [x] Shareable scorecard (viral loop) — `scorecard.dart` (branded) di-render → PNG via RepaintBoundary → **Bagikan via OS share-sheet** (`share_plus`) + Simpan (`path_provider`). _Butuh `dependency_overrides: win32: ^6.0.1` di pubspec root (Android/iOS tak pakai win32)._
- [x] History & comparison, bow setup logger — **History** (list + filter busur, tap → resume/summary) + **Bow Setup** (equipment CRUD online, terintegrasi sebagai pilihan opsional di Setup)
- [x] 1.14 polish — `SystemSound.click` + haptic per panah (mediumImpact X/10), heavy haptic saat PB, animasi scale+fade PB banner
- [ ] 🚧 Sisa (butuh device fisik): 1.15 uji outdoor terukur, 1.17 profiling 60fps

> **Verifikasi:** `flutter analyze` 0 error/0 warning untuk kode scoring; 7 unit test (`test/scoring/scoring_entities_test.dart`) hijau; Drift + Riverpod codegen sukses. **Status detail lihat [development-timeline.md](development-timeline.md) §Status Implementasi.**

---

## Phase 2: Identity & Social (Mobile)
### 📅 20 Juli – 16 Agustus 2026 · Mobile share: **17.5 SP** (dari 28 SP total fase)

> **Tujuan mobile**: User experience lengkap + fondasi sosial agar app terasa "hidup".

### Prioritas: 🟠 HIGH

| # | Task | SP | Detail |
|---|------|----|--------|
| 2.1b | **Social auth UI** | 1.5 | Google Sign-In SDK, input OTP HP, **deferred sign-up flow** (UI/UX guide). ~~Apple Sign-In dihapus dari scope~~ |
| 2.3 | **Profile screen** | 3 | Avatar & banner, rating card (placeholder), stats, achievements, bow setup, edit profile |
| 2.4 | **Onboarding flow** | 2 | Maks 3 layar: Welcome → Bow type → First score CTA (UI/UX guide §7) |
| 2.6 | **Notification UI** | 2 | Bell, list notifikasi, read/unread, deep link dari notifikasi |
| 2.8 | **Club directory screen** | 2 | Search/filter klub by lokasi/nama, club card + member count, join request flow |
| 2.9 | **Club detail & management** | 3 | Club home, member list, schedule dasar, info. Admin: approve member, edit info |
| 2.10b | **Club-linked scoring UI** | 0.5 | Opsi tag sesi sebagai "club practice", tampil di activity feed klub |
| 2.12 | **Community feed screen** | 3 | Post card (avatar, text, image, like/comment), create post, comment thread dasar |
| 2.13b | **Auto-post dari scoring UI** | 0.5 | Opsi "Share to feed" setelah sesi selesai, auto-isi scorecard |

### ⛓️ Menunggu dari Backend:
- `/auth/social`, `/profile`, `/clubs`, `/feed`, `/notifications` (backend 2.1a–2.13a).

### Deliverables Mobile Phase 2:
- [x] Auth UI — email + OTP HP (starter) + **Google sign-in mobile berjalan lancar** (`google_sign_in` plugin). ~~Apple sign-in dihapus dari scope.~~
- [x] Rich profile + **Onboarding** — **Profil** (`features/identity/`: view + edit, stats, busur, lokasi) + **Onboarding ManahPro** 3-layar (`features/onboarding/manah_onboarding_screen.dart`, override route `/onboarding`).
- [x] Club directory & management UI + community feed UI + **Notification UI** — **Klub** (`features/clubs/`) · **Komunitas** (`features/feed/`) + Share-to-Feed (2.13b) · **Notifikasi** (`features/notifications/`: list + mark read + Preferensi toggle push/email per kategori).

> **Verifikasi:** `flutter analyze` 0 error/0 warning untuk semua kode Phase 2 (identity/clubs/feed/notifications/onboarding). Fitur online (Dio + token Passport) via shared `manahDioProvider`; codegen Riverpod sukses. Base URL: `https://circlepro.web.id/api/`.

### 🎯 Checkpoint: SOFT LAUNCH (v0.1-beta) — ~16 Agustus 2026
> **Kesiapan app:** scoring (offline+online), registrasi & profil, club directory & join, feed,
> push notif, shareable scorecard. Deploy ke Play Store (closed testing), invite 20-30 beta tester.

---

## Phase 3: Events & Ranking (Mobile)
### 📅 17 Agustus – 18 Oktober 2026 · Mobile share: **30 SP** (dari 63 SP total fase)

> **Tujuan mobile**: Layar discovery/registrasi event, live scoreboard, leaderboard,
> rating card. Banyak screen — backend memimpin kontrak, mobile mengikuti.

### Prioritas: 🔴 CRITICAL

#### Minggu 1-2: Event Foundation
| # | Task | SP | Detail |
|---|------|----|--------|
| 3.2 | **Event discovery screen** | 3 | Event card (tanggal, lokasi, tier badge, divisi), filter, toggle calendar view |
| 3.3 | **Event detail screen** | 3 | Hero image, info chips, capacity bar, tabs (About/Schedule/Participants), sticky CTA "Daftar" (UI/UX §6.3) |
| 3.4b | **Event creation form (organizer)** | 1.5 | Multi-step form: info → schedule → divisions → pricing → preview → publish |
| 3.5 | **My Events screen** | 2 | Tabs: Registered/In Progress/Completed, status cards |

#### Minggu 3-4: Registration
| # | Task | SP | Detail |
|---|------|----|--------|
| ~~3.7b~~ | ~~**Payment UI**~~ | ~~1.5~~ | ~~DIHAPUS DARI SCOPE — tidak ada payment gateway~~ |
| 3.8 | **Registration flow UI** | 3 | Select division → confirm → confirmation. Order summary |
| 3.9b | **Participant management UI (organizer)** | 1.5 | View peserta, approve/reject, export, bulk notif, UI check-in |
| 3.10b | **E-ticket / QR UI** | 1 | Tampil e-ticket + QR, scanner check-in |

#### Minggu 5-6: Live Scoring
| # | Task | SP | Detail |
|---|------|----|--------|
| 3.12 | **Scorer interface** | 3 | UI scorer: pilih archer → input skor/end → submit (mirip scoring pribadi, multi-archer) |
| 3.13 | **Live scoreboard (spectator)** | 3 | Leaderboard real-time, follow archer, update end-by-end, auto-refresh |
| 3.14b | **Digital scorecard UI** | 1 | Tampil result card resmi + sertifikat, share ke sosmed |

#### Minggu 7-8: Ranking UI
| # | Task | SP | Detail |
|---|------|----|--------|
| 3.19 | **Leaderboard screen** | 3 | National ranking, filter tabs, highlight posisi-ku, detail archer → profil |
| 3.20 | **Rating card & profile integration** | 2 | Display rating (μ−2φ), badge (Diamond/Gold/…), trend chart, confidence indicator, breakdown divisi |

#### Minggu 9: Test & Buffer
| # | Task | SP | Detail |
|---|------|----|--------|
| 3.23b | **Integration testing (mobile)** | 1 | E2E app: daftar → live score → lihat hasil → rating update |
| 3.25b | **Bug fixing buffer (mobile)** | 0.5 | Akumulasi bug |

### ⛓️ Menunggu dari Backend:
- `/events`, `/registrations`, channel live-scoring, `/leaderboard`, `/ratings`
  (backend 3.1–3.20). Untuk live scoreboard, mulai dari **polling** (sinkron dengan backend 3.11).

### Deliverables Mobile Phase 3 (status per 4 Jun 2026 — ~90% selesai):
- [x] Event discovery, detail, calendar; registration UI
- [x] Scorer interface + live scoreboard; digital scorecard
- [x] National leaderboard + rating card di profil
- [x] E-ticket / QR check-in + participant management (organizer)
- [ ] 🚧 E2E integration testing

> ~~Payment UI (3.7b) dihapus dari scope~~ — tidak ada payment gateway.
> 13 screen events lengkap di `features/events/`.

### 🎯 Checkpoint: PUBLIC LAUNCH (v1.0) — **~Agustus–September 2026** (dimajukan dari Oktober)
> **Kesiapan app:** semua dari soft launch + event/registration + live scoring + leaderboard.
> Full Play Store launch. Submit iOS **2 minggu sebelum** target (antisipasi review).

---

## Phase 4: Community & Content (Mobile)
### 📅 19 Oktober – 15 November 2026 · Mobile share: **14 SP** (dari 28 SP total fase)

> **Tujuan mobile**: UI komunitas lebih kaya + konten + gamification. Beban **seimbang** dengan backend.

### Prioritas: 🟡 MEDIUM-HIGH

| # | Task | SP | Detail |
|---|------|----|--------|
| 4.1b | **Enhanced feed UI** | 1.5 | Image gallery, video embed, poll; feed engagement-weighted |
| 4.2b | **Follow UI** | 1 | Follow/unfollow, following vs discover feed, follower count |
| 4.3b | **Club enhanced UI** | 2 | Schedule management, attendance, member stats dashboard, club leaderboard |
| 4.4b | **Coach directory UI** | 1.5 | Coach profile, search by lokasi/spesialisasi, verified badge |
| ~~4.5b~~ | ~~**In-app messaging UI**~~ | ~~2~~ | ~~DIHAPUS DARI SCOPE — komunikasi via WhatsApp/Telegram~~ |
| 4.6b | **Range finder UI** | 1 | Map-based search (Google Maps), range profile, directions |
| 4.7b | **Article reader UI** | 1.5 | List & detail artikel, kategori, reading time |
| 4.8b | **Islamic content UI** | 0.5 | Seksi konten Sunnah, tampil hadith reference |
| 4.9b | **Achievement UI** | 1.5 | Badge display di profil, progress, unlock celebration |
| 4.10b | **Gamification UI** | 1 | Streak (🔥), weekly challenge, XP, level progression |
| 4.11b | **Bug fixing & polish (mobile)** | 0.5 | Akumulasi bug + polish UI |

### 🪓 Cuttable jika behind schedule (lihat timeline gabungan):
- 4.8b Islamic → cukup tag ·
  4.10b gamification → basic streak saja.

### Deliverables Mobile Phase 4 (status per 4 Jun 2026 — ~70% selesai):
- [x] Follow, club enhanced (schedules+attendance), coach directory, range finder, article reader, achievements & gamification
- [ ] 🚧 Rich feed (gallery/video/poll)
- [ ] 🚧 Islamic content (dedicated section)

> ~~In-app messaging (4.5b) dihapus dari scope~~ — komunikasi via WhatsApp/Telegram.

---

## Phase 5: Monetization (Mobile)
### 📅 16 November – 6 Desember 2026 · Mobile share: **9 SP** (dari 21 SP total fase)

> **Tujuan mobile**: Purchase flow & paywall UX. Backend-heavy — mobile fokus IAP & paywall.

### Prioritas: 🔴 CRITICAL (revenue)

| # | Task | SP | Detail |
|---|------|----|--------|
| 5.1b | **Subscription purchase flow** | 1.5 | Google Play Billing UI, alur beli, restore purchase |
| 5.2b | **Premium gating UI** | 1 | Lock state untuk fitur premium, indikator kuota (free=3 scoring/minggu) |
| 5.3b | **Club SaaS UI** | 1 | Pilih tier klub, dashboard pembayaran admin klub |
| ~~5.4b~~ | ~~**Event fee UI**~~ | ~~0.5~~ | ~~DIHAPUS — tidak ada payment gateway; event gratis/transfer manual~~ |
| 5.5 | **Paywall & upgrade UX** | 3 | Layar upgrade cantik, feature comparison, trial offer, trigger di titik natural (tidak mengganggu) |
| 5.6b | **Ads integration (mobile)** | 1.5 | AdMob/Meta SDK, placement (feed antar post, event list), frequency cap, no ads untuk premium |
| 5.9b | **Testing & bug fix (mobile)** | 0.5 | Subscription edge case di UI, state pembelian |

### ⛓️ Menunggu dari Backend:
- Receipt validation, plans, gating flags, fee (backend 5.1a–5.8).

### Deliverables Mobile Phase 5:
- [ ] Purchase flow (Pro/Elite + Club SaaS), paywall UX, ads untuk free tier.

> ~~Event fee UI (5.4b) dihapus dari scope~~ — tidak ada payment gateway.

### 🎯 Checkpoint: REVENUE LAUNCH (v1.5) — ~Oktober–November 2026 (dimajukan)
> **Kesiapan app:** subscription live di Play Store, ads serving.

---

## Phase 6: Marketplace (Mobile)
### 📅 7 Desember 2026 – 31 Januari 2027 · Mobile share: **23.5 SP** (dari 56 SP total fase)

> **Tujuan mobile**: Layar marketplace lengkap (listing, browse, cart, order tracking, review).
> Backend memimpin escrow & state machine; mobile mengikuti.

### Prioritas: 🟡 MEDIUM

#### Minggu 1-2: Foundation
| # | Task | SP | Detail |
|---|------|----|--------|
| 6.2b | **Seller onboarding UI** | 1 | Registrasi seller, store profile, seller dashboard |
| 6.3 | **Product listing creation** | 3 | Multi-step: photos → kategori → details/specs → pricing → preview → publish |
| 6.4b | **Browse & search UI** | 1.5 | Category grid, search + filter, sort (harga/terbaru/rating) |
| 6.5 | **Product detail screen** | 3 | Photo gallery, deskripsi, specs, seller info, reviews, related, CTA Buy/Make Offer |

#### Minggu 3-4: Transaction
| # | Task | SP | Detail |
|---|------|----|--------|
| 6.6b | **Cart & checkout UI** | 1.5 | Add to cart, cart management, checkout (shipping → payment → confirm) |
| 6.8b | **Shipping UI** | 1.5 | Pilihan kurir & ongkir (RajaOngkir), input resi, konfirmasi terima |
| 6.9b | **Order management UI** | 2 | Status order, buyer & seller dashboard, order detail, riwayat transaksi |

#### Minggu 5-6: Trust & Review
| # | Task | SP | Detail |
|---|------|----|--------|
| 6.10b | **Review & rating UI** | 1.5 | Tulis review (setelah beli), star + text + foto, tampil rating seller |
| 6.11b | **Seller verification UI** | 1 | Badge verified, upload KTP/izin toko, tampil trust score |
| 6.12b | **Offer & negotiation UI** | 1.5 | "Make Offer", counter-offer, accept/reject, expiry |
| 6.13b | **Promoted listings UI** | 1 | Promoted badge, alur beli promosi listing |
| 6.15b | **Dispute resolution UI** | 1 | Filing dispute, upload bukti, tracking resolusi |

#### Minggu 7-8: Hardening
| # | Task | SP | Detail |
|---|------|----|--------|
| 6.18b | **E2E testing (mobile)** | 1.5 | Full flow app: list → browse → buy → pay → ship → deliver → review |
| 6.19b | **Performance optimization (mobile)** | 1 | Image optimization, list virtualization, pagination tuning |
| 6.20b | **Bug fixing buffer (mobile)** | 1.5 | Marketplace bug kompleks (payment edge case, state) |

### ⛓️ Menunggu dari Backend:
- `/products`, `/cart`, `/orders`, escrow, shipping, review, offer, dispute (backend 6.1–6.17).

### 🪓 Cuttable jika behind schedule:
- 6.12b offer/negotiation → fixed price dulu · 6.13b promoted → fokus organic dulu.

### Deliverables Mobile Phase 6:
- [ ] Marketplace UI lengkap (new + bekas), cart/checkout, order tracking, review, seller verif,
      offer, promoted, dispute.

### 🎯 Checkpoint: MARKETPLACE LAUNCH (v2.0) — ~31 Januari 2027

---

## Phase 7: Advanced & AI (Mobile)
### 📅 Februari – Juni 2027 (Ongoing, modular)

> Dikerjakan berdasarkan prioritas bisnis & feedback. Estimasi SP kasar, porsi mobile saja.

| # | Task | Mobile SP (≈) | Detail mobile |
|---|------|:-:|--------|
| 7.1 | **AI Target Recognition** | 4–5 | UI kamera capture foto target, tampil hasil auto-detect skor, koreksi manual |
| 7.2 | **Training program builder** | 4 | UI program latihan, daily/weekly plan, progress tracking |
| 7.3 | **1-on-1 coaching booking** | 5 | Kalender ketersediaan coach, alur booking, integrasi video call |
| 7.4 | **Video tutorial platform** | 3 | Player video, kategori, progress tracking |
| 7.5 | **Advanced analytics (AI)** | 3 | UI insight: weakness detection, saran perbaikan, prediksi performa |
| 7.6 | **White-label theming** | 2 | Tema/branding per-tenant dari `organizations.settings` (varian app) |
| 7.7 | **Multi-language** | 3 | i18n Flutter (ID/EN), pertimbangan RTL |
| 7.8 | **Brand partnership** | 2 | Tampil sponsored content/highlight di app |
| 7.10 | **Performance & scalability** | — | Profiling app berkelanjutan seiring growth |

---

## 13. Risiko Khusus Mobile

| Risiko | Probabilitas | Impact | Mitigasi |
|--------|-------------|--------|----------|
| **Score Input tidak cukup cepat/nyaman** | Medium | Sangat Tinggi | Prototipe dini, uji 1-tangan & < 3 detik/panah, haptic tuning, profiling 60fps. Ini make-or-break app |
| **App Store rejection** | Medium | Medium | Siapkan privacy policy & ToS sejak awal, ikuti Apple guidelines, submit iOS 2 minggu sebelum target |
| **Outdoor readability** | Medium | Medium | High-contrast mode + font besar diuji di bawah sinar matahari (task 1.15) |
| **Konflik sync offline** | Medium | Medium | Last-write-wins per `client_uuid`; sesi jarang diedit 2 device (lihat [database-design.md §8](database-design.md)) |
| **Idle menunggu kontrak backend** | Medium | Rendah | Bangun UI + state dengan mock/fixture dulu, tukar ke API saat kontrak final |
| **Konsistensi design system** | Rendah | Medium | Wajib pakai token `AppColors`/`AppSpacing`/`AppTypography`; jangan hardcode style |

---

*Living document — update tiap 2 minggu. Pasangan: [development-timeline-backend.md](development-timeline-backend.md). Sumber: [development-timeline.md](development-timeline.md), [ui-ux-design-guide.md](ui-ux-design-guide.md), [CLAUDE.md](../../../CLAUDE.md).*

*Dibuat: 29 Mei 2026 · Update terakhir: **4 Juni 2026** · Track Mobile (Flutter) · 1 developer + AI Agent (kalender bersama dengan track backend)*
