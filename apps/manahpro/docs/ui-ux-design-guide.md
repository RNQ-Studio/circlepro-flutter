# ManahPro UI/UX Design Guide
## Panduan Lengkap Desain Antarmuka — Kaidah 2025–2026

> **Dokumen ini adalah panduan definitif** agar tidak salah langkah dalam mendesain dan mengimplementasi UI/UX ManahPro. Disusun berdasarkan riset terbaru Material Design 3, Apple Liquid Glass (iOS 26), prinsip ergonomi mobile, dan best practices industri 2025–2026.

---

## Daftar Isi

1. [Paradigma UI/UX 2025–2026: Apa yang Berubah?](#1-paradigma-uiux-20252026)
2. [10 Prinsip Desain yang Harus Dipegang](#2-10-prinsip-desain-yang-harus-dipegang)
3. [Design System & Token Architecture](#3-design-system--token-architecture)
4. [Navigasi: Bottom Nav, Tab Bar, atau yang Lain?](#4-navigasi-bottom-nav-tab-bar-atau-yang-lain)
5. [Information Architecture ManahPro](#5-information-architecture-manahpro)
6. [Screen-by-Screen UX Blueprint](#6-screen-by-screen-ux-blueprint)
7. [Onboarding Flow](#7-onboarding-flow)
8. [Motion Design & Micro-Interactions](#8-motion-design--micro-interactions)
9. [Dark Mode Strategy](#9-dark-mode-strategy)
10. [Accessibility (A11y) Checklist](#10-accessibility-a11y-checklist)
11. [Platform-Specific Adaptations](#11-platform-specific-adaptations)
12. [Anti-Pattern: Kesalahan yang Harus Dihindari](#12-anti-pattern-kesalahan-yang-harus-dihindari)
13. [Referensi & Benchmark Apps](#13-referensi--benchmark-apps)

---

## 1. Paradigma UI/UX 2025–2026

### Apa yang Berubah dari 2023–2024?

Industri UI/UX telah mengalami **3 pergeseran besar** di 2025–2026:

```
ERA 2020-2023                         ERA 2025-2026
───────────────                       ───────────────
Flat Design                    →      Depth & Translucency
"Make it beautiful"            →      "Make it invisible"
Static Layouts                 →      Adaptive & AI-Driven
Dark Mode = afterthought       →      Dark Mode = default
Decorate first, function next  →      Performance IS the design
Tutorial-heavy onboarding      →      Zero-friction, learn-by-doing
Fixed navigation patterns      →      Context-aware navigation
Pixel-perfect mockups          →      Token-based design systems
```

### 3 Revolusi Visual Terbesar

#### 1. Apple Liquid Glass (iOS 26 — Sept 2025)

Apple memperkenalkan **Liquid Glass** — perubahan desain terbesar sejak iOS 7 (2013):

```
LIQUID GLASS CHARACTERISTICS:
├── Translucent materials yang membiaskan konten di belakangnya
├── Physics-based animations (elemen bereaksi terhadap gerakan device)
├── Floating controls — toolbar/nav bar menjadi "capsule" mengambang
├── Tab bar yang menyusut saat scroll (memberi ruang lebih untuk konten)
├── Depth hierarchy via transparency, bukan hanya shadow
└── Unified across semua Apple platform (iPhone, iPad, Mac, Watch)
```

**Implikasi untuk ManahPro:**
- Di iOS, user sekarang **terbiasa** dengan elemen transparan dan floating
- Kita harus membuat UI yang terasa "hidup" dan berlapis, bukan flat
- Tab bar/bottom nav perlu bisa bereaksi terhadap scroll

#### 2. Material Design 3 Maturity (Android)

M3 sudah mature dengan fitur-fitur kunci:

```
MATERIAL DESIGN 3 (2025-2026):
├── Dynamic Color — UI mengambil warna dari wallpaper/foto user
├── Tonal Elevation — depth ditunjukkan oleh tone, bukan shadow
├── Navigation Bar — bottom nav dengan pill-shaped active indicator
├── Predictive Back — gesture back yang menunjukkan preview
├── Canonical Layouts — template layout standar (list-detail, feed, etc.)
└── Adaptive Scaffold — nav otomatis berubah di tablet/desktop
```

#### 3. AI-Driven Personalization

```
AMBIENT AI IN UI:
├── Interface yang berubah berdasarkan pola penggunaan user
├── Fitur yang sering dipakai otomatis naik ke atas / jadi shortcut
├── Konten feed di-personalisasi per user
├── Smart suggestions muncul contextually, bukan mengganggu
└── "Invisible AI" — user tidak sadar AI sedang membantu
```

---

## 2. 10 Prinsip Desain yang Harus Dipegang

### Prinsip #1: THUMB ZONE FIRST 👍

```
THUMB REACHABILITY MAP (Right Hand)
════════════════════════════════════

  ┌──────────────────────────┐
  │   ❌ HARD TO REACH       │  ← Status bar, top actions
  │   ❌ HARD TO REACH       │  ← Top app bar (jangan taruh action penting di sini)
  │                          │
  │   ⚠️ STRETCH ZONE       │  ← Konten sekunder OK
  │                          │
  │   ⚠️ STRETCH ZONE       │
  │                          │
  │   ✅ NATURAL ZONE        │  ← Konten utama
  │                          │
  │   ✅ EASY ZONE           │  ← FAB, bottom sheet triggers
  │                          │
  │   ✅ EASIEST ZONE        │  ← Bottom Navigation Bar ★
  └──────────────────────────┘

ATURAN:
├── Semua primary actions HARUS di bottom 1/3 layar
├── Navigation HARUS di bottom (bukan top hamburger!)
├── Top area hanya untuk informasi (judul, status)
├── Gunakan bottom sheet, BUKAN dialog di tengah layar
└── FAB (Floating Action Button) di bottom-right = paling ergonomis
```

> **Untuk ManahPro**: Tombol "Input Skor", "Daftar Event", dan "Post" harus selalu reachable dari bottom zone.

### Prinsip #2: PERFORMANCE IS DESIGN ⚡

```
BENCHMARK KINERJA (2026 Standard):
├── Cold Start         : < 2,5 detik (WAJIB)
├── First Meaningful Paint: < 1,5 detik
├── Time to Interactive : < 3 detik
├── Time to Value       : < 60 detik (user harus "feel the value")
├── Frame Rate          : 60fps minimum, target 120fps
├── Jank Budget         : < 5% dropped frames
└── Memory Usage        : < 150MB RAM aktif

IMPLEMENTASI DI FLUTTER:
├── Gunakan const constructors SEMUA widget yang memungkinkan
├── Lazy loading untuk list panjang (ListView.builder)
├── Skeleton screens, BUKAN loading spinner
├── Prefetch data sebelum user navigasi ke screen berikutnya
├── Cache images dengan cached_network_image
└── Minimize widget rebuilds (gunakan Selector/Consumer dari Provider)
```

> **Kegagalan performa = kegagalan desain.** App yang lambat TIDAK MUNGKIN memiliki UX yang bagus, seindah apapun visualnya.

### Prinsip #3: PROGRESSIVE DISCLOSURE 📦

```
JANGAN:                              LAKUKAN:
─────────                            ────────
Tampilkan semua fitur sekaligus      Tampilkan fitur bertahap
                                     
┌──────────────────────┐             ┌──────────────────────┐
│ Profile  Scoring     │             │                      │
│ Events   Ranking     │             │  ✨ Score Pertamamu!  │
│ Market   Chat        │             │                      │
│ Coach    Settings    │             │  [Mulai Scoring ▶]   │
│ Badge    History     │             │                      │
│ Club     Stats       │             │  (fitur lain muncul  │
│ (TOO MUCH!)         │             │   setelah ini)       │
└──────────────────────┘             └──────────────────────┘
                                     
Cognitive overload ❌                 Focused ✅
```

**Rule**: Tampilkan hanya apa yang user butuhkan **saat ini**. Fitur advanced muncul setelah user siap.

### Prinsip #4: CONTENT-FIRST, CHROME-LAST 📱

```
CONTENT = apa yang user datang untuk lihat (skor, event, post)
CHROME  = elemen UI (toolbar, nav, border, label)

TARGET RATIO:
├── Konten  : 70-80% dari layar
├── Chrome  : 15-25% dari layar
└── Whitespace: 5-10% untuk breathing room

IMPLEMENTASI:
├── Toolbar menyusut saat scroll ke bawah (SliverAppBar)
├── Bottom nav menyembunyikan label saat scroll (hanya icon)
├── Full-bleed images dan cards (edge-to-edge)
├── Minimal borders — gunakan spacing, bukan garis pemisah
└── Typography hierarchy menggantikan visual separation
```

### Prinsip #5: ZERO-FRICTION INPUT ✍️

```
UNTUK SCORING (use case paling sering ManahPro):

❌ SALAH: Text field → ketik angka → submit → konfirmasi → done
   (5 langkah, ~15 detik per entry)

✅ BENAR: Tap angka di grid → otomatis record → swipe next end
   (2 langkah, ~3 detik per entry)

PRINSIP INPUT:
├── 1 tap > 2 tap > swipe > type (urutan preferensi)
├── Smart defaults (isi otomatis berdasarkan pola user)
├── Autocomplete untuk semua text field
├── Haptic feedback untuk konfirmasi tanpa visual
├── Undo/redo, BUKAN "are you sure?" dialog
└── Support keyboard type yang tepat (number pad untuk skor)
```

### Prinsip #6: EMOTIONAL DESIGN 💚

```
DESAIN YANG MEMBUAT USER MERASA:
├── "Wah, keren!"      → First impression (visual excellence)
├── "Ini mudah banget"  → Usability (zero friction)
├── "Saya progressing!" → Gamification (progress bar, streak, badge)
├── "Saya bagian dari ini" → Community (social proof, leaderboard)
└── "Saya mau buka lagi" → Habit loop (notification, streak)

IMPLEMENTASI EMOTIONAL HOOKS:
├── Celebration animation saat personal best ✨
├── Streak counter dengan fire emoji 🔥 (3 hari berturut latihan)
├── Rating naik → confetti burst + sound effect
├── Weekly recap dengan infografis performa
├── "Teman kamu Andi baru saja ikut event" → social trigger
└── "Kamu hanya 15 poin dari Gold badge!" → progress motivation
```

### Prinsip #7: CONSISTENCY & PREDICTABILITY 🎯

```
USER HARUS BISA MEMPREDIKSI:
├── "Kalau saya tap ini, akan terjadi X"
├── "Back button pasti kembali ke screen sebelumnya"
├── "Tombol hijau pasti berarti konfirmasi/positif"
├── "Swipe kiri di card pasti menampilkan actions"
└── "Icon di bottom nav pasti selalu di tempat yang sama"

ATURAN:
├── JANGAN pindah-pindah posisi tombol antar screen
├── JANGAN ubah warna/shape tombol untuk fungsi yang sama
├── JANGAN sembunyikan back button
├── JANGAN pakai gesture yang berbeda untuk fungsi sama
└── Warna, spacing, dan typography HARUS konsisten (design tokens!)
```

### Prinsip #8: OFFLINE-FIRST MINDSET 📴

```
MENGAPA PENTING UNTUK MANAHPRO:
├── Lapangan panahan sering di outdoor (sinyal lemah/tidak ada)
├── Saat scoring di lapangan, HARUS bisa input tanpa internet
├── Event di daerah terpencil mungkin tidak ada sinyal
└── Indonesia masih memiliki coverage internet yang tidak merata

IMPLEMENTASI:
├── Scoring bisa dilakukan full offline → sync saat online
├── Event list, jadwal, dan profil di-cache secara lokal
├── Leaderboard terakhir di-cache
├── Optimistic UI updates (tampilkan perubahan dulu, sync di background)
├── Indicator "offline mode" yang subtle tapi jelas
└── Queue system untuk actions offline (post, update, message)
```

### Prinsip #9: ACCESSIBILITY IS NOT OPTIONAL ♿

```
MINIMUM STANDARDS (WCAG 2.2 AA — WAJIB):
├── Touch target: minimum 44×44pt (iOS) / 48×48dp (Android)
├── Color contrast: minimum 4.5:1 untuk text normal
├── Color contrast: minimum 3:1 untuk text besar (>18pt)
├── JANGAN gunakan warna saja untuk menyampaikan informasi
├── Semua interaktif harus punya label untuk screen reader
├── Support dynamic type (text membesar sesuai system setting)
├── Animasi harus bisa dimatikan (prefers-reduced-motion)
└── Focus order harus logis untuk keyboard/switch navigation
```

### Prinsip #10: PLATFORM RESPECT 🤝

```
JANGAN MELAWAN PLATFORM CONVENTION:

iOS Users Expect:                    Android Users Expect:
├── Swipe back dari left edge        ├── System back button/gesture
├── Tab bar di bottom                ├── Navigation bar di bottom  
├── Pull-to-refresh                  ├── Pull-to-refresh
├── Large title yang collapse        ├── Top app bar yang collapse
├── Sheet/modal dari bottom          ├── Bottom sheet
├── Haptic feedback subtle           ├── Haptic feedback
├── Liquid Glass translucency        ├── Material You dynamic color
└── "Done" button di top-right       └── FAB untuk primary action

FLUTTER SOLUTION:
├── Gunakan platform-adaptive widgets dimana mungkin
├── CupertinoNavigationBar untuk iOS, AppBar untuk Android
├── Atau: Material Design 3 sebagai "baseline", override untuk iOS
└── Satu design system, dua "skin" adaptif
```

---

## 3. Design System & Token Architecture

### 3.1 Token Hierarchy

```
DESIGN TOKEN ARCHITECTURE (3 Layers)
═════════════════════════════════════

Layer 1: PRIMITIVE TOKENS (Raw Values)
────────────────────────────────────
Ini adalah "palet warna cat" — raw values tanpa makna kontekstual.

  // Colors
  color-green-50:  #E8F5E9
  color-green-100: #C8E6C9
  color-green-500: #4CAF50
  color-green-900: #1B5E20
  
  color-amber-500: #FFC107
  color-grey-900:  #121212
  color-grey-50:   #FAFAFA
  
  // Spacing (8px grid)
  spacing-2:   2px
  spacing-4:   4px
  spacing-8:   8px
  spacing-12:  12px
  spacing-16:  16px
  spacing-24:  24px
  spacing-32:  32px
  spacing-48:  48px
  spacing-64:  64px
  
  // Typography
  font-size-10: 10px
  font-size-12: 12px
  font-size-14: 14px
  font-size-16: 16px
  font-size-20: 20px
  font-size-24: 24px
  font-size-32: 32px
  font-size-40: 40px

  // Radius
  radius-4:  4px
  radius-8:  8px
  radius-12: 12px
  radius-16: 16px
  radius-24: 24px
  radius-full: 9999px
  
Layer 2: SEMANTIC TOKENS (Intent/Purpose)
─────────────────────────────────────────
Mendefinisikan MENGAPA warna/spacing itu dipakai.

  // Surfaces
  color-bg-primary:        → Light: color-grey-50   | Dark: color-grey-900
  color-bg-secondary:      → Light: #F5F5F5         | Dark: #1E1E1E
  color-bg-elevated:       → Light: #FFFFFF          | Dark: #2C2C2C
  color-bg-brand:          → Light: color-green-500  | Dark: color-green-500
  
  // Text
  color-text-primary:      → Light: #1A1A1A          | Dark: #E8E8E8
  color-text-secondary:    → Light: #666666          | Dark: #AAAAAA
  color-text-on-brand:     → Light: #FFFFFF          | Dark: #FFFFFF
  color-text-disabled:     → Light: #BDBDBD          | Dark: #555555
  
  // Actions
  color-action-primary:    → color-green-500 (brand color)
  color-action-secondary:  → color-amber-500
  color-action-danger:     → #E53935
  color-action-success:    → #43A047
  
  // Borders
  color-border-default:    → Light: #E0E0E0          | Dark: #333333
  color-border-focus:      → color-green-500
  
  // Spacing (semantic)
  spacing-page-margin:     → spacing-16 (mobile) / spacing-24 (tablet)
  spacing-card-padding:    → spacing-16
  spacing-section-gap:     → spacing-24
  spacing-inline-gap:      → spacing-8
  spacing-stack-gap:       → spacing-12
  
  // Typography (semantic)
  text-heading-xl:         → font-size-32, weight-700, line-height 1.2
  text-heading-lg:         → font-size-24, weight-700, line-height 1.2
  text-heading-md:         → font-size-20, weight-600, line-height 1.3
  text-body-lg:            → font-size-16, weight-400, line-height 1.5
  text-body-md:            → font-size-14, weight-400, line-height 1.5
  text-body-sm:            → font-size-12, weight-400, line-height 1.4
  text-label:              → font-size-12, weight-500, line-height 1.0, uppercase
  text-number-display:     → font-size-40, weight-700, line-height 1.0
  
Layer 3: COMPONENT TOKENS (Localized)
──────────────────────────────────────
Override spesifik per komponen.

  // Button
  button-primary-bg:       → color-action-primary
  button-primary-text:     → color-text-on-brand
  button-primary-radius:   → radius-12
  button-primary-height:   → 48dp
  
  // Bottom Navigation
  nav-bg:                  → color-bg-elevated
  nav-active-color:        → color-action-primary
  nav-inactive-color:      → color-text-secondary
  nav-indicator:           → color-green-100 (pill shape)
  
  // Score Card
  score-card-bg:           → color-bg-elevated
  score-card-radius:       → radius-16
  score-card-score-color:  → color-text-primary
  score-card-label-color:  → color-text-secondary
```

### 3.2 Implementasi di Flutter

```dart
// lib/core/theme/app_tokens.dart

/// PRIMITIVE TOKENS
abstract class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;
}

abstract class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double full = 9999;
}

/// SEMANTIC TOKENS (resolved per theme)
abstract class AppColors {
  // Brand
  static const Color brand = Color(0xFF2E7D32);       // Green 800
  static const Color brandLight = Color(0xFF4CAF50);   // Green 500
  static const Color brandSurface = Color(0xFFE8F5E9); // Green 50
  
  // Status
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF1E88E5);
}

/// THEME DATA — use ColorScheme.fromSeed for M3
ThemeData lightTheme() => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.brand,
    brightness: Brightness.light,
  ),
  // ... typography, shapes, etc.
);

ThemeData darkTheme() => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.brand,
    brightness: Brightness.dark,
  ),
  // ... typography, shapes, etc.
);
```

### 3.3 Typography System

```
TYPOGRAPHIC SCALE (Major Second Ratio — 1.125)
═══════════════════════════════════════════════

Font Family: Inter (Google Fonts) — clean, modern, excellent readability
Alternative: Plus Jakarta Sans (lebih "Indonesia feel")

Hierarchy:

  Display   — 40px / Bold / -0.5 tracking   → Rating number, hero stat
  H1        — 32px / Bold / -0.3 tracking   → Screen title
  H2        — 24px / SemiBold               → Section header
  H3        — 20px / SemiBold               → Card title
  Body L    — 16px / Regular / 1.5 lh       → Primary body text (MINIMUM!)
  Body M    — 14px / Regular / 1.5 lh       → Secondary text
  Body S    — 12px / Regular / 1.4 lh       → Captions, timestamps
  Label     — 12px / Medium / UPPERCASE     → Category labels, badges
  Number    — 40px / Bold / Tabular nums    → Scores, rankings, stats

ATURAN KRITIS:
├── Body text TIDAK BOLEH di bawah 14px (12px hanya untuk caption)
├── SELALU gunakan tabular figures untuk angka/skor
├── Line height body text MINIMAL 1.4x font size
├── Heading line height: 1.2x (lebih rapat)
├── Max line width: 60-70 karakter (optimal readability)
└── Support dynamic type / text scaling dari system
```

### 3.4 Color Palette ManahPro

```
BRAND COLORS — "Forest Archery"
═══════════════════════════════

Primary Palette:
┌──────────────────────────────────────────────────────┐
│  ██████  Forest Green (#2E7D32) — Primary brand      │
│  ██████  Leaf Green (#4CAF50) — Primary actions       │
│  ██████  Mint (#E8F5E9) — Brand surface/tints        │
└──────────────────────────────────────────────────────┘

Secondary Palette:
┌──────────────────────────────────────────────────────┐
│  ██████  Amber Gold (#FFC107) — Highlights, badges   │
│  ██████  Deep Amber (#FF8F00) — Warnings, streaks    │
│  ██████  Light Amber (#FFF8E1) — Amber surface       │
└──────────────────────────────────────────────────────┘

Neutral Palette:
┌──────────────────────────────────────────────────────┐
│  ██████  Near Black (#1A1A1A) — Primary text (light) │
│  ██████  Dark Grey (#333333) — Secondary text (light)│
│  ██████  Medium Grey (#666666) — Tertiary text       │
│  ██████  Light Grey (#F5F5F5) — Background           │
│  ██████  Near White (#FAFAFA) — Card/elevated        │
└──────────────────────────────────────────────────────┘

Status Colors:
┌──────────────────────────────────────────────────────┐
│  ██████  Success (#43A047) — Win, personal best      │
│  ██████  Warning (#FFA726) — Attention needed        │
│  ██████  Error (#E53935) — Destructive, loss         │
│  ██████  Info (#1E88E5) — Informational              │
└──────────────────────────────────────────────────────┘

Ranking Badge Colors:
┌──────────────────────────────────────────────────────┐
│  ██████  Diamond (#B9F2FF) — Grand Archer (2200+)    │
│  ██████  Gold (#FFD700) — Expert (1800-1999)         │
│  ██████  Silver (#C0C0C0) — Advanced (1600-1799)     │
│  ██████  Bronze (#CD7F32) — Intermediate (1400-1599) │
│  ██████  Iron (#808080) — Developing (1200-1399)     │
└──────────────────────────────────────────────────────┘

MENGAPA GREEN?
├── Hijau = panahan, alam, outdoor, lapangan
├── Hijau = warna Islam (relevan untuk segmen Sunnah)
├── Hijau = growth, progress (asosiasi psikologis)
├── Green + Amber = harmonis, warm, energetic
└── Tidak terlalu "sporty agresif" (bukan merah/biru)
    tapi juga tidak terlalu "corporate" — balanced.
```

---

## 4. Navigasi: Bottom Nav, Tab Bar, atau yang Lain?

### 4.1 Analisis Decision Framework

Ini adalah salah satu **keputusan desain terpenting** yang akan kita buat. Mari analisis opsi-opsi yang ada:

```
OPSI NAVIGASI UTAMA
════════════════════

┌─────────────────────────────────────────────────────────────────┐
│  OPSI A: Bottom Navigation Bar (3-5 tab)                       │
│  ─────────────────────────────────────────                     │
│  ✅ Standard industri 2025-2026                                │
│  ✅ Thumb-friendly (di thumb zone)                             │
│  ✅ Persistent — user selalu tahu posisi mereka                │
│  ✅ Material Design 3 recommended                              │
│  ✅ Apple HIG recommended                                      │
│  ⚠️ Maksimal 5 tab (ManahPro punya 5 pilar → PAS!)           │
│  ⚠️ Mengambil ~56dp dari layar                                │
├─────────────────────────────────────────────────────────────────┤
│  OPSI B: Hamburger Menu / Navigation Drawer                    │
│  ─────────────────────────────────────────                     │
│  ❌ Menurunkan discoverability 50%+ (riset Nielsen Norman)     │
│  ❌ Butuh 2 tap untuk navigasi (open + select)                 │
│  ❌ Di luar thumb zone (top-left)                              │
│  ❌ Sudah dianggap ANTI-PATTERN untuk primary navigation       │
│  ✅ Bisa menampung banyak item                                 │
│  ✅ Tidak mengambil screen space                               │
├─────────────────────────────────────────────────────────────────┤
│  OPSI C: Hub/Dashboard Home + Contextual Nav                   │
│  ─────────────────────────────────────────                     │
│  ⚠️ Bagus untuk super-app (Gojek, Grab, Tokopedia)            │
│  ❌ Membutuhkan "kembali ke Home" untuk pindah section         │
│  ❌ Lebih banyak tap untuk navigasi antar section              │
│  ✅ Bisa menampung BANYAK fitur di homepage                    │
│  ✅ Fleksibel untuk ekspansi fitur                             │
├─────────────────────────────────────────────────────────────────┤
│  OPSI D: Bottom Nav + Tab (Hybrid)                             │
│  ─────────────────────────────────────────                     │
│  ✅ Bottom nav = primary (top-level sections)                  │
│  ✅ Tabs = secondary (sub-sections within a tab)               │
│  ✅ Recommended oleh Material Design 3                         │
│  ⚠️ JANGAN stack bottom nav + tab di bottom (konfusi!)        │
│  ⚠️ Butuh clear visual hierarchy antar 2 level nav            │
└─────────────────────────────────────────────────────────────────┘
```

### 4.2 Keputusan: OPSI D — Bottom Nav + Tabs (Hybrid) ✅

**Rekomendasi final: Bottom Navigation Bar dengan 4 tab utama + contextual tabs di dalam setiap section.**

```
MENGAPA 4 TAB, BUKAN 5?

ManahPro punya 5 pilar (Track, Compete, Trade, Connect, Learn).
Tapi 5 tab = terlalu banyak text → label terpotong → confusing.

SOLUSI: Gabungkan "Connect" dan "Learn" menjadi "Community"
        yang di dalamnya ada tabs untuk Feed, Clubs, Coaches, Content.

FINAL NAVIGATION STRUCTURE:
═══════════════════════════

Bottom Navigation Bar (persistent):
┌──────┬───────┬──────┬─────────┐
│ 🎯   │  🏆   │ 🏪   │   👤    │
│ Score │ Event │ Shop │ Profile │
└──────┴───────┴──────┴─────────┘

+ Floating Action Button (center-bottom, overlapping nav):
         ┌──────────┐
         │  ➕ New  │ ← Quick actions: New Score, Join Event, Post
         └──────────┘
```

### 4.3 Navigation Architecture (Detail)

```
BOTTOM NAV TABS (Level 1 — Persistent):
═══════════════════════════════════════

TAB 1: 🎯 Score
├── [Top Tabs] Today | History | Analytics
├── Content: Quick scoring, recent sessions, progress charts
├── FAB Action: + New Scoring Session
└── Key Screens: Scoring Input → Session Summary → Analytics Detail

TAB 2: 🏆 Events
├── [Top Tabs] Upcoming | My Events | Rankings
├── Content: Event cards, registration, live scores, leaderboard
├── FAB Action: + Create Event (for organizers)
└── Key Screens: Event List → Event Detail → Registration → Live Score

TAB 3: 🏪 Market
├── [Top Tabs] Browse | Sell | My Orders
├── Content: Equipment listings, categories, search
├── FAB Action: + List Item for Sale
└── Key Screens: Browse → Product Detail → Cart → Checkout

TAB 4: 👤 Profile
├── [Top Tabs] (none — single view with sections)
├── Content: Avatar, rating card, stats, achievements, settings
├── Sections: My Stats | Achievements | Club | Settings
└── Key Screens: Profile → Edit Profile → Settings → Notifications

ACCESSING OTHER FEATURES:
─────────────────────────
Community/Feed → Accessible from Home header shortcut + Profile → My Feed
Clubs         → Accessible from Profile → My Club + search
Coaches       → Accessible from Events → Coach section
Articles      → Accessible from Score → Tips section
Chat          → Accessible from event/club/profile context
```

### 4.4 Mengapa BUKAN Hamburger Menu?

```
RISET YANG MENDASARI KEPUTUSAN INI:

┌──────────────────────────────────────────────────────────────┐
│  Nielsen Norman Group (2023-2025):                           │
│  "Hamburger menus reduce feature discoverability by 50%"     │
│                                                              │
│  Luke Wroblewski (Google, 2024):                             │
│  "Bottom navigation increases engagement by 20-30%           │
│   compared to hamburger menus"                               │
│                                                              │
│  Material Design Guidelines (2025):                          │
│  "Use navigation drawer ONLY for secondary destinations      │
│   that don't need to be accessed frequently"                 │
│                                                              │
│  Apple HIG (2025):                                           │
│  "A tab bar is the best way to provide flat, persistent      │
│   navigation in an app"                                      │
└──────────────────────────────────────────────────────────────┘

VERDICT: Hamburger menu BOLEH dipakai untuk Settings, Help, About,
         dan fitur sekunder lainnya. Tapi JANGAN untuk primary nav.
         
DI MANAHPRO:
├── Bottom Nav = primary (Score, Events, Market, Profile)
├── Hamburger/Drawer = TIDAK ADA
├── Settings = di dalam tab Profile
├── Help/About = di dalam Settings
└── Fitur tersembunyi = di dalam contextual menus
```

---

## 5. Information Architecture ManahPro

### 5.1 Sitemap

```
MANAHPRO SITEMAP
════════════════

🏠 App Entry
├── Splash Screen (< 2 detik)
├── Onboarding (first launch only, 3 screens max)
└── Auth (deferred — bisa browse dulu tanpa login)

🎯 Score (Tab 1)
├── Today
│   ├── Quick Score Input
│   ├── Active Session
│   ├── Today's Summary
│   └── Tips of the Day
├── History
│   ├── Session List (by date)
│   ├── Session Detail
│   │   ├── Score per End
│   │   ├── Arrow Pattern (if available)
│   │   └── Session Notes
│   └── Compare Sessions
├── Analytics
│   ├── Progress Chart (line graph)
│   ├── Score Distribution (histogram)
│   ├── Consistency Index
│   ├── Personal Bests
│   └── Rating History
└── Scoring Session (full-screen flow)
    ├── Setup (distance, bow type, arrows, target face)
    ├── Score Input (end by end)
    ├── End Summary
    └── Session Complete → Share

🏆 Events (Tab 2)
├── Upcoming Events
│   ├── Event Card (date, location, tier, division)
│   ├── Event Detail
│   │   ├── Info (rules, schedule, location map)
│   │   ├── Registration (if open)
│   │   ├── Participants List
│   │   └── Results (if completed)
│   └── Filter/Search (location, date, tier, division)
├── My Events
│   ├── Registered (upcoming)
│   ├── In Progress (live)
│   └── Completed (past results)
├── Rankings
│   ├── National Leaderboard
│   │   ├── Filter: Division, Gender, Age Group
│   │   └── Archer Detail → Profile
│   ├── Regional Leaderboard
│   └── My Ranking Position
└── Live Scoring (during event)
    ├── Real-time Scoreboard
    ├── My Score Entry (if participating)
    └── Follow Specific Archer

🏪 Market (Tab 3)
├── Browse
│   ├── Categories (Bows, Arrows, Accessories, Apparel)
│   ├── New Equipment
│   ├── Second-hand
│   ├── Search & Filter
│   └── Product Detail
│       ├── Photos, Description, Specs
│       ├── Seller Profile
│       ├── Reviews & Rating
│       └── Buy / Make Offer
├── Sell
│   ├── Create Listing
│   ├── My Listings
│   └── Listing Analytics
├── My Orders
│   ├── Purchases
│   ├── Sales
│   └── Disputes
└── Cart & Checkout
    ├── Cart
    ├── Shipping Info
    ├── Payment
    └── Order Confirmation

👤 Profile (Tab 4)
├── My Profile
│   ├── Avatar & Banner
│   ├── Rating Card (display rating, badge, rank)
│   ├── Stats Summary (events, scores, streaks)
│   ├── Achievements & Badges
│   ├── My Club
│   ├── Bow Setup Log
│   └── Social Feed (my posts)
├── Edit Profile
├── My Club
│   ├── Club Home
│   ├── Members
│   ├── Schedule
│   └── Club Chat
├── Notifications
│   ├── Rating Updates
│   ├── Event Reminders
│   ├── Social (likes, comments, follows)
│   └── Market (order updates)
└── Settings
    ├── Account
    ├── Notifications Preferences
    ├── Privacy
    ├── Appearance (theme, dark mode)
    ├── Units (metric/imperial)
    ├── Language
    ├── Subscription (Premium/Elite)
    ├── Help & FAQ
    └── About ManahPro
```

### 5.2 Screen Depth Rule

```
ATURAN KEDALAMAN SCREEN:
════════════════════════

Dari bottom nav tab → ke screen terdalam = MAKSIMAL 3 level deep

Level 0: Bottom nav (selalu visible)
Level 1: Tab content (Events list, Score today)
Level 2: Detail screen (Event detail, Session detail)
Level 3: Action screen (Registration form, Score input)

JANGAN buat flow yang butuh > 3 level deep!
Jika terpaksa > 3 level → pertimbangkan untuk:
├── Jadikan modal/bottom sheet (bukan push navigation)
├── Gabungkan 2 level menjadi 1 (tabbed detail)
└── Provide shortcut/deep link
```

---

## 6. Screen-by-Screen UX Blueprint

### 6.1 Home / Score Tab — "The Dashboard"

```
┌─────────────────────────────────────┐
│ ≡ ManahPro         🔔 2            │  ← Simple top bar
├─────────────────────────────────────┤
│                                     │
│  Selamat Pagi, Andi! 👋            │  ← Personalized greeting
│  Hari ke-7 streak latihan 🔥       │  ← Motivation hook
│                                     │
│  ┌─────────────────────────────┐   │
│  │  🎯 SKOR TERAKHIR          │   │  ← Hero card
│  │                             │   │
│  │     658 / 720              │   │  ← Large number display
│  │     Recurve 70m · Kemarin  │   │
│  │                             │   │
│  │  Personal Best: 672  ▲14   │   │
│  │  [Lihat Detail]            │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌──────────┐ ┌──────────┐         │  ← Quick action cards
│  │ 📊       │ │ 🏆       │         │
│  │ Rating   │ │ Event    │         │
│  │ 1712 🥈  │ │ 2 minggu │         │
│  │ ▲+23     │ │ depan    │         │
│  └──────────┘ └──────────┘         │
│                                     │
│  ─── Progress Minggu Ini ───       │  ← Section header
│                                     │
│  ┌─────────────────────────────┐   │
│  │  📈                         │   │
│  │  S  S  R  K  J  S  M       │   │  ← Weekly chart
│  │  ██ ██ ██ ██ ░░ ░░ ░░      │   │
│  │  645 658 640 658            │   │
│  └─────────────────────────────┘   │
│                                     │
│  ─── Tips & Artikel ───           │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📖 5 Kesalahan Grip yang   │   │  ← Content card
│  │    Sering Dilakukan Pemula  │   │
│  │    3 min read               │   │
│  └─────────────────────────────┘   │
│                                     │
├──────┬───────┬──────┬─────────────┤
│ 🎯   │  🏆   │ 🏪   │   👤        │  ← Bottom nav
│Score │Events │Market│ Profile     │
└──────┴───────┴──────┴─────────────┘

     ┌──────┐
     │  ➕  │  ← FAB: New Score Session
     └──────┘
```

### 6.2 Scoring Input — "The Core Experience"

```
THIS IS THE MOST IMPORTANT SCREEN IN THE APP.
If this screen is bad, the entire app fails.

DESIGN PRINCIPLES FOR SCORING:
├── SPEED: < 3 detik per arrow input
├── ACCURACY: Mudah mengoreksi kesalahan
├── ONE-HANDED: Bisa dioperasikan dengan satu tangan
├── OUTDOOR-FRIENDLY: High contrast, readable in sunlight
└── OFFLINE: HARUS bisa dipakai tanpa internet

┌─────────────────────────────────────┐
│  ← Back        End 3/12       Done  │  ← Minimal header
├─────────────────────────────────────┤
│                                     │
│  Total: 185 / 216                  │  ← Running total
│  Avg: 9.25 per arrow               │  ← Real-time stat
│                                     │
│  End 3:                            │
│  ┌─────────────────────────────┐   │
│  │                             │   │
│  │  [10] [10] [9]  [ ] [ ] [ ]│   │  ← Arrow slots (fill L→R)
│  │                             │   │
│  │    End total: 29            │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │                             │   │  ← Score input pad
│  │  [ M ] [ 1 ] [ 2 ] [ 3 ]  │   │     (M = miss, X = inner 10)
│  │                             │   │
│  │  [ 4 ] [ 5 ] [ 6 ] [ 7 ]  │   │     BESAR, mudah di-tap
│  │                             │   │     dengan thumb
│  │  [ 8 ] [ 9 ] [10 ] [ X ]  │   │
│  │                             │   │
│  │        [ ⌫ Undo ]          │   │  ← Undo last input
│  │                             │   │
│  └─────────────────────────────┘   │
│                                     │
│  [Previous End ◀] [▶ Next End]    │  ← End navigation
│                                     │
└─────────────────────────────────────┘

UX DETAILS:
├── Tap angka → otomatis masuk ke slot berikutnya
├── Setelah 6 arrows (1 end) → otomatis swipe ke end berikutnya
├── Haptic feedback pada setiap tap
├── Angka 10 dan X berwarna gold (highlight achievement)
├── M (miss) berwarna merah muda
├── Undo membatalkan input terakhir (bukan confirm dialog!)
├── Progress bar di top menunjukkan posisi end
├── Swipe left/right untuk navigasi antar end
└── WARNA KONTRAS TINGGI untuk outdoor readability
```

### 6.3 Event Detail

```
┌─────────────────────────────────────┐
│  ← Back                    ♡  ⋮   │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │                             │   │
│  │   [EVENT BANNER IMAGE]      │   │  ← Full-width hero image
│  │                             │   │
│  └─────────────────────────────┘   │
│                                     │
│  🏆 Bandung Open Championship     │  ← Event title
│  Tier A · Regional Championship    │  ← Badge + subtitle
│                                     │
│  ┌──────┐ ┌──────┐ ┌──────┐       │  ← Info chips
│  │📅    │ │📍    │ │🏹    │       │
│  │15 Jun│ │Bandung│ │Recurve│      │
│  └──────┘ └──────┘ └──────┘       │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  28 / 50 slot terisi        │   │  ← Capacity bar
│  │  ████████████░░░░░░░░░░░░░  │   │
│  │  Registration closes in 5d  │   │
│  └─────────────────────────────┘   │
│                                     │
│  [About] [Schedule] [Participants] │  ← In-page tabs
│                                     │
│  About:                            │
│  Turnamen panahan terbuka untuk    │
│  semua divisi Recurve. Menggunakan │
│  format WA 720 ranking round...    │
│                                     │
│  📍 Lapangan Panahan Arcamanik    │  ← Location with map preview
│  [Buka di Maps]                    │
│                                     │
│  Jadwal:                           │
│  07:00 - Registrasi               │
│  08:00 - Upacara Pembukaan        │
│  08:30 - Ranking Round (36+36)    │
│  ...                               │
│                                     │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │  ← Sticky bottom CTA
│  │  Rp 150.000      [DAFTAR]  │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘

UX DETAILS:
├── CTA "DAFTAR" sticky di bottom (selalu visible saat scroll)
├── Harga dan CTA di bottom = thumb zone friendly
├── Tab switching TANPA page reload (in-place content swap)
├── Map preview bisa di-tap untuk buka di Google Maps
├── Social proof: "Andi dan 5 teman kamu sudah terdaftar"
├── Countdown timer jika deadline mendekati
└── Share button untuk invite teman
```

---

## 7. Onboarding Flow

### 7.1 Prinsip Onboarding 2026

```
ATURAN EMAS ONBOARDING:
═══════════════════════

1. JANGAN paksa sign up sebelum user merasakan value
2. Maksimal 3-4 screen (bukan 7-8!)
3. SELALU ada tombol "Skip" / "Nanti saja"
4. Personalisasi minimal: 1-2 pertanyaan cepat
5. Time to Value < 60 detik
6. Interactive > Static carousel
```

### 7.2 Flow Onboarding ManahPro

```
SCREEN 1: WELCOME (Auto-play, 3 detik)
═══════════════════════════════════════
┌─────────────────────────────────────┐
│                                     │
│         [ManahPro Logo]             │
│                                     │
│    "Rangkul Panahan Indonesia"      │
│                                     │
│    Track · Compete · Connect        │
│                                     │
│     [Mulai →]        Skip           │
│                                     │
│     ● ○ ○                           │
└─────────────────────────────────────┘

SCREEN 2: PERSONALISASI CEPAT (15 detik)
════════════════════════════════════════
┌─────────────────────────────────────┐
│                                     │
│    Apa tipe panahan kamu?           │
│                                     │
│    ┌─────────┐  ┌─────────┐       │
│    │ 🏹      │  │ 🎯      │       │
│    │ Recurve │  │ Compound│       │
│    └─────────┘  └─────────┘       │
│    ┌─────────┐  ┌─────────┐       │
│    │ 🏺      │  │ 🌙      │       │
│    │ Barebow │  │ Tradisi │       │
│    └─────────┘  └─────────┘       │
│                                     │
│    (bisa pilih lebih dari satu)     │
│                                     │
│     [Lanjut →]       Skip           │
│                                     │
│     ○ ● ○                           │
└─────────────────────────────────────┘

SCREEN 3: FIRST ACTION (Value moment!)
═══════════════════════════════════════
┌─────────────────────────────────────┐
│                                     │
│    Yuk, catat skor pertamamu! 🎯   │
│                                     │
│    [Illustration: person scoring]   │
│                                     │
│    "Hanya butuh 30 detik untuk      │
│     merasakan ManahPro"             │
│                                     │
│     [Mulai Scoring →]               │
│                                     │
│     Nanti saja, lihat-lihat dulu    │
│                                     │
│     ○ ○ ●                           │
└─────────────────────────────────────┘

SETELAH SCREEN 3:
├── Jika "Mulai Scoring" → langsung ke scoring input (TANPA login)
├── Jika "Nanti saja" → langsung ke Home/Score tab
├── Login/Register diminta saat:
│   ├── Mau save scoring session ke cloud
│   ├── Mau daftar event
│   ├── Mau post di feed
│   ├── Mau beli/jual di marketplace
│   └── Mau join club
└── Social login: Google, Apple, Phone number
```

### 7.3 Deferred Sign-Up Flow

```
USER MELAKUKAN AKSI YANG BUTUH AKUN
════════════════════════════════════

Skenario: User sudah input skor → tap "Save Session"

┌─────────────────────────────────────┐
│                                     │
│  ┌─────────────────────────────┐   │
│  │                             │   │
│  │  💾 Simpan skor kamu!       │   │  ← Bottom sheet, bukan
│  │                             │   │     full-screen blocker
│  │  Buat akun gratis untuk     │   │
│  │  menyimpan skor, melihat    │   │
│  │  progress, dan bergabung    │   │
│  │  dengan komunitas.          │   │
│  │                             │   │
│  │  [G] Lanjutkan dengan Google│   │
│  │  [🍎] Lanjutkan dengan Apple│   │
│  │  [📱] Gunakan Nomor HP     │   │
│  │                             │   │
│  │  Nanti saja (skor tetap    │   │
│  │  tersimpan di device ini)   │   │
│  │                             │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘

ATURAN:
├── SELALU kasih opsi "Nanti saja"
├── Jelaskan BENEFIT dari sign up (bukan perintah)
├── Prioritaskan social login (1 tap vs mengisi form)
├── Data lokal TETAP tersimpan meskipun belum sign up
└── Jangan paksa email + password (friction tertinggi)
```

---

## 8. Motion Design & Micro-Interactions

### 8.1 Prinsip Motion

```
MOTION PRINCIPLES (Material Motion — 2026):
════════════════════════════════════════════

1. INFORMATIVE: Motion menjelaskan spatial relationship
   ├── Card expand → detail screen (shared element transition)
   ├── Bottom sheet slide up → konteks baru
   └── Page transition → arah menunjukkan hierarchy

2. FOCUSED: Motion mengarahkan attention
   ├── Rating naik → number count-up animation
   ├── Achievement unlocked → celebration burst
   └── Error → shake animation pada input field

3. EXPRESSIVE: Motion memberi personality
   ├── Score input → satisfying "pop" animation
   ├── Personal best → confetti + glow effect
   └── Streak counter → fire emoji bounce

4. FAST: Motion TIDAK BOLEH menghalangi
   ├── Transition: 200-300ms MAKSIMAL
   ├── Micro-interaction: 100-200ms
   ├── Loading skeleton: immediate (0ms delay)
   └── JANGAN animate yang menghalangi user action
```

### 8.2 Specific Micro-Interactions ManahPro

```
SCORING:
├── Tap score button:
│   ├── Button: scale down 95% → scale up 100% (100ms, ease-out)
│   ├── Score slot: fade in + slight bounce (150ms)
│   ├── Haptic: light impact feedback
│   └── If score 10/X: gold shimmer effect on slot
│
├── End complete (6 arrows entered):
│   ├── End total: count-up animation (300ms)
│   ├── Auto-advance: slide left to next end (250ms)
│   └── Haptic: medium impact feedback
│
├── Session complete:
│   ├── Total score: count-up from 0 to final (800ms)
│   ├── If personal best: confetti burst + "NEW PB! 🎉" toast
│   ├── Rating change preview: slide up from bottom (300ms)
│   └── Share card: fade in with slight scale up (200ms)

RATING UPDATE:
├── Rating number change:
│   ├── Old number → roll/count to new number (600ms)
│   ├── Green glow if positive, red if negative
│   ├── Arrow indicator (▲/▼) bounces in (200ms)
│   └── Badge changes → shine/shimmer transition (500ms)

NAVIGATION:
├── Bottom nav tab switch:
│   ├── Crossfade between pages (200ms)
│   ├── Active indicator pill slides (200ms, Material motion)
│   ├── NO slide left/right (Material spec says crossfade)
│   └── Icon: filled when active, outlined when inactive
│
├── Card → Detail:
│   ├── Shared element transition (hero animation)
│   ├── Image expands, text repositions (300ms)
│   └── Back: reverse animation

FEED:
├── Like button:
│   ├── Heart: scale up 120% → back to 100% (200ms, bounce)
│   ├── Color: grey → red (instant)
│   ├── Particle burst from heart center (optional, 300ms)
│   └── Haptic: light impact
│
├── Pull to refresh:
│   ├── Custom archer pulling bow animation (lottie)
│   ├── Release → arrow flies → content refreshes
│   └── Fun, branded, memorable
```

### 8.3 Flutter Implementation Notes

```dart
// Hero animation for card → detail
Hero(
  tag: 'event-${event.id}',
  child: EventCard(event: event),
)

// Score input tap animation
ScaleTransition / AnimatedScale
  duration: 100ms
  curve: Curves.easeOut

// Rating count-up
TweenAnimationBuilder<int>(
  tween: IntTween(begin: oldRating, end: newRating),
  duration: Duration(milliseconds: 600),
  curve: Curves.easeOutCubic,
  builder: (context, value, child) => Text('$value'),
)

// Bottom nav indicator
NavigationBar (Material 3) — built-in pill animation

// Shared element transition
Navigator.push(
  MaterialPageRoute(builder: (_) => DetailScreen()),
  // atau gunakan go_router + Hero
)

// Skeleton loading
shimmer package / custom ShaderMask animation
```

---

## 9. Dark Mode Strategy

### 9.1 Dark Mode = First-Class Citizen

```
MENGAPA DARK MODE PENTING UNTUK MANAHPRO:
├── 70%+ user Indonesia menggunakan dark mode (data 2025)
├── OLED screens (dominan di mid-range Android) → hemat baterai
├── Latihan outdoor sering di pagi/sore → less glare
├── Scoring di sore/malam hari (indoor range) → mata nyaman
└── Premium feel — dark UI terasa lebih "professional"

STRATEGI: Design dark-first, validate light-second
```

### 9.2 Dark Mode Color Mapping

```
DARK MODE ≠ INVERSI WARNA!
══════════════════════════

                        LIGHT MODE        DARK MODE
                        ──────────        ─────────
Background (base)       #FAFAFA           #121212 (NOT pure black!)
Surface (elevated)      #FFFFFF           #1E1E1E
Surface (higher)        #FFFFFF + shadow  #2C2C2C (tonal elevation)
Surface (highest)       #FFFFFF + more    #383838

Text (primary)          #1A1A1A           #E8E8E8 (NOT pure white!)
Text (secondary)        #666666           #AAAAAA
Text (disabled)         #BDBDBD           #555555

Brand (primary)         #2E7D32           #66BB6A (lighter green!)
Brand (surface)         #E8F5E9           #1B3A1E (dark green tint)

Border (default)        #E0E0E0           #333333
Border (focus)          #2E7D32           #66BB6A

Error                   #D32F2F           #EF5350 (lighter!)
Success                 #2E7D32           #66BB6A
Warning                 #F57C00           #FFA726

Card shadow             0.1 opacity       NONE (use tonal elevation)
```

### 9.3 Dark Mode Rules

```
ATURAN KRITIS:
═════════════

1. JANGAN gunakan pure black (#000000) sebagai background
   ├── Terlalu kontras → mata cepat lelah
   ├── OLED "smearing" pada scroll
   └── Gunakan #121212 atau lebih gelap dari #181818

2. JANGAN gunakan pure white (#FFFFFF) untuk text
   ├── Terlalu glare pada dark background
   └── Gunakan #E8E8E8 atau #EBEBEB

3. JANGAN langsung invert warna brand
   ├── Green #2E7D32 terlalu gelap di dark bg → tidak terlihat
   └── Gunakan varian yang lebih terang: #66BB6A

4. Gunakan TONAL ELEVATION, bukan shadow
   ├── Light mode: card lebih tinggi = shadow lebih besar
   └── Dark mode: card lebih tinggi = surface lebih terang

5. Test SEMUA screen di dark mode sebelum launch
   ├── Terutama: charts, graphs, maps
   ├── Image dengan background transparan
   └── Status colors (error, success, warning)

6. Respect system preference
   ├── Default: ikuti system dark/light mode
   ├── Manual override di Settings
   └── Transisi smooth saat switch (200ms fade)
```

---

## 10. Accessibility (A11y) Checklist

### Checklist Wajib

```
ACCESSIBILITY CHECKLIST MANAHPRO
════════════════════════════════

TOUCH TARGETS:
☐ Semua button/icon minimal 48×48dp (Material) / 44×44pt (iOS)
☐ Spacing antar touch target minimal 8dp
☐ Bottom nav items memenuhi minimum size
☐ Score input pad: setiap tombol cukup besar untuk thumb

COLOR & CONTRAST:
☐ Text contrast ratio ≥ 4.5:1 (normal text)
☐ Text contrast ratio ≥ 3:1 (large text, >18pt)
☐ Warna BUKAN satu-satunya pembawa informasi
   (contoh: error → merah + icon + text, bukan merah saja)
☐ Semua UI berfungsi di grayscale (color blindness test)
☐ Score colors (10, X, M) punya shape/icon pembeda selain warna

SCREEN READER:
☐ Semua Image punya contentDescription / semanticsLabel
☐ Semua interaktif punya Semantics label
☐ Focus order logis (top-to-bottom, left-to-right)
☐ Custom widgets punya proper Semantics tree
☐ Score display readable: "Rating 1712, Advanced Archer, naik 23 poin"

TEXT SCALING:
☐ UI tidak pecah saat text scale 200%
☐ Content tetap readable saat font besar
☐ Scrollable containers menampung text expansion
☐ Truncation menggunakan ellipsis, bukan clip

MOTION:
☐ Animasi bisa dimatikan (AccessibilityFeatures.reduceMotion)
☐ Tidak ada flashing/strobing (epilepsy safety)
☐ Auto-play animation punya pause control

GENERAL:
☐ Error messages jelas dan actionable
☐ Form field punya label (bukan hanya placeholder)
☐ Loading states diumumkan ke screen reader
☐ Timeout yang cukup untuk semua user actions
```

### Flutter Implementation

```dart
// Semantics for score display
Semantics(
  label: 'Rating 1712, Advanced Archer, naik 23 poin bulan ini',
  child: RatingCard(rating: 1712, change: 23),
)

// Touch target minimum
SizedBox(
  width: 48,
  height: 48,
  child: IconButton(
    icon: Icon(Icons.favorite),
    onPressed: _onLike,
  ),
)

// Reduced motion check
final reduceMotion = MediaQuery.of(context).disableAnimations;
final duration = reduceMotion ? Duration.zero : Duration(milliseconds: 300);

// Text scaling respect
Text(
  'Score: 658',
  style: Theme.of(context).textTheme.headlineMedium,
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
)
```

---

## 11. Platform-Specific Adaptations

### 11.1 Flutter Adaptive Strategy

```
STRATEGI: Material Design 3 sebagai baseline, 
          dengan adaptive overrides untuk iOS

LEVEL 1 — UNIVERSAL (Sama di semua platform):
├── Brand colors, typography, spacing (design tokens)
├── Information architecture (nav structure)
├── Business logic & data layer
├── Animations & micro-interactions
└── Offline strategy

LEVEL 2 — PLATFORM-ADAPTIVE (Berbeda per platform):
├── Navigation: NavigationBar (Android) vs CupertinoTabBar (iOS)
├── Scrolling: Material scroll vs Cupertino bounce
├── Dialogs: Material dialog vs CupertinoAlertDialog
├── Switches: Material Switch vs CupertinoSwitch
├── Date picker: Material vs Cupertino
├── Pull-to-refresh: Material indicator vs Cupertino sliver
└── Back navigation: System back (Android) vs Swipe back (iOS)

LEVEL 3 — PLATFORM-EXCLUSIVE (Hanya di satu platform):
├── iOS: Liquid Glass effects (jika mau, optional premium feel)
├── Android: Dynamic Color (Material You, dari wallpaper)
├── Android: Predictive back gesture
└── iOS: Dynamic Island / Live Activity (untuk live scoring)
```

### 11.2 Flutter Adaptive Breakpoints

```
RESPONSIVE BREAKPOINTS (Material Design 3):
═══════════════════════════════════════════

Compact     : < 600dp   → Phone portrait
              Bottom Navigation Bar
              Single column layout
              Full-width cards

Medium      : 600-840dp → Phone landscape / Small tablet
              Navigation Rail (side)
              Two column where appropriate
              Side-by-side cards

Expanded    : > 840dp   → Tablet / Desktop
              Navigation Rail or Drawer
              Multi-column layout
              List-detail view

IMPLEMENTASI:
├── Gunakan LayoutBuilder untuk responsive layout
├── Gunakan MediaQuery.sizeOf(context) untuk global checks
├── JANGAN cek "isPhone" atau "isTablet" — cek available width
├── Navigation auto-switch: Bottom Nav → Rail → Drawer
└── Gunakan adaptive_scaffold package dari M3
```

### 11.3 Adaptive Navigation Code Pattern

```dart
// lib/core/navigation/adaptive_navigation.dart

class AdaptiveScaffold extends StatelessWidget {
  final int selectedIndex;
  final List<NavigationDestination> destinations;
  final List<Widget> pages;
  final ValueChanged<int> onDestinationSelected;
  
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    
    // Compact: Bottom Navigation Bar
    if (width < 600) {
      return Scaffold(
        body: pages[selectedIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: destinations,
        ),
      );
    }
    
    // Medium: Navigation Rail
    if (width < 840) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              destinations: destinations.map((d) => 
                NavigationRailDestination(
                  icon: d.icon, 
                  label: Text(d.label),
                ),
              ).toList(),
            ),
            Expanded(child: pages[selectedIndex]),
          ],
        ),
      );
    }
    
    // Expanded: Navigation Drawer
    return Scaffold(
      body: Row(
        children: [
          NavigationDrawer(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            children: destinations.map((d) => 
              NavigationDrawerDestination(
                icon: d.icon, 
                label: Text(d.label),
              ),
            ).toList(),
          ),
          Expanded(child: pages[selectedIndex]),
        ],
      ),
    );
  }
}
```

---

## 12. Anti-Pattern: Kesalahan yang Harus Dihindari

### ❌ JANGAN Lakukan Ini

```
ANTI-PATTERN #1: Splash Screen yang Lama
════════════════════════════════════════
❌ Logo animasi 5 detik + loading bar + tips
✅ Splash screen < 2 detik, langsung masuk app
   Gunakan native splash (flutter_native_splash) → instant

ANTI-PATTERN #2: Login Wall di Awal
════════════════════════════════════
❌ Buka app → langsung form login/register
✅ Buka app → langsung bisa explore → login saat butuh
   "Show value first, ask commitment later"

ANTI-PATTERN #3: Hamburger Menu sebagai Primary Nav
════════════════════════════════════════════════════
❌ ≡ Menu di top-left → semua navigasi di dalamnya
✅ Bottom Navigation Bar → 4 tab → langsung terlihat

ANTI-PATTERN #4: Carousel Tutorial Panjang
══════════════════════════════════════════
❌ 7 slide tutorial → user skip semua → bingung
✅ 3 slide max → interactive → learn by doing

ANTI-PATTERN #5: Pop-up & Dialog Berlebihan
═══════════════════════════════════════════
❌ "Rate our app!" + "Enable notifications?" + "Subscribe now!" 
   (semua muncul dalam 30 detik pertama)
✅ Contextual request → saat user sudah engage
   Rate: setelah personal best | Notif: setelah event registration

ANTI-PATTERN #6: "Are You Sure?" Dialog
════════════════════════════════════════
❌ Setiap action → "Apakah Anda yakin?" → Yes/No
✅ Undo pattern → action langsung terjadi → "Undo" toast 5 detik
   (kecuali destructive action seperti delete account)

ANTI-PATTERN #7: Loading Spinner Everywhere
═══════════════════════════════════════════
❌ Screen kosong + spinner berputar → user tidak tahu apa yang loading
✅ Skeleton screen → user melihat layout → konten terisi bertahap

ANTI-PATTERN #8: Infinite Scroll Tanpa Konteks
═════════════════════════════════════════════
❌ Feed yang scroll terus tanpa tahu "di mana" posisi
✅ Section headers + "Back to top" FAB + pagination indicator

ANTI-PATTERN #9: Form Validasi Setelah Submit
════════════════════════════════════════════
❌ User mengisi semua → tap Submit → "Email invalid" → ulang
✅ Inline validation → error muncul saat user meninggalkan field

ANTI-PATTERN #10: Terlalu Banyak Warna
═══════════════════════════════════════
❌ Setiap section warna berbeda → visual chaos
✅ 1 warna primer + 1 aksen + neutrals
   Variasi via shade/tone, bukan hue baru

ANTI-PATTERN #11: Desain untuk iPhone 15 Pro Saja
══════════════════════════════════════════════════
❌ Test hanya di iPhone flagship → jelek di Android mid-range
✅ Test di Samsung A15, Redmi Note 12, Realme C55
   (mid-range Android = 70%+ user Indonesia!)

ANTI-PATTERN #12: Ignore Text Scaling
═════════════════════════════════════
❌ Layout pecah saat user pakai font besar (aksesibilitas)
✅ Test dengan system text scale 200%
   Gunakan flexible layouts, bukan fixed height
```

---

## 13. Referensi & Benchmark Apps

### Apps untuk Dipelajari (UX Patterns)

| App | Pelajari Apa | Platform |
|-----|-------------|----------|
| **Strava** | Activity tracking flow, social feed, streak system, club management | iOS, Android |
| **Nike Training Club** | Clean scoring/workout UI, progress visualization, motion design | iOS, Android |
| **Duolingo** | Gamification, streak, emotional design, mascot feedback, habit loop | iOS, Android |
| **Chess.com** | ELO rating display, ranking UI, match history, analysis board | iOS, Android |
| **Tokopedia** | Indonesian marketplace UX, payment flow, trust/review system | iOS, Android |
| **Gojek** | Indonesian super-app nav, bottom sheet usage, quick actions | iOS, Android |
| **Artemis** | Archery scoring UX (competitor), target recognition | iOS, Android |
| **Ianseo** | Tournament scoring system (professional standard) | Web, Mobile |
| **Notion** | Clean content layout, progressive disclosure, bottom-sheet menus | iOS, Android |
| **Spotify** | Dark mode done right, navigation, personalized home, motion | iOS, Android |

### Design Resources

```
DESIGN SYSTEM REFERENCES:
├── Material Design 3: material.io/design (Google)
├── Apple HIG: developer.apple.com/design (Apple)
├── Liquid Glass: developer.apple.com/design/liquid-glass
├── Carbon Design System: carbondesignsystem.com (IBM)
└── Atlassian Design System: atlassian.design

TOOLS:
├── Figma — UI Design & Prototyping
├── Lottie — Animation files for Flutter
├── Rive — Interactive animations
├── Google Fonts — Inter, Plus Jakarta Sans
└── Real Device Testing — Firebase Test Lab, BrowserStack

FLUTTER PACKAGES (Recommended):
├── go_router — declarative navigation
├── flutter_animate — easy animations
├── shimmer — skeleton loading
├── cached_network_image — image caching
├── flutter_native_splash — native splash screen
├── adaptive_scaffold — M3 responsive layout
├── google_fonts — typography
└── connectivity_plus — offline detection
```

---

## Ringkasan: 7 Hal yang HARUS Diingat

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  1. BOTTOM NAV 4 TAB — Score, Events, Market, Profile          │
│     (bukan hamburger menu, bukan 5+ tab)                       │
│                                                                 │
│  2. THUMB ZONE FIRST — semua primary action di bottom 1/3      │
│                                                                 │
│  3. DARK MODE = DEFAULT — design dark-first, validate light    │
│                                                                 │
│  4. PERFORMANCE = DESIGN — cold start < 2.5s, 60fps, skeleton  │
│                                                                 │
│  5. DEFERRED SIGN-UP — biarkan user explore dulu, login nanti  │
│                                                                 │
│  6. SCORING < 3 DETIK — score input HARUS secepat mungkin      │
│                                                                 │
│  7. TEST DI MID-RANGE ANDROID — bukan hanya iPhone flagship    │
│                                                                 │
│  Jika 7 hal ini benar, kamu sudah 80% menang.                  │
│  Sisanya adalah polish dan iteration.                           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

*Dokumen ini adalah living reference untuk seluruh tim development ManahPro. Setiap keputusan UI/UX harus dirujuk kembali ke prinsip-prinsip dalam dokumen ini.*

*Disusun berdasarkan riset dan best practices terbaru per Mei 2026:*
- *Material Design 3 (Google, 2025)*
- *Apple Human Interface Guidelines & Liquid Glass (iOS 26, Sept 2025)*
- *Nielsen Norman Group UX Research (2024-2025)*
- *Flutter Adaptive Design Guidelines (2025)*
- *WCAG 2.2 AA Accessibility Standards*

*Last updated: 28 Mei 2026*
*Author: ManahPro Design Team*
