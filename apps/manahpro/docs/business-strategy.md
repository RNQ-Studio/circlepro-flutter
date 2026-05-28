# ManahPro — Strategi Bisnis & Monetisasi
## Platform Digital #1 untuk Komunitas Panahan Indonesia

> **Dokumen ini disusun menggunakan metode First Principles Thinking** — mengurai masalah hingga ke elemen paling fundamental, lalu menyusun solusi dari nol tanpa bias asumsi industri yang ada.

---

## Daftar Isi

1. [First Principles Decomposition](#1-first-principles-decomposition)
2. [Analisis Pasar Indonesia](#2-analisis-pasar-indonesia)
3. [Problem-Solution Mapping](#3-problem-solution-mapping)
4. [Arsitektur Produk ManahPro](#4-arsitektur-produk-manahpro)
5. [Strategi Monetisasi](#5-strategi-monetisasi)
6. [Financial Projections & Revenue Target](#6-financial-projections--revenue-target)
7. [Go-to-Market Strategy](#7-go-to-market-strategy)
8. [Competitive Moat](#8-competitive-moat)
9. [Roadmap Eksekusi](#9-roadmap-eksekusi)
10. [Risks & Mitigations](#10-risks--mitigations)

---

## 1. First Principles Decomposition

### Pertanyaan Fundamental

Alih-alih bertanya *"Aplikasi panahan apa yang sudah ada?"*, kita bertanya:

> **"Apa yang secara fundamental dibutuhkan seorang manusia yang memanah, dan bagaimana teknologi bisa menghilangkan friction terbesar di setiap kebutuhan itu?"**

### Dekomposisi Kebutuhan Pemanah

```
PEMANAH (Manusia yang Memanah)
│
├── 🎯 BERLATIH (Skill Improvement)
│   ├── Butuh tahu posisi skill saat ini → Scoring & Analytics
│   ├── Butuh panduan perbaikan → Coaching / Content
│   └── Butuh konsistensi → Habit tracking & Gamification
│
├── 🏆 BERKOMPETISI (Competition)
│   ├── Butuh tahu event yang tersedia → Event Discovery
│   ├── Butuh sistem scoring resmi → Digital Scoring System
│   ├── Butuh ranking yang diakui → National Ranking System
│   └── Butuh bukti prestasi → Digital Certificate & Portfolio
│
├── 🏪 MELENGKAPI ALAT (Equipment)
│   ├── Butuh tahu alat yang tepat → Recommendation Engine
│   ├── Butuh tempat beli/jual → Marketplace
│   └── Butuh review dari sesama → Community Reviews
│
├── 👥 BERKOMUNITAS (Social)
│   ├── Butuh teman latihan → Club & Group Discovery
│   ├── Butuh tempat latihan → Range Finder
│   ├── Butuh mentor → Coach Discovery
│   └── Butuh inspirasi → Feed / Content
│
└── 📿 MOTIVASI SPIRITUAL (Unique to Indonesia)
    ├── Panahan sebagai Sunnah Rasulullah ﷺ
    ├── Butuh konten islami seputar panahan → Islamic Content
    └── Butuh komunitas berbasis masjid/pesantren → Faith-based Communities
```

### Insight Kritis dari Dekomposisi

| # | Insight | Implikasi Bisnis |
|---|---------|-----------------|
| 1 | **Tidak ada platform terpusat** — semua kebutuhan di atas tersebar di WhatsApp, Instagram, dan spreadsheet manual | Peluang menjadi **single platform** (winner-takes-all) |
| 2 | **Motivasi spiritual adalah unique driver** di Indonesia — ini tidak ada di pasar panahan global | Diferensiasi yang **tidak bisa di-copy** oleh platform global |
| 3 | **Scoring & ranking masih manual** — PERPANI dan klub masih pakai kertas/Excel | Peluang **infrastruktur digital** yang sticky |
| 4 | **Marketplace equipment fragmented** di grup WA/IG — tidak ada trust system | Peluang **marketplace dengan escrow** dan review system |
| 5 | **Coach discovery tidak ada** — murid cari coach dari mulut ke mulut | Peluang **coaching marketplace** seperti SuperProf/Preply |

---

## 2. Analisis Pasar Indonesia

### Ukuran Pasar (Market Sizing — Bottom-Up)

```
PERPANI Members (aktif terdaftar)           :   ~50.000 pemanah
Klub independen & komunitas non-PERPANI     :  ~150.000 pemanah
Pemanah rekreasi / casual                   :  ~300.000 orang
Peminat baru (growth per tahun ~15-20%)     :  +~75.000/tahun
                                              ─────────────────
TOTAL ADDRESSABLE MARKET (TAM)              :  ~500.000+ pemanah aktif
```

### Segmentasi Pasar

| Segmen | Estimasi | Karakteristik | Willingness to Pay |
|--------|----------|---------------|-------------------|
| **Atlet Kompetitif** | ~20.000 | High skill, butuh analytics & ranking | Tinggi (Rp 50-200rb/bulan) |
| **Klub & Sasana** | ~2.000 unit | Butuh management tool | Sangat Tinggi (Rp 200rb-1jt/bulan) |
| **Pemanah Hobi Serius** | ~100.000 | Rutin latihan, beli equipment | Sedang (Rp 30-100rb/bulan) |
| **Pemanah Sunnah/Islami** | ~200.000 | Motivasi spiritual, komunitas masjid | Rendah-Sedang (Rp 20-50rb/bulan) |
| **Pemanah Casual/Pemula** | ~180.000 | Baru mulai, butuh guidance | Rendah (Free tier + occasional purchase) |
| **Coach/Pelatih** | ~5.000 | Income dari mengajar | Tinggi (commission-based) |
| **Toko/Supplier Equipment** | ~500 | Butuh channel penjualan | Sangat Tinggi (commission + ads) |

### Growth Drivers Spesifik Indonesia

1. **Faktor Spiritual** — Hadits Nabi ﷺ tentang panahan mendorong pertumbuhan komunitas berbasis masjid & pesantren
2. **Olahraga Olimpiade** — Prestasi atlet Indonesia di Asian Games meningkatkan popularitas
3. **Tren Outdoor/Adventure** — Post-pandemic shift ke aktivitas luar ruangan
4. **Social Media** — Panahan sangat "Instagrammable" → organic growth
5. **Government Support** — PERPANI dan Kemenpora aktif mengembangkan olahraga panahan

---

## 3. Problem-Solution Mapping

### Pain Points Terbesar & Solusi ManahPro

```
┌─────────────────────────────────────────────────────────────────────┐
│ PAIN POINT #1: "Saya tidak tahu seberapa bagus skill saya"         │
│ ─────────────────────────────────────────────────────────────────── │
│ Saat ini   : Catat skor di kertas, tidak ada analytics             │
│ ManahPro   : Digital Scoring + AI Analytics + Progress Dashboard   │
│ Monetize   : Freemium (basic free, advanced analytics = premium)   │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│ PAIN POINT #2: "Susah cari event/turnamen di daerah saya"          │
│ ─────────────────────────────────────────────────────────────────── │
│ Saat ini   : Info dari WA group, sering terlewat                   │
│ ManahPro   : Event Discovery + Registration + Live Scoring         │
│ Monetize   : Ticketing fee (5-10%) + Event organizer SaaS          │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│ PAIN POINT #3: "Mau beli/jual busur tapi tidak ada tempat trusted" │
│ ─────────────────────────────────────────────────────────────────── │
│ Saat ini   : Jual-beli di WA/IG tanpa proteksi                     │
│ ManahPro   : Marketplace + Escrow + Review System                  │
│ Monetize   : Transaction fee (3-5%) + Promoted listings            │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│ PAIN POINT #4: "Klub saya masih manage member pakai spreadsheet"   │
│ ─────────────────────────────────────────────────────────────────── │
│ Saat ini   : Excel/Google Sheet untuk data member, jadwal, iuran   │
│ ManahPro   : Club Management SaaS (member, schedule, payment)      │
│ Monetize   : Monthly subscription per klub                         │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│ PAIN POINT #5: "Tidak ada ranking nasional yang transparan"        │
│ ─────────────────────────────────────────────────────────────────── │
│ Saat ini   : Ranking hanya di level PERPANI, tidak real-time       │
│ ManahPro   : National Digital Ranking System (ELO-based)           │
│ Monetize   : Lock-in effect → drives all other features            │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 4. Arsitektur Produk ManahPro

### Product Pillars (4 Pilar Utama)

```
                    ┌─────────────────────┐
                    │     M A N A H P R O │
                    │   Super App Panahan │
                    └──────────┬──────────┘
                               │
        ┌──────────┬───────────┼───────────┬──────────┐
        │          │           │           │          │
   ┌────▼────┐ ┌───▼───┐ ┌────▼────┐ ┌────▼────┐ ┌──▼───┐
   │  TRACK  │ │ COMPETE│ │  TRADE  │ │ CONNECT │ │ LEARN│
   │ Scoring │ │ Events │ │  Market │ │Community│ │Coach │
   │Analytics│ │Ranking │ │  place  │ │  Clubs  │ │Content│
   └─────────┘ └────────┘ └─────────┘ └─────────┘ └──────┘
```

### Fitur Detail per Pilar

#### 🎯 TRACK — Scoring & Analytics
- **Smart Scoring**: Input skor per end/rambahan dengan UI yang cepat (< 3 detik per entry)
- **Target Face Recognition** (v2): Foto target → AI detect skor otomatis (computer vision)
- **Progress Dashboard**: Grafik perkembangan skor harian/mingguan/bulanan
- **Session Analytics**: Average score, grouping pattern, consistency index
- **Personal Best Tracking**: Record otomatis untuk setiap jarak & tipe busur
- **Bow Setup Logger**: Catat konfigurasi busur, anak panah, dan tuning notes

#### 🏆 COMPETE — Events & Ranking
- **Event Discovery**: Calendar turnamen lokal, regional, nasional
- **Online Registration**: Daftar event + payment dalam app
- **Live Scoring**: Real-time scoring yang bisa diikuti spektator
- **Digital Scorecard**: Hasil resmi yang bisa di-share
- **ELO Ranking System**: Ranking nasional berdasarkan performa kompetisi
- **Achievement Badges**: Gamification untuk milestone (first 300 score, dll)
- **Digital Certificate**: Sertifikat digital untuk podium & achievement

#### 🏪 TRADE — Marketplace
- **New Equipment**: Toko/brand bisa listing produk baru
- **Second-hand**: Jual beli equipment bekas antar pemanah
- **Escrow Payment**: Pembayaran aman via platform
- **Review & Rating**: System review terverifikasi (hanya pembeli bisa review)
- **Equipment Recommendation**: Rekomendasi berdasarkan level & tipe panahan
- **Price Comparison**: Bandingkan harga dari berbagai seller

#### 👥 CONNECT — Community & Club
- **Club Directory**: Cari klub & sasana berdasarkan lokasi
- **Club Management**: Dashboard untuk pengurus klub (member, iuran, jadwal)
- **Range Finder**: Cari lapangan panahan terdekat (maps integration)
- **Community Feed**: Post, foto, video dari sesama pemanah
- **Group Chat**: Chat group per klub/komunitas (in-app messaging)
- **Coach Directory**: Cari coach berdasarkan lokasi, spesialisasi, rating

#### 📚 LEARN — Coaching & Content
- **Tutorial Library**: Video tutorial dari coach bersertifikat
- **1-on-1 Coaching**: Booking sesi coaching online/offline
- **Training Programs**: Program latihan terstruktur (pemula → mahir)
- **Article & Tips**: Artikel seputar teknik, mental, nutrisi
- **Islamic Archery Content**: Konten panahan dalam perspektif Islam
- **Equipment Guide**: Panduan memilih dan merawat equipment

---

## 5. Strategi Monetisasi

### Revenue Streams (7 Aliran Pendapatan)

```
┌────────────────────────────────────────────────────────────────┐
│                    REVENUE ARCHITECTURE                        │
│                                                                │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐   │
│  │ SUBSCRIPTION │  │ TRANSACTION │  │    ADVERTISING       │   │
│  │   (Recurring)│  │  (Per-use)  │  │    (Brand-driven)    │   │
│  ├─────────────┤  ├─────────────┤  ├─────────────────────┤   │
│  │ 1. Premium  │  │ 3. Market-  │  │ 5. Promoted         │   │
│  │    User     │  │    place    │  │    Listings          │   │
│  │            │  │    Commission│  │                     │   │
│  │ 2. Club    │  │             │  │ 6. Sponsored        │   │
│  │    SaaS    │  │ 4. Event    │  │    Content           │   │
│  │            │  │    Ticketing│  │                     │   │
│  └─────────────┘  └─────────────┘  │ 7. Brand            │   │
│                                     │    Partnership       │   │
│                                     └─────────────────────┘   │
└────────────────────────────────────────────────────────────────┘
```

### Detail Setiap Revenue Stream

#### 💎 Stream 1: Premium Subscription (Individual)

| Tier | Harga/Bulan | Fitur |
|------|------------|-------|
| **Free** | Rp 0 | Basic scoring (3 sesi/minggu), event discovery, community feed, marketplace browse |
| **Pro** | Rp 49.000 | Unlimited scoring, advanced analytics, progress dashboard, AI insights, no ads |
| **Elite** | Rp 99.000 | Semua Pro + coaching credits, priority event registration, verified badge, export data |

**Target Konversi**: 5-8% dari total user aktif → Premium

#### 🏢 Stream 2: Club/Range SaaS Subscription

| Tier | Harga/Bulan | Fitur |
|------|------------|-------|
| **Starter** | Rp 199.000 | Up to 50 member, basic scheduling, member database |
| **Professional** | Rp 499.000 | Up to 200 member, payment collection, attendance tracking, analytics |
| **Enterprise** | Rp 999.000 | Unlimited member, multi-location, API access, white-label scoring |

**Target**: 300-500 klub dalam 2 tahun pertama

#### 🛒 Stream 3: Marketplace Commission

| Kategori | Commission Rate |
|----------|----------------|
| Equipment Baru (dari toko) | 5-8% |
| Equipment Bekas (C2C) | 3-5% |
| Accessories & Apparel | 8-12% |

**GMV Target**: Rp 500 juta/bulan di tahun ke-2

#### 🎫 Stream 4: Event & Tournament Fees

| Service | Fee |
|---------|-----|
| Event listing (free tier) | Gratis |
| Event registration processing | 5% dari tiket |
| Live scoring system rental | Rp 500.000 - 2.000.000/event |
| Full event management package | Rp 3.000.000 - 10.000.000/event |

**Target**: 20-30 event/bulan di tahun ke-2

#### 📢 Stream 5: Promoted Listings & Ads

| Format | Harga |
|--------|-------|
| Promoted product listing | Rp 50.000 - 200.000/minggu |
| Banner ads (in-feed) | CPM Rp 15.000 - 30.000 |
| Sponsored event highlight | Rp 500.000 - 2.000.000/event |
| Push notification ads (targeted) | Rp 100.000 per 1.000 push |

#### 🤝 Stream 6: Sponsored Content

| Format | Harga |
|--------|-------|
| Sponsored article/review | Rp 1.000.000 - 5.000.000/artikel |
| Brand ambassador program | Rp 5.000.000 - 20.000.000/bulan |
| Sponsored tutorial series | Rp 3.000.000 - 10.000.000/series |

#### 🏅 Stream 7: Brand Partnership & White-Label

| Service | Revenue |
|---------|---------|
| Brand-sponsored tournament | Rp 10.000.000 - 50.000.000/event |
| PERPANI/regional body partnership | Custom pricing |
| White-label scoring untuk organisasi | Rp 5.000.000 - 15.000.000/tahun |
| Data insights (aggregated, anonymized) | Custom pricing |

---

## 6. Financial Projections & Revenue Target

### Asumsi Growth

```
User Acquisition Plan:
─────────────────────
Bulan 1-3  (Soft Launch)  :    1.000 - 5.000 users
Bulan 4-6  (Growth)       :    5.000 - 20.000 users
Bulan 7-12 (Scale)        :   20.000 - 50.000 users
Tahun 2                   :   50.000 - 150.000 users
Tahun 3                   :  150.000 - 300.000 users
```

### Revenue Projection Detail

#### Tahun 1 — Foundation Phase

| Revenue Stream | Q1 | Q2 | Q3 | Q4 | Total Tahun 1 |
|---------------|-----|-----|-----|-----|---------------|
| Premium Subscription | 0 | 2,5 jt | 7,5 jt | 15 jt | **25 jt** |
| Club SaaS | 0 | 1 jt | 4 jt | 10 jt | **15 jt** |
| Marketplace Commission | 0 | 0 | 2 jt | 8 jt | **10 jt** |
| Event Fees | 0 | 1 jt | 3 jt | 5 jt | **9 jt** |
| Ads & Sponsored | 0 | 0 | 1 jt | 3 jt | **4 jt** |
| **TOTAL** | **0** | **4,5 jt** | **17,5 jt** | **41 jt** | **63 jt** |

> **Target Revenue Bulan ke-12: Rp 41.000.000/bulan**

#### Tahun 2 — Growth Phase

| Revenue Stream | Target/Bulan (Avg) | Asumsi |
|---------------|-------------------|--------|
| Premium Subscription | Rp 75.000.000 | 1.500 user × Rp 49.000 avg |
| Club SaaS | Rp 50.000.000 | 150 klub × Rp 333.000 avg |
| Marketplace Commission | Rp 25.000.000 | GMV Rp 500jt × 5% avg |
| Event Fees | Rp 20.000.000 | 25 event × Rp 800.000 avg |
| Ads & Sponsored Content | Rp 30.000.000 | 10-15 brand partners |
| Brand Partnership | Rp 15.000.000 | 2-3 major partnerships |
| **TOTAL** | **Rp 215.000.000** | |

> **🎯 Target Revenue Bulan ke-24: Rp 200.000.000 - 250.000.000/bulan**

#### Tahun 3 — Scale Phase

| Revenue Stream | Target/Bulan (Avg) | Asumsi |
|---------------|-------------------|--------|
| Premium Subscription | Rp 200.000.000 | 4.000 user × Rp 50.000 avg |
| Club SaaS | Rp 150.000.000 | 400 klub × Rp 375.000 avg |
| Marketplace Commission | Rp 75.000.000 | GMV Rp 1.5M × 5% avg |
| Event Fees | Rp 50.000.000 | 40 event × Rp 1.250.000 avg |
| Ads & Sponsored Content | Rp 80.000.000 | 25+ brand partners |
| Brand Partnership | Rp 50.000.000 | 5+ major partnerships |
| Coaching Commission | Rp 25.000.000 | 500 sesi × Rp 50.000 commission |
| **TOTAL** | **Rp 630.000.000** | |

> **🎯 Target Revenue Bulan ke-36: Rp 500.000.000 - 750.000.000/bulan**

### Revenue Composition Target (Tahun 3)

```
Premium Subscription   ███████████████████████████████░░░  32%
Club SaaS              ████████████████████████░░░░░░░░░░  24%
Marketplace            ████████████░░░░░░░░░░░░░░░░░░░░░░  12%
Ads & Sponsored        █████████████░░░░░░░░░░░░░░░░░░░░░  13%
Events                 ████████░░░░░░░░░░░░░░░░░░░░░░░░░░   8%
Brand Partnership      ████████░░░░░░░░░░░░░░░░░░░░░░░░░░   8%
Coaching               ████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   3%
```

### Unit Economics

```
Customer Acquisition Cost (CAC)
├── Pemanah Individual  : Rp 15.000 - 25.000 (social + referral)
├── Klub/Sasana         : Rp 200.000 - 500.000 (direct sales + demo)
└── Seller/Toko         : Rp 100.000 - 300.000 (onboarding support)

Lifetime Value (LTV)
├── Premium Individual  : Rp 588.000 - 1.188.000 (12-24 bulan retention)
├── Klub/Sasana         : Rp 3.588.000 - 11.988.000 (18-24 bulan retention)
└── Seller/Toko         : Rp 600.000 - 1.200.000 (commission over 12 bulan)

LTV:CAC Ratio Target
├── Individual  : 24:1 - 47:1 ✅ Excellent
├── Klub        : 7:1 - 24:1  ✅ Healthy
└── Seller      : 4:1 - 6:1   ✅ Acceptable
```

---

## 7. Go-to-Market Strategy

### Phase 1: Community-First Launch (Bulan 1-3)

```
Strategy: "Win the Influencers, Win the Community"

                    ┌──────────────┐
                    │  Top Archers │ ← Recruit 20-30 atlet/coach berpengaruh
                    │  & Coaches   │    sebagai founding members & beta testers
                    └──────┬───────┘
                           │ mereka mengajak
                    ┌──────▼───────┐
                    │   Klub &     │ ← Target 50 klub terbesar di Jawa & Bali
                    │   Sasana     │    untuk onboarding gratis (6 bulan free SaaS)
                    └──────┬───────┘
                           │ member mengundang
                    ┌──────▼───────┐
                    │  Individual  │ ← Organic growth dari member klub
                    │  Archers     │    + referral program (invite = premium trial)
                    └──────────────┘
```

**Tactical Actions:**
1. **Kemitraan PERPANI** — MOU untuk digital scoring di event resmi
2. **Ambassador Program** — 20 atlet/coach dapat akun Elite gratis selamanya
3. **Onsite Onboarding** — Tim hadir di 10 turnamen besar untuk demo & sign up
4. **Content Seeding** — Buat konten panahan viral di TikTok/Instagram/YouTube Shorts

### Phase 2: Viral Loop (Bulan 4-6)

```
┌──────────┐   share skor    ┌──────────┐   penasaran    ┌──────────┐
│  Archer  │ ──────────────► │  Social  │ ──────────────► │  New     │
│  scores  │   ke IG/WA      │  Media   │   download app  │  User    │
└──────────┘                 └──────────┘                 └────┬─────┘
      ▲                                                       │
      │                    scores juga, share juga             │
      └────────────────────────────────────────────────────────┘
```

**Growth Hacks:**
- **Shareable Scorecard**: Desain beautiful scorecard yang auto-branded ManahPro
- **Club Leaderboard**: Kompetisi antar klub → drive club-level adoption
- **Referral Reward**: Invite 3 teman aktif → dapat 1 bulan Premium gratis
- **"Sunnah Challenge"**: Challenge panahan mingguan bernuansa Islami → viral di komunitas Muslim

### Phase 3: Marketplace & Monetization (Bulan 7-12)

- Launch marketplace setelah user base cukup (>10.000 MAU)
- Onboard 50+ seller (toko equipment + pemanah jual bekas)
- Launch premium subscription setelah users terbiasa dengan free features
- Mulai accept sponsored content dari brand archery

### Kanal Distribusi

| Kanal | Strategi | Target |
|-------|----------|--------|
| **Instagram** | Konten visual (scorecard, tutorial clips, event highlights) | 50.000 followers Y1 |
| **TikTok** | Short-form tutorial + archery challenges | 100.000 followers Y1 |
| **YouTube** | Long-form tutorial, equipment review, event coverage | 20.000 subs Y1 |
| **WhatsApp** | Community groups, bot untuk quick scoring | 200 active groups Y1 |
| **Event/Offline** | Booth di turnamen, onsite demo | 30 events Y1 |
| **Mosque/Pesantren** | Partnership dengan komunitas panahan Islami | 100 komunitas Y1 |

---

## 8. Competitive Moat

### Mengapa ManahPro Sulit Ditiru?

```
MOAT LAYERS (Berlapis, Semakin Kuat Seiring Waktu)
═══════════════════════════════════════════════════

Layer 1: DATA MOAT
├── Semakin banyak skor yang dicatat, semakin akurat analytics
├── Data ranking hanya bisa dibangun dengan waktu & partisipasi
└── Historical data = aset yang tidak bisa di-copy

Layer 2: NETWORK EFFECT
├── Semakin banyak pemanah → semakin menarik untuk seller
├── Semakin banyak seller → semakin menarik untuk pemanah
├── Semakin banyak klub → semakin akurat ranking
└── Each new user makes the platform more valuable for ALL users

Layer 3: SWITCHING COST
├── Historical scoring data tersimpan di platform
├── Club management sudah terintegrasi
├── Ranking & achievement portfolio hanya ada di ManahPro
└── Pindah platform = kehilangan semua riwayat

Layer 4: CULTURAL MOAT (Paling Kuat)
├── Brand diasosiasikan dengan "panahan Indonesia"
├── Konten Islami yang autentik (tidak bisa ditiru platform global)
├── Partnership dengan PERPANI & komunitas lokal
└── Bahasa & konteks budaya lokal yang dalam
```

### Kompetitor & Diferensiasi

| Kompetitor | Kekuatan | Kelemahan | Diferensiasi ManahPro |
|------------|----------|-----------|----------------------|
| **Artemis (Global)** | Scoring app mapan | Tidak ada fitur komunitas, no Indonesian context | Full ecosystem + Indonesian-first |
| **Ianseo** | Standard scoring international | Hanya scoring, no social, complex UX | Simpler UX + social + marketplace |
| **WhatsApp Groups** | Sudah jadi kebiasaan | Tidak terstruktur, no data retention | Structured data + analytics |
| **Instagram** | Visual, besar | No utility features | Utility + community combined |
| **Manual/Excel** | Gratis, familiar | Tidak scalable, no insights | Automated, insightful, connected |

---

## 9. Roadmap Eksekusi

### Quarter-by-Quarter Roadmap

```
Q1 2026 (Jul-Sep): MVP & SOFT LAUNCH
══════════════════════════════════════
🟢 Core Scoring System (manual input per end/rambahan)
🟢 User Profile & Auth (Firebase)
🟢 Basic Progress Dashboard
🟢 Club Directory (listing only)
🟢 Event Calendar (read-only, curated)
🟢 Community Feed (post, like, comment)
🔧 Platform: Flutter (iOS + Android + Web)
🎯 Target: 1.000-3.000 users

Q2 2026 (Oct-Dec): CLUB TOOLS & EVENTS
═══════════════════════════════════════
🟢 Club Management Dashboard (member, schedule)
🟢 Event Registration & Payment
🟢 Live Scoring (basic — manual by scorer)
🟢 National Ranking System v1 (ELO-based)
🟢 Coach Directory
🟢 Push Notifications
🔧 Payment: Midtrans / Xendit integration
🎯 Target: 5.000-10.000 users, 50 clubs

Q3 2027 (Jan-Mar): MARKETPLACE & PREMIUM
═════════════════════════════════════════
🟢 Marketplace v1 (new + second-hand equipment)
🟢 Escrow Payment System
🟢 Premium Subscription Launch
🟢 Advanced Analytics Dashboard
🟢 In-App Messaging / Chat
🟢 Sponsored Content Framework
🎯 Target: 15.000-25.000 users, 100 clubs, 50 sellers

Q4 2027 (Apr-Jun): AI & SCALE
══════════════════════════════
🟢 AI Target Recognition (foto target → auto score)
🟢 Training Program Builder
🟢 Video Tutorial Platform
🟢 1-on-1 Coaching Booking
🟢 Multi-language (Indonesian + English)
🟢 Brand Partnership Dashboard
🎯 Target: 30.000-50.000 users, 200 clubs, 150 sellers

FUTURE (2027 H2+):
══════════════════
🔮 Wearable Integration (smartwatch untuk heart rate saat latihan)
🔮 AR Training Assistant
🔮 Regional Expansion (Malaysia, Brunei, Philippines)
🔮 PERPANI Official Integration
🔮 E-commerce fulfillment partnership
```

### MVP Feature Priority Matrix

```
                    HIGH IMPACT
                        ▲
                        │
     ┌──────────────────┼──────────────────┐
     │                  │                  │
     │  AI Target       │  Digital Scoring │
     │  Recognition     │  ★ MVP CORE     │
     │  (v2)            │                  │
     │                  │  Progress        │
     │  Marketplace     │  Dashboard       │
     │  (Q3)            │  ★ MVP CORE     │
     │                  │                  │
     │  Coaching        │  Event Discovery │
     │  Booking         │  ★ MVP CORE     │
LOW ─┼──────────────────┼──────────────────┼─ HIGH
EASE │                  │                  │  EASE
     │  Wearable        │  Community Feed  │
     │  Integration     │  ★ MVP CORE     │
     │  (Future)        │                  │
     │                  │  Club Directory  │
     │  AR Training     │  ★ MVP CORE     │
     │  (Future)        │                  │
     │                  │  User Profiles   │
     │                  │  ★ MVP CORE     │
     └──────────────────┼──────────────────┘
                        │
                    LOW IMPACT
```

---

## 10. Risks & Mitigations

### Risk Matrix

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| **Low adoption rate** | Medium | High | Community-first approach; free tier generous; influencer seeding |
| **PERPANI resistance** | Low | High | Early partnership; position as complementary tool, not competitor |
| **Competitor enters** | Medium | Medium | Build data moat fast; lock-in with historical data & ranking |
| **Low willingness to pay** | Medium | High | Start free; prove value first; price anchoring with international apps |
| **Marketplace fraud** | Medium | Medium | Escrow system; verified sellers; buyer protection policy |
| **Technical scaling** | Low | Medium | Cloud-native architecture; Firebase/GCP auto-scaling |
| **Content moderation** | Medium | Low | Community guidelines; report system; AI-assisted moderation |
| **Seasonal fluctuation** | High | Low | Indoor events during rainy season; year-round content strategy |

### Key Success Metrics (North Star & Supporting)

```
⭐ NORTH STAR METRIC: Monthly Active Scoring Sessions
   (Directly correlates with engagement, retention, and monetization potential)

Supporting Metrics:
├── 📈 DAU/MAU Ratio          → Target: >25% (strong engagement)
├── 📊 Scoring Sessions/User  → Target: >8 per month
├── 💰 ARPU (Avg Revenue/User)→ Target: Rp 5.000-15.000/bulan (blended)
├── 🔄 Monthly Retention       → Target: >60% M1, >40% M6
├── 🏢 Club Activation Rate   → Target: >70% of onboarded clubs active
├── 🛒 Marketplace GMV Growth → Target: >20% MoM in first year
└── 📣 NPS Score              → Target: >50 (Excellent)
```

---

## Ringkasan Eksekutif

> **ManahPro** adalah **super-app untuk komunitas panahan Indonesia** yang menyatukan scoring & analytics, event management, marketplace equipment, club management, dan social community dalam satu platform.

### Mengapa Sekarang?
1. Komunitas panahan Indonesia sedang tumbuh pesat (~15-20%/tahun)
2. Belum ada platform digital yang mendominasi niche ini
3. Motivasi spiritual (Sunnah) menciptakan growth driver unik yang tidak ada di negara lain
4. Teknologi mobile & payment digital Indonesia sudah mature

### Revenue Target

| Timeline | Monthly Revenue Target |
|----------|----------------------|
| **Bulan ke-6** | Rp 5.000.000 - 10.000.000 |
| **Bulan ke-12** | Rp 35.000.000 - 50.000.000 |
| **Bulan ke-24** | Rp 200.000.000 - 250.000.000 |
| **Bulan ke-36** | Rp 500.000.000 - 750.000.000 |

### Kunci Sukses
1. **Community-first** — Bangun komunitas dulu, monetize kemudian
2. **Data moat** — Setiap skor yang dicatat = data yang menguatkan posisi
3. **Cultural fit** — Konten Islami + bahasa lokal = tidak bisa ditiru platform global
4. **Land and expand** — Masuk lewat scoring (free), expand ke club SaaS & marketplace

---

*Dokumen ini adalah living document dan akan di-update seiring perkembangan validasi pasar dan feedback dari pengguna awal.*

*Last updated: 28 Mei 2026*
*Author: ManahPro Strategy Team*
