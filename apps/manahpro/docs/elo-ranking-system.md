# ManahPro National Digital Ranking System
## Adaptasi ELO Rating untuk Panahan Indonesia

> **Dokumen ini menganalisis secara mendalam bagaimana sistem ELO — yang awalnya diciptakan untuk catur — dapat diadaptasi untuk membangun ranking nasional panahan yang adil, transparan, dan real-time.**

---

## Daftar Isi

1. [Mengapa ELO? Dan Mengapa Tidak Langsung Pakai ELO Klasik?](#1-mengapa-elo)
2. [Fundamental ELO Klasik](#2-fundamental-elo-klasik)
3. [Masalah ELO Klasik untuk Panahan](#3-masalah-elo-klasik-untuk-panahan)
4. [Sistem Rating ManahPro: Modified Glicko-2 + Score-Based](#4-sistem-rating-manahpro)
5. [Formula Lengkap & Derivasi](#5-formula-lengkap--derivasi)
6. [Kategori & Divisi Ranking](#6-kategori--divisi-ranking)
7. [Tournament Tier & K-Factor System](#7-tournament-tier--k-factor-system)
8. [Activity Decay & Rating Confidence](#8-activity-decay--rating-confidence)
9. [Worked Examples (Contoh Perhitungan)](#9-worked-examples)
10. [Anti-Gaming & Fairness Mechanisms](#10-anti-gaming--fairness-mechanisms)
11. [Implementation Architecture](#11-implementation-architecture)
12. [Perbandingan dengan Sistem Ranking Lain](#12-perbandingan-dengan-sistem-ranking-lain)
13. [Migration Path dari Manual ke Digital](#13-migration-path)

---

## 1. Mengapa ELO?

### Masalah dengan Ranking Panahan Tradisional

Sistem ranking panahan saat ini (termasuk yang dipakai PERPANI dan World Archery) umumnya berbasis **akumulasi poin**:

```
Ranking Tradisional:
  Poin = Σ (poin dari setiap event yang diikuti)
  
  Masalah:
  ├── Pemanah yang ikut banyak event → ranking tinggi (bias kuantitas)
  ├── Tidak memperhitungkan kualitas lawan yang dihadapi
  ├── Tidak ada decay → juara 3 tahun lalu masih terakumulasi
  └── Tidak bisa membandingkan antar divisi/jarak secara relatif
```

### Mengapa ELO-Based System Lebih Baik?

| Aspek | Sistem Poin Tradisional | ELO-Based System |
|-------|------------------------|------------------|
| **Kualitas vs Kuantitas** | Kuantitas event menentukan | Kualitas performa relatif terhadap lawan |
| **Strength of Opponent** | Tidak diperhitungkan | Inti dari perhitungan |
| **New Player** | Harus ikut banyak event dulu | Rating konvergen lebih cepat |
| **Fairness** | Bisa di-game dengan ikut event mudah | Self-correcting |
| **Transparency** | Rumus sederhana tapi unfair | Rumus kompleks tapi sangat fair |
| **Real-time** | Update periodik | Update setelah setiap event |

### Mengapa Tidak ELO Klasik Langsung?

ELO klasik diciptakan untuk **catur** — permainan 1 lawan 1 dengan hasil win/lose/draw. Panahan memiliki karakteristik fundamental yang berbeda:

```
CATUR (ELO Klasik)              PANAHAN (Perlu Adaptasi)
──────────────────              ────────────────────────
1 vs 1                          Multi-player (10-100+ pemanah)
Win / Lose / Draw               Score-based (0-720 poin)
Tidak ada "skor margin"         Margin of victory penting
Satu format                     Multiple format (ranking, elimination, match)
Satu "divisi"                   Multiple divisi & jarak
Tidak ada faktor cuaca          Cuaca, indoor/outdoor berbeda
Frekuensi tinggi (banyak game)  Frekuensi rendah (beberapa event/tahun)
```

**Kesimpulan**: Kita butuh **sistem hybrid** yang mengambil filosofi ELO (rating relatif berdasarkan kekuatan lawan) tapi diadaptasi untuk realitas panahan.

---

## 2. Fundamental ELO Klasik

### Sebelum Mengadaptasi, Pahami Dulu Dasarnya

#### 2.1 Konsep Inti

Setiap pemain memiliki **rating numerik** (biasanya mulai dari 1500). Rating ini merepresentasikan **estimasi kekuatan** pemain. Ketika dua pemain bertanding:

- Pemain yang **lebih kuat** (rating lebih tinggi) **diharapkan** menang
- Jika pemain yang **lebih lemah** menang → ia **mendapat banyak poin**
- Jika pemain yang **lebih kuat** menang → ia **mendapat sedikit poin**

#### 2.2 Formula ELO Klasik

**Step 1: Hitung Expected Score (Probabilitas Menang)**

```
                          1
E_A = ─────────────────────────────
       1 + 10^((R_B - R_A) / 400)
```

Di mana:
- `E_A` = expected score pemain A (probabilitas A menang)
- `R_A` = rating pemain A saat ini
- `R_B` = rating pemain B saat ini
- `400` = scaling factor (menentukan seberapa besar perbedaan rating mempengaruhi probabilitas)

**Step 2: Update Rating Setelah Pertandingan**

```
R'_A = R_A + K × (S_A - E_A)
```

Di mana:
- `R'_A` = rating baru pemain A
- `K` = K-factor (menentukan volatilitas/sensitivitas)
- `S_A` = actual score (1 = menang, 0.5 = seri, 0 = kalah)
- `E_A` = expected score (dari Step 1)

**Contoh Sederhana:**

```
Pemain A: Rating 1600
Pemain B: Rating 1400

Expected Score A:
E_A = 1 / (1 + 10^((1400-1600)/400))
E_A = 1 / (1 + 10^(-0.5))
E_A = 1 / (1 + 0.3162)
E_A = 0.7597 (A diharapkan menang 76% of the time)

Jika A menang (S_A = 1), K = 32:
R'_A = 1600 + 32 × (1 - 0.7597) = 1600 + 7.69 = 1607.69
R'_B = 1400 + 32 × (0 - 0.2403) = 1400 - 7.69 = 1392.31

Jika B yang menang (upset!), K = 32:
R'_A = 1600 + 32 × (0 - 0.7597) = 1600 - 24.31 = 1575.69
R'_B = 1400 + 32 × (1 - 0.2403) = 1400 + 24.31 = 1424.31
```

> **Insight**: Ketika underdog menang, perpindahan rating jauh lebih besar (24.31 vs 7.69). Ini yang membuat ELO **self-correcting** — pemain yang under-rated akan cepat naik.

---

## 3. Masalah ELO Klasik untuk Panahan

### 3.1 Multi-Player Problem

ELO klasik hanya untuk 2 pemain. Di turnamen panahan, 30-100+ pemanah bertanding bersamaan.

**Solusi**: Dekomposisi menjadi **virtual pairwise comparisons**

```
Turnamen dengan N pemanah = N×(N-1)/2 pasangan virtual

Contoh: 30 pemanah = 30×29/2 = 435 pasangan virtual
Setiap pemanah "bertanding" melawan 29 pemanah lainnya
```

### 3.2 Score-Based vs Win/Loss

Pemanah A mencetak 680/720, Pemanah B mencetak 678/720. Dalam ELO klasik, ini sama saja dengan A menang 720 vs B 300. Padahal **margin of victory** sangat berbeda.

**Solusi**: Gunakan **Score Differential Function** untuk menentukan "derajat kemenangan"

### 3.3 Rating Uncertainty

Pemanah baru dan pemanah yang jarang bertanding memiliki rating yang **kurang pasti**. ELO klasik tidak menangani ini.

**Solusi**: Gunakan **Glicko-2** yang menambahkan parameter **Rating Deviation (RD)** dan **Volatility (σ)**

### 3.4 Format Berbeda

Ranking round (72 anak panah), match play (set system), dan head-to-head elimination memiliki karakteristik berbeda.

**Solusi**: **Format-adjusted K-factor** dan **normalisasi skor**

---

## 4. Sistem Rating ManahPro: Modified Glicko-2 + Score-Based

### 4.1 Tiga Parameter Rating

Setiap pemanah memiliki **tiga parameter**, bukan satu:

```
Rating Profile Pemanah:
┌─────────────────────────────────────────────┐
│  μ (mu)    = Rating        = 1500 (default) │  ← Estimasi kekuatan
│  φ (phi)   = Deviation     = 350 (default)  │  ← Ketidakpastian rating
│  σ (sigma) = Volatility    = 0.06 (default) │  ← Konsistensi performa
└─────────────────────────────────────────────┘
```

**Interpretasi:**

| Parameter | Artinya | Contoh |
|-----------|---------|--------|
| **μ = 1800** | Pemanah ini cukup kuat | Semakin tinggi = semakin kuat |
| **φ = 50** | Kita cukup yakin dengan rating-nya | Sudah banyak data (aktif bertanding) |
| **φ = 300** | Kita tidak yakin dengan rating-nya | Pemain baru atau lama tidak bertanding |
| **σ = 0.04** | Performa sangat konsisten | Skor selalu stabil |
| **σ = 0.09** | Performa sangat fluktuatif | Kadang bagus sekali, kadang jelek |

**Rating Confidence Interval:**

```
"True skill" pemanah diperkirakan berada di:

    μ ± 2φ  (95% confidence interval)

Contoh:
  μ = 1800, φ = 50  → True skill: 1700 - 1900 (cukup pasti)
  μ = 1500, φ = 300 → True skill: 900 - 2100 (sangat tidak pasti)
```

### 4.2 Displayed Rating vs Internal Rating

```
┌────────────────────────────────────────────────────────────┐
│  DISPLAY RATING (yang dilihat user):                       │
│                                                            │
│    R_display = μ - 2φ                                      │
│                                                            │
│  Ini adalah "conservative estimate" — batas bawah          │
│  dari confidence interval.                                 │
│                                                            │
│  Mengapa? Agar pemain baru (φ tinggi) tidak langsung       │
│  terlihat ranking tinggi sebelum data cukup.               │
│                                                            │
│  Contoh:                                                   │
│    Pemain baru: μ=1500, φ=350 → Display = 800             │
│    Veteran:     μ=1800, φ=50  → Display = 1700            │
└────────────────────────────────────────────────────────────┘
```

### 4.3 Overview Alur Perhitungan

```
┌──────────────┐     ┌──────────────┐     ┌──────────────────┐
│  Event       │     │  Collect     │     │  Normalize       │
│  Selesai     │────►│  All Scores  │────►│  Scores by       │
│              │     │  & Placements│     │  Format & Jarak  │
└──────────────┘     └──────────────┘     └────────┬─────────┘
                                                    │
                                                    ▼
┌──────────────┐     ┌──────────────┐     ┌──────────────────┐
│  Update μ,   │     │  Calculate   │     │  Generate        │
│  φ, σ for    │◄────│  Rating      │◄────│  Virtual         │
│  Each Archer │     │  Changes     │     │  Pairwise Matches│
└──────┬───────┘     └──────────────┘     └──────────────────┘
       │
       ▼
┌──────────────┐     ┌──────────────┐
│  Update      │     │  Publish     │
│  Display     │────►│  New         │
│  Rating      │     │  Rankings    │
└──────────────┘     └──────────────┘
```

---

## 5. Formula Lengkap & Derivasi

### 5.1 Pre-Processing: Score Normalization

Karena format panahan berbeda-beda, kita perlu **menormalisasi skor** ke skala yang setara.

**Normalized Performance Score (NPS):**

```
                  S_actual - S_min
NPS = ────────────────────────────── × 1000
              S_max - S_min

Di mana:
  S_actual = skor yang dicapai pemanah
  S_max    = skor maksimal teoritis untuk format tersebut
  S_min    = skor minimum realistis (biasanya 0 atau floor statistik)
```

**Contoh untuk berbagai format:**

| Format | S_max | S_min | Skor 650 → NPS |
|--------|-------|-------|-----------------|
| Ranking Round 70m (72 arrows) | 720 | 0 | (650/720) × 1000 = 903 |
| Ranking Round 50m (72 arrows) | 720 | 0 | (650/720) × 1000 = 903 |
| Match Play (5 sets × 6 pts) | 30 | 0 | (24/30) × 1000 = 800 |
| Indoor 18m (60 arrows) | 600 | 0 | (560/600) × 1000 = 933 |

### 5.2 Virtual Pairwise Match Generation

Untuk N pemanah dalam satu event, kita generate semua pasangan dan tentukan outcome:

**Score Differential Function:**

```
Untuk pemanah i dan j:

                    1
S_ij = ──────────────────────────
        1 + e^(-λ × (NPS_i - NPS_j))

Di mana:
  S_ij = "derajat kemenangan" i atas j (0 sampai 1)
  NPS_i = Normalized Performance Score pemanah i
  NPS_j = Normalized Performance Score pemanah j
  λ    = sensitivity parameter (default: 0.01)
```

**Mengapa Sigmoid, Bukan Linear?**

```
Score Diff:  -100  -50   -20  -10   0   +10  +20  +50  +100
─────────────────────────────────────────────────────────────
Linear:      0.0   0.25  0.4  0.45  0.5  0.55 0.6  0.75 1.0
Sigmoid:     0.27  0.38  0.45 0.47  0.5  0.53 0.55 0.62 0.73

Sigmoid lebih baik karena:
├── Menang tipis (NPS diff 10) → hampir sama dengan seri (0.53 vs 0.47)
├── Menang besar (NPS diff 100) → jelas menang tapi tidak absolut (0.73)
└── Mencegah over-weighting margin yang sangat besar
```

### 5.3 Glicko-2 Rating Update (Lengkap)

#### Step 1: Convert ke Glicko-2 Scale

```
μ_g2 = (μ - 1500) / 173.7178
φ_g2 = φ / 173.7178
```

#### Step 2: Hitung g(φ) dan E untuk Setiap Lawan

```
Untuk setiap lawan j:

                       1
g(φ_j) = ─────────────────────────
          √(1 + 3×φ_j² / π²)

                           1
E(μ_i, μ_j, φ_j) = ──────────────────────────────
                     1 + e^(-g(φ_j) × (μ_i - μ_j))
```

> **Intuisi g(φ_j)**: Lawan dengan rating tidak pasti (φ tinggi) memiliki pengaruh lebih kecil terhadap rating kita. Masuk akal — mengalahkan lawan yang rating-nya belum jelas tidak seharusnya memberi banyak poin.

#### Step 3: Hitung Estimated Variance (v)

```
         ┌                                              ┐ -1
v =      │ Σ  g(φ_j)² × E(μ_i,μ_j,φ_j) × (1 - E(...)) │
         └ j                                            ┘
```

#### Step 4: Hitung Estimated Improvement (Δ)

```
Δ = v × Σ [ g(φ_j) × (S_ij - E(μ_i, μ_j, φ_j)) ]
         j
```

Di mana `S_ij` adalah Score Differential dari Section 5.2.

#### Step 5: Update Volatility (σ) — Illinois Algorithm

Ini adalah bagian paling kompleks. Volatility σ menangkap seberapa konsisten seorang pemanah.

```
Definisi:
  a = ln(σ²)
  τ = system constant (default: 0.5, untuk panahan: 0.3-0.6)

Cari σ' baru dengan iterasi:
  f(x) = [e^x × (Δ² - φ² - v - e^x)] / [2×(φ² + v + e^x)²] - (x - a)/τ²

  Solve f(x) = 0 menggunakan Illinois method (bracket root finding)
  
  σ' = e^(x/2)
```

> **Untuk implementasi**: Gunakan 20-30 iterasi maximum. Illinois method konvergen cepat.

#### Step 6: Update Rating Deviation (φ)

```
φ*² = φ² + σ'²        ← "pre-rating period" deviation

         1
φ' = ────────────────
      √(1/φ*² + 1/v)
```

#### Step 7: Update Rating (μ)

```
μ' = μ + φ'² × Σ [ g(φ_j) × (S_ij - E(μ_i, μ_j, φ_j)) ]
              j
```

#### Step 8: Convert Back

```
μ_final = 173.7178 × μ' + 1500
φ_final = 173.7178 × φ'
```

### 5.4 Simplified Flow (Pseudocode)

```python
def update_rating(archer, opponents, scores, tournament_tier):
    """
    archer: { mu, phi, sigma }
    opponents: [{ mu, phi, sigma }, ...]
    scores: [S_ij, ...] -- score differential vs each opponent
    tournament_tier: multiplier for impact
    """
    
    # Step 1: Convert to Glicko-2 scale
    mu = (archer.mu - 1500) / 173.7178
    phi = archer.phi / 173.7178
    
    # Step 2: For each opponent, calculate g and E
    g_values = []
    E_values = []
    for opp in opponents:
        opp_phi = opp.phi / 173.7178
        opp_mu = (opp.mu - 1500) / 173.7178
        
        g_j = 1 / sqrt(1 + 3 * opp_phi**2 / pi**2)
        E_j = 1 / (1 + exp(-g_j * (mu - opp_mu)))
        
        g_values.append(g_j)
        E_values.append(E_j)
    
    # Step 3: Variance
    v_inv = sum(g**2 * E * (1 - E) for g, E in zip(g_values, E_values))
    v = 1 / v_inv
    
    # Step 4: Delta
    delta = v * sum(g * (s - E) for g, s, E in zip(g_values, scores, E_values))
    
    # Step 5: New volatility (Illinois algorithm)
    sigma_new = compute_new_volatility(phi, sigma, delta, v, tau=0.5)
    
    # Step 6: New deviation
    phi_star = sqrt(phi**2 + sigma_new**2)
    phi_new = 1 / sqrt(1/phi_star**2 + 1/v)
    
    # Step 7: New rating
    mu_new = mu + phi_new**2 * sum(
        g * (s - E) for g, s, E in zip(g_values, scores, E_values)
    )
    
    # Step 8: Convert back
    # Apply tournament tier multiplier to the change magnitude
    mu_change = mu_new - mu
    mu_adjusted = mu + mu_change * tournament_tier
    
    archer.mu = 173.7178 * mu_adjusted + 1500
    archer.phi = 173.7178 * phi_new
    archer.sigma = sigma_new
    
    return archer
```

---

## 6. Kategori & Divisi Ranking

### 6.1 Ranking Terpisah per Divisi

Setiap pemanah bisa punya **multiple ratings** di divisi berbeda:

```
STRUKTUR DIVISI RANKING
═══════════════════════

Berdasarkan TIPE BUSUR:
├── 🏹 Recurve (Olympic)
├── 🎯 Compound
├── 🪶 Barebow
├── 🏺 Traditional / Horsebow
└── 🌙 Sunnah / Islamic Traditional

Berdasarkan GENDER:
├── Putra
├── Putri
└── Mixed (untuk team events)

Berdasarkan USIA:
├── Cadet (< 17 tahun)
├── Junior (17-20 tahun)
├── Senior (21-49 tahun)
└── Master (50+ tahun)

Berdasarkan JARAK:
├── Indoor (18m)
├── Short Range (30m)
├── Medium Range (50m)
├── Long Range (70m)
└── Field Archery (varied)
```

### 6.2 Composite Rating

Selain rating per divisi, kita juga hitung **Composite Rating** untuk overall ranking:

```
R_composite = Σ (w_d × R_d) / Σ w_d

Di mana:
  R_d = rating di divisi d
  w_d = weight berdasarkan jumlah event di divisi d

Composite hanya dihitung jika pemanah aktif di ≥ 2 divisi
```

### 6.3 Cross-Division Rating Transfer

Ketika pemanah pertama kali bertanding di divisi baru:

```
Initial Rating untuk Divisi Baru:

Jika pemanah sudah punya rating di divisi lain:
  μ_new = 1500 + transfer_factor × (μ_existing - 1500)
  φ_new = 250 (moderate uncertainty)

Transfer Factors:
  Recurve → Barebow:     0.6  (skill transferable sebagian)
  Recurve → Compound:    0.5  (peralatan sangat berbeda)
  Traditional → Barebow: 0.7  (cukup mirip)
  Indoor → Outdoor:      0.8  (skill sangat transferable)
  
Jika pemanah benar-benar baru:
  μ_new = 1500
  φ_new = 350
  σ_new = 0.06
```

---

## 7. Tournament Tier & K-Factor System

### 7.1 Tier Turnamen

Tidak semua event sama bobotnya. Menang di turnamen nasional harus memberi dampak lebih besar dari menang di latih tanding klub.

```
TIER SYSTEM
═══════════

┌────────┬────────────────────────────────┬────────────┬───────────┐
│  Tier  │  Jenis Event                   │ Multiplier │ Min.      │
│        │                                │            │ Peserta   │
├────────┼────────────────────────────────┼────────────┼───────────┤
│  S     │ PERPANI Nasional / PON /       │   1.5      │   30+     │
│        │ SEA Games Qualifier            │            │           │
├────────┼────────────────────────────────┼────────────┼───────────┤
│  A     │ Kejurda / Regional Championship│   1.2      │   20+     │
│        │ / ManahPro National Series     │            │           │
├────────┼────────────────────────────────┼────────────┼───────────┤
│  B     │ Turnamen Kota / Club Open /    │   1.0      │   15+     │
│        │ ManahPro City Challenge        │            │           │
├────────┼────────────────────────────────┼────────────┼───────────┤
│  C     │ Latih Tanding Antar Klub /     │   0.7      │   10+     │
│        │ Fun Tournament                 │            │           │
├────────┼────────────────────────────────┼────────────┼───────────┤
│  D     │ Internal Club Match /          │   0.4      │    5+     │
│        │ Friendly Match                 │            │           │
└────────┴────────────────────────────────┴────────────┴───────────┘
```

### 7.2 Dynamic K-Factor

K-factor menentukan seberapa besar perubahan rating setelah satu event. Di ManahPro, K-factor bersifat **dinamis**:

```
K_effective = K_base × T_mult × P_mult × F_mult

Di mana:
  K_base  = Base K-factor berdasarkan rating history pemanah
  T_mult  = Tournament tier multiplier (tabel di atas)
  P_mult  = Participation multiplier (berdasarkan jumlah peserta)
  F_mult  = Format multiplier (berdasarkan jumlah anak panah/ends)
```

**K_base berdasarkan pengalaman:**

| Kondisi | K_base | Alasan |
|---------|--------|--------|
| Pemanah baru (< 5 event rated) | 40 | Rating perlu konvergen cepat |
| Pemanah developing (5-20 event) | 32 | Masih belajar, rating bergerak |
| Pemanah established (20-50 event) | 24 | Rating mulai stabil |
| Pemanah veteran (50+ event) | 16 | Rating sudah sangat stabil |

**P_mult (Participation Multiplier):**

```
P_mult = min(1.3, 0.7 + 0.02 × num_participants)

  5 peserta  → 0.80
  15 peserta → 1.00
  30 peserta → 1.30
  50+ peserta → 1.30 (capped)
```

**F_mult (Format Multiplier):**

| Format | F_mult | Alasan |
|--------|--------|--------|
| Full Ranking Round (72 arrows) | 1.0 | Baseline — data paling banyak |
| Half Round (36 arrows) | 0.7 | Setengah data |
| Match Play (set system) | 0.9 | Head-to-head, tapi fewer arrows |
| Elimination (bracket) | 0.8 | Win/loss only, no score granularity |
| Field Archery | 0.9 | Banyak anak panah tapi varied distance |

---

## 8. Activity Decay & Rating Confidence

### 8.1 Mengapa Perlu Decay?

Tanpa decay, pemanah yang berhenti bertanding akan mempertahankan rating tinggi selamanya. Ini tidak fair karena:

1. Skill bisa menurun tanpa latihan
2. "Pemain hantu" menghalangi slot ranking aktif
3. Field strength berubah seiring waktu

### 8.2 Rating Deviation Inflation (Bukan Rating Decay)

Alih-alih menurunkan rating (μ) secara langsung, kita **menaikkan uncertainty (φ)**:

```
SETIAP RATING PERIOD (1 bulan) TANPA BERTANDING:

φ_new = √(φ_old² + c²)

Di mana:
  c = decay constant = 15 (per bulan tanpa bertanding)

Contoh:
  Bulan 0 (baru bertanding): φ = 50   → Display Rating = 1800 - 2×50 = 1700
  Bulan 3 (3 bulan idle):    φ = 65   → Display Rating = 1800 - 2×65 = 1670
  Bulan 6 (6 bulan idle):    φ = 102  → Display Rating = 1800 - 2×102 = 1596
  Bulan 12 (1 tahun idle):   φ = 190  → Display Rating = 1800 - 2×190 = 1420
```

**Efeknya:**
- μ (internal rating) **tidak berubah** — saat kembali bertanding, rating bisa kembali cepat
- φ meningkat → Display Rating turun → ranking turun
- Ketika kembali bertanding, φ turun lagi → tapi butuh beberapa event untuk "re-establish"

### 8.3 Maximum Rating Deviation Cap

```
φ tidak boleh melebihi φ_max = 350 (sama dengan pemain baru)

Jika pemanah idle > 2 tahun → φ di-cap di 350
→ Efektif kembali ke "unrated" tapi μ tetap tersimpan sebagai seed
```

### 8.4 Rating Period Definition

```
RATING PERIODS
══════════════

1 Rating Period = 1 bulan kalender

Event dalam 1 period digabung → 1x batch update
Jika ada 3 event dalam 1 bulan → semua dihitung bersamaan

Alasan:
├── Panahan punya frekuensi event yang rendah (1-4 event/bulan max)
├── Batch update menghindari urutan event mempengaruhi hasil
└── Lebih stabil daripada update per-event
```

---

## 9. Worked Examples (Contoh Perhitungan)

### 9.1 Contoh: Turnamen dengan 5 Pemanah

**Setup Event:**
- Tier B (Turnamen Kota), Recurve 70m, 72 arrows
- 5 peserta

**Data Pemanah:**

| Pemanah | μ | φ | σ | Skor (of 720) | NPS |
|---------|------|------|------|------|------|
| Andi | 1700 | 60 | 0.05 | 665 | 923.6 |
| Budi | 1600 | 80 | 0.06 | 650 | 902.8 |
| Citra | 1550 | 100 | 0.06 | 640 | 888.9 |
| Deni | 1500 | 200 | 0.07 | 670 | 930.6 |
| Eka | 1450 | 150 | 0.06 | 630 | 875.0 |

**Step 1: Score Differential (S_ij) — Andi vs semua**

```
Andi vs Budi:
  S = 1/(1 + e^(-0.01 × (923.6-902.8))) = 1/(1 + e^(-0.208)) = 0.5518
  (Andi menang tipis → slight win)

Andi vs Citra:
  S = 1/(1 + e^(-0.01 × (923.6-888.9))) = 1/(1 + e^(-0.347)) = 0.5859
  (Andi menang cukup jelas)

Andi vs Deni:
  S = 1/(1 + e^(-0.01 × (923.6-930.6))) = 1/(1 + e^(0.07)) = 0.4825
  (Andi KALAH dari Deni! Deni yang rating-nya lebih rendah justru menang)

Andi vs Eka:
  S = 1/(1 + e^(-0.01 × (923.6-875.0))) = 1/(1 + e^(-0.486)) = 0.6191
  (Andi menang)
```

**Step 2: Expected Score (E) — Andi vs semua**

```
Andi vs Budi: (berdasarkan rating)
  g(φ_Budi) = 1/√(1 + 3×(80/173.7)²/π²) = 0.9725
  E = 1/(1 + e^(-0.9725 × ((1700-1500)/173.7 - (1600-1500)/173.7)))
  E = 1/(1 + e^(-0.9725 × 0.5757)) = 0.6346
  (Berdasarkan rating, Andi DIHARAPKAN menang 63.5%)

Andi vs Deni: (berdasarkan rating)
  g(φ_Deni) = 1/√(1 + 3×(200/173.7)²/π²) = 0.8541
  E = 1/(1 + e^(-0.8541 × ((1700-1500)/173.7 - (1500-1500)/173.7)))
  E = 1/(1 + e^(-0.8541 × 1.1513)) = 0.7266
  (Andi DIHARAPKAN menang 72.7% atas Deni)
```

**Step 3: Rating Change Direction**

```
Andi vs Deni:
  S_ij = 0.4825 (actual — Andi kalah)
  E_ij = 0.7266 (expected — Andi diharapkan menang)
  
  Kontribusi ke Δ: g(φ_Deni) × (S - E) = 0.8541 × (0.4825 - 0.7266)
                                        = 0.8541 × (-0.2441)
                                        = -0.2085
  
  → Andi KEHILANGAN rating karena kalah dari pemanah yang "seharusnya" ia kalahkan!
  → Deni MENDAPATKAN banyak rating karena mengalahkan pemanah yang "seharusnya" lebih kuat!
```

**Hasil Akhir (Setelah Full Glicko-2 Calculation):**

| Pemanah | μ Lama | μ Baru | Δ | φ Lama | φ Baru | Interpretasi |
|---------|--------|--------|---|--------|--------|-------------|
| **Deni** | 1500 | 1548 | **+48** | 200 | 160 | Upset win! Rating naik banyak, uncertainty turun |
| **Andi** | 1700 | 1688 | **-12** | 60 | 58 | Kalah dari underdog, tapi φ kecil jadi Δ terbatas |
| **Budi** | 1600 | 1595 | **-5** | 80 | 75 | Perform sesuai ekspektasi, sedikit di bawah |
| **Citra** | 1550 | 1543 | **-7** | 100 | 90 | Perform di bawah potensi |
| **Eka** | 1450 | 1444 | **-6** | 150 | 130 | Sesuai ekspektasi (expected to lose) |

> **Key Insight**: Deni mendapat +48 poin karena dia melakukan "upset" — mengalahkan pemanah-pemanah yang rating-nya jauh lebih tinggi. Rating uncertainty-nya (φ) juga turun drastis dari 200 ke 160, artinya sistem sekarang lebih percaya dengan kemampuannya yang sebenarnya.

### 9.2 Contoh: Efek Tournament Tier

Jika event yang sama di-upgrade ke Tier A (Kejurda):

```
T_mult berubah dari 1.0 (Tier B) ke 1.2 (Tier A)

Dampak ke Deni:
  Tier B: Δ = +48
  Tier A: Δ = +48 × 1.2 = +57.6 ≈ +58

Dampak ke Andi:
  Tier B: Δ = -12
  Tier A: Δ = -12 × 1.2 = -14.4 ≈ -14
```

### 9.3 Contoh: Pemanah Baru Pertama Kali

```
Situasi: Fitri baru pertama kali ikut event rated
  μ = 1500, φ = 350, σ = 0.06
  
Event Tier B, 20 peserta, dia finish #5

Karena φ sangat tinggi (350):
  - K_base = 40 (pemanah baru)
  - Rating change akan BESAR (bisa +100 sampai +200)
  - φ akan turun drastis (mungkin ke 200-250)
  - Setelah 3-5 event, rating akan mulai stabil
  
Expected trajectory pemanah baru yang skilled:
  Event 1: μ = 1500 → 1650, φ = 350 → 230
  Event 2: μ = 1650 → 1720, φ = 230 → 170
  Event 3: μ = 1720 → 1750, φ = 170 → 130
  Event 4: μ = 1750 → 1760, φ = 130 → 100
  Event 5: μ = 1760 → 1765, φ = 100 → 85
  (Konvergen ke "true rating" sekitar 1750-1770)
```

---

## 10. Anti-Gaming & Fairness Mechanisms

### 10.1 Potensi Eksploitasi & Pencegahan

```
EXPLOIT #1: "Sandbagging" — Sengaja kalah di event kecil untuk turunkan
             rating, lalu menang besar di event besar
             
PENCEGAHAN:
├── Volatility σ akan meningkat jika performa sangat tidak konsisten
├── σ tinggi → perubahan rating per event mengecil
├── Sistem mendeteksi pola: "consistently bad then suddenly good"
└── Flag untuk review manual jika σ > threshold

─────────────────────────────────────────────────────────────────

EXPLOIT #2: "Cherry Picking" — Hanya ikut event dengan lawan lemah

PENCEGAHAN:
├── P_mult rendah untuk event dengan sedikit peserta
├── Strength of field factor: event dengan average rating rendah
│   memberikan lebih sedikit poin
└── Rating confidence (φ) tidak turun jika lawan semuanya lemah

─────────────────────────────────────────────────────────────────

EXPLOIT #3: "Account Reset" — Buat akun baru untuk dapatkan φ tinggi
             (inflated K-factor)

PENCEGAHAN:
├── Verifikasi identitas (KTP/kartu PERPANI)
├── Satu orang = satu akun (phone number + KTP verification)
└── Suspicious account detection

─────────────────────────────────────────────────────────────────

EXPLOIT #4: "Collusion" — Beberapa pemanah bekerja sama untuk
             manipulasi skor

PENCEGAHAN:
├── Statistical anomaly detection pada skor
├── Juri/official tetap mengawasi secara fisik
├── Report system dari peserta lain
└── Minimum participant threshold per event tier
```

### 10.2 Strength of Field Adjustment

```
SoF (Strength of Field) = Average μ dari semua peserta di event

SoF_factor:
  Jika SoF > 1600 (field kuat):    factor = 1.1
  Jika SoF = 1400-1600 (normal):   factor = 1.0
  Jika SoF < 1400 (field lemah):   factor = 0.8
  
Rating change disesuaikan:
  Δ_final = Δ_calculated × SoF_factor
```

### 10.3 Minimum Events untuk Ranked Status

```
RANKING STATUS
══════════════

Provisional (< 3 events):
├── Rating ditampilkan dengan label "Provisional"
├── Tidak masuk ranking list resmi
└── φ masih terlalu tinggi untuk display rating yang meaningful

Ranked (3-10 events):
├── Masuk ranking list
├── Eligible untuk podium digital
└── Masih mendapat K_base yang lebih tinggi

Established (10+ events):
├── Full ranking privileges
├── Eligible untuk national ranking list
└── K_base stabil
```

---

## 11. Implementation Architecture

### 11.1 Data Model

```
┌──────────────────────────────────────────────────────────┐
│                      RATING TABLE                        │
├──────────────────────────────────────────────────────────┤
│  archer_id       : String (FK → User)                   │
│  division        : Enum (recurve, compound, barebow...)  │
│  bow_class       : Enum (olympic, traditional, sunnah)   │
│  age_group       : Enum (cadet, junior, senior, master)  │
│  gender          : Enum (male, female)                   │
│  mu              : Float (internal rating)               │
│  phi             : Float (rating deviation)              │
│  sigma           : Float (volatility)                    │
│  display_rating  : Float (μ - 2φ, computed)              │
│  events_count    : Int (total rated events)              │
│  last_event_date : DateTime                              │
│  status          : Enum (provisional, ranked, established)│
│  created_at      : DateTime                              │
│  updated_at      : DateTime                              │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│                    RATING HISTORY TABLE                   │
├──────────────────────────────────────────────────────────┤
│  id              : String (PK)                           │
│  archer_id       : String (FK → User)                   │
│  division        : String                                │
│  event_id        : String (FK → Event)                  │
│  mu_before       : Float                                 │
│  mu_after        : Float                                 │
│  phi_before      : Float                                 │
│  phi_after       : Float                                 │
│  sigma_before    : Float                                 │
│  sigma_after     : Float                                 │
│  score_achieved  : Int                                   │
│  nps             : Float                                 │
│  placement       : Int                                   │
│  num_participants: Int                                   │
│  event_tier      : Enum (S, A, B, C, D)                 │
│  k_effective     : Float                                 │
│  timestamp       : DateTime                              │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│                  RATED EVENT TABLE                        │
├──────────────────────────────────────────────────────────┤
│  event_id        : String (PK)                           │
│  name            : String                                │
│  tier            : Enum (S, A, B, C, D)                 │
│  format          : Enum (ranking_round, match_play, ...) │
│  division        : String                                │
│  distance        : Int (meters)                          │
│  num_arrows      : Int                                   │
│  max_score       : Int                                   │
│  num_participants: Int                                   │
│  avg_rating      : Float (SoF)                          │
│  date            : DateTime                              │
│  location        : String                                │
│  status          : Enum (upcoming, live, completed, rated)│
│  rated_at        : DateTime                              │
└──────────────────────────────────────────────────────────┘
```

### 11.2 Rating Engine Service

```
┌─────────────────────────────────────────────────────────────┐
│                    RATING ENGINE FLOW                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────┐    ┌───────────┐    ┌──────────────────┐     │
│  │ Event    │    │ Score     │    │ Rating Engine    │     │
│  │ Complete │───►│ Validator │───►│ (Cloud Function) │     │
│  │ Trigger  │    │           │    │                  │     │
│  └──────────┘    └───────────┘    └────────┬─────────┘     │
│                                            │                │
│                                   ┌────────▼─────────┐     │
│                                   │ For each archer:  │     │
│                                   │ 1. Fetch current  │     │
│                                   │    μ, φ, σ        │     │
│                                   │ 2. Compute virtual│     │
│                                   │    pairwise       │     │
│                                   │ 3. Run Glicko-2   │     │
│                                   │ 4. Apply tier &   │     │
│                                   │    K-factor       │     │
│                                   │ 5. Save new       │     │
│                                   │    μ', φ', σ'     │     │
│                                   │ 6. Log history    │     │
│                                   └────────┬─────────┘     │
│                                            │                │
│                                   ┌────────▼─────────┐     │
│                                   │ Update Rankings  │     │
│                                   │ Leaderboard      │     │
│                                   │ + Send Push      │     │
│                                   │   Notifications  │     │
│                                   └──────────────────┘     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 11.3 Monthly Decay Job

```
CRON JOB: Run pada tanggal 1 setiap bulan, 00:00 WIB

FOR each rating WHERE last_event_date < 1 bulan ago:
    months_inactive = months_since(last_event_date)
    phi_new = sqrt(phi^2 + (15 * months_inactive)^2)  -- decay constant c=15
    phi_new = min(phi_new, 350)  -- cap at maximum
    
    display_rating = mu - 2 * phi_new
    
    UPDATE rating SET phi = phi_new, display_rating = display_rating
    
    IF months_inactive >= 12:
        SET status = 'inactive'
        -- Remove from active ranking list but preserve data
```

### 11.4 Technology Stack

```
Rating Engine:
├── Cloud Functions (Firebase/GCP) — serverless computation
├── Firestore — real-time rating storage & leaderboard
├── Cloud Scheduler — monthly decay job
└── BigQuery — analytics & historical trend analysis

Client (Flutter):
├── Rating card widget (display rating, φ, trend)
├── Rating history chart (line graph over time)
├── Leaderboard view (filtered by division, region)
└── Event rating preview ("estimated rating change")

Admin:
├── Event tier assignment
├── Score verification & dispute resolution
├── Manual rating override (with audit trail)
└── Anti-gaming dashboard (anomaly alerts)
```

---

## 12. Perbandingan dengan Sistem Ranking Lain

| Aspek | ManahPro (Modified Glicko-2) | World Archery (Points) | FIDE ELO (Chess) | FIFA (Modified ELO) |
|-------|-----|-----|-----|-----|
| **Basis** | Bayesian inference + score-based | Accumulated points | Pairwise ELO | Modified ELO |
| **Uncertainty Tracking** | ✅ Yes (φ parameter) | ❌ No | ❌ No | ❌ No |
| **Volatility Tracking** | ✅ Yes (σ parameter) | ❌ No | ❌ No | ❌ No |
| **Score Margin** | ✅ Sigmoid-weighted | ✅ Direct score | ❌ Win/Loss only | ✅ Goal-weighted |
| **Opponent Strength** | ✅ Core feature | ❌ Not considered | ✅ Core feature | ✅ Core feature |
| **Activity Decay** | ✅ φ inflation | ⚠️ Time-window only | ❌ None | ✅ Yearly decay |
| **New Player Handling** | ✅ High φ, fast convergence | ❌ Start from zero | ⚠️ Provisional | ❌ Fixed start |
| **Multi-player** | ✅ Virtual pairwise | ✅ Native | ❌ 1v1 only | ❌ Team only |
| **Anti-Gaming** | ✅ σ + SoF + detection | ❌ Minimal | ⚠️ K-factor rules | ❌ Minimal |

---

## 13. Migration Path: Manual ke Digital

### 13.1 Seeding Initial Ratings

Untuk pemanah yang sudah aktif **sebelum ManahPro**, kita perlu "seed" rating awal:

```
SEEDING STRATEGY
════════════════

Tier 1: Known Athletes (data PERPANI tersedia)
├── Ambil data ranking PERPANI terbaru
├── Map ranking ke rating menggunakan:
│     μ = 1500 + (percentile_rank × 500)
│     φ = 150 (moderate uncertainty)
├── Top 10% nasional → μ ≈ 1950-2000
├── Top 25% → μ ≈ 1800-1900
└── Average → μ ≈ 1500-1600

Tier 2: Club-Level Athletes (data klub tersedia)
├── Ambil data skor rata-rata dari klub
├── μ = 1500 + normalized_avg_score × 300
├── φ = 200 (lebih uncertain dari Tier 1)
└── σ = 0.06 (default)

Tier 3: New Users (tidak ada data historis)
├── μ = 1500
├── φ = 350
└── σ = 0.06
```

### 13.2 Calibration Period

```
CALIBRATION PLAN
════════════════

Bulan 1-3: "Silent Rating"
├── Rating dihitung tapi TIDAK ditampilkan ke publik
├── Internal team memvalidasi apakah rating masuk akal
├── Tune parameters (τ, λ, c) berdasarkan data real
└── Gather feedback dari beta testers

Bulan 4-6: "Provisional Display"
├── Rating ditampilkan dengan label "Beta"
├── Leaderboard tersedia tapi dengan disclaimer
├── Collect edge cases dan bugs
└── Fine-tune anti-gaming mechanisms

Bulan 7+: "Official Launch"
├── Rating system goes live
├── Remove "Beta" label
├── Start official ManahPro ranking series
└── Seek PERPANI endorsement / partnership
```

### 13.3 Parameter Tuning Guidelines

```
PARAMETER TUNING
════════════════

τ (tau) — System constant for volatility update
├── Default: 0.5
├── Range: 0.3 - 0.8
├── Higher → rating lebih volatile (berubah cepat)
├── Lower → rating lebih stable
└── Recommended untuk panahan: 0.4 (cenderung stable)

λ (lambda) — Score differential sensitivity
├── Default: 0.01
├── Range: 0.005 - 0.02
├── Higher → perbedaan skor kecil jadi lebih signifikan
├── Lower → hanya perbedaan skor besar yang berefek
└── Recommended: 0.01 (balanced)

c — Decay constant (per bulan)
├── Default: 15
├── Range: 10 - 25
├── Higher → rating turun cepat saat idle
├── Lower → rating turun pelan saat idle
└── Recommended: 15 (moderate — 1 tahun idle ≈ -380 display rating)

K_base range — Base K-factors
├── New player: 40 (fast convergence)
├── Developing: 32
├── Established: 24
├── Veteran: 16 (stable)
└── Recommended: Start with these, tune after 6 months of data
```

---

## Appendix A: Rating Band & Title System

Untuk membuat ranking lebih "tangible" dan engaging, kita assign **title/badge** berdasarkan display rating:

```
RATING BANDS & TITLES
═════════════════════

Display Rating    Title              Badge              Color
──────────────    ─────              ─────              ─────
2200+             Grand Archer       🏆 Diamond Crown    Diamond
2000 - 2199       Master Archer      💎 Diamond          Diamond
1800 - 1999       Expert Archer      🥇 Gold             Gold
1600 - 1799       Advanced Archer    🥈 Silver           Silver
1400 - 1599       Intermediate       🥉 Bronze           Bronze
1200 - 1399       Developing         🎯 Iron             Grey
1000 - 1199       Beginner           🌱 Seedling         Green
< 1000            Novice             🏹 Starter          Default

Catatan:
├── Title berubah otomatis seiring rating berubah
├── "Peak title" juga disimpan (pernah mencapai Gold meskipun sekarang Silver)
├── Seasonal rewards berdasarkan end-of-season rating
└── Title bisa ditampilkan di profil & scorecard yang di-share
```

---

## Appendix B: Contoh Visualisasi di App

### Rating Card (Tampilan di Profil)

```
┌─────────────────────────────────────────┐
│  🏹  ANDI PRATAMA                       │
│  ════════════════                       │
│                                         │
│  Rating: 1712  🥈 Advanced Archer       │
│  ▲ +23 bulan ini                        │
│                                         │
│  ┌─────────────────────────────────┐    │
│  │  📈 Rating History (6 bulan)    │    │
│  │                                 │    │
│  │  1720 ─         ╱──╲           │    │
│  │  1700 ─    ╱───╱    ╲──╱──     │    │
│  │  1680 ─ ──╱                     │    │
│  │  1660 ─╱                        │    │
│  │        Dec  Jan  Feb  Mar  Apr  │    │
│  └─────────────────────────────────┘    │
│                                         │
│  Division: Recurve 70m                  │
│  Events Rated: 24                       │
│  Confidence: ████████████░░ 85%         │
│  Consistency: ███████████░░░ 78%        │
│  National Rank: #247 of 3,412           │
│  Regional Rank: #18 of 289 (Jawa Barat) │
└─────────────────────────────────────────┘
```

### Post-Event Rating Update Notification

```
┌─────────────────────────────────────────┐
│  🏆 Rating Updated!                     │
│  ════════════════                       │
│                                         │
│  Event: Bandung Open Championship       │
│  Tier: A (Regional Championship)        │
│  Your Score: 665 / 720                  │
│  Placement: 3rd of 28                   │
│                                         │
│  Rating Change:                         │
│  ┌─────────────────────────────────┐    │
│  │  1689 ──────────────► 1712      │    │
│  │         ▲ +23 points            │    │
│  └─────────────────────────────────┘    │
│                                         │
│  Key matchups:                          │
│  ✅ Beat Ahmad (1780) → +8.2           │
│  ✅ Beat Rizki (1720) → +5.1           │
│  ❌ Lost to Faris (1850) → -1.3        │
│  ✅ Beat Wahyu (1650) → +2.4           │
│                                         │
│  Confidence: 85% (+3%)                  │
│  New Rank: #247 (▲12 positions)         │
│                                         │
│  [Share to Instagram]  [View Details]   │
└─────────────────────────────────────────┘
```

---

## Appendix C: Glossary

| Istilah | Definisi |
|---------|---------|
| **μ (mu)** | Internal rating — estimasi kekuatan pemanah |
| **φ (phi)** | Rating deviation — ukuran ketidakpastian rating |
| **σ (sigma)** | Rating volatility — ukuran konsistensi performa |
| **Display Rating** | μ - 2φ — rating konservatif yang ditampilkan ke publik |
| **K-factor** | Sensitivitas perubahan rating per event |
| **ELO** | Sistem rating yang diciptakan Arpad Elo untuk catur |
| **Glicko-2** | Pengembangan ELO oleh Mark Glickman dengan uncertainty tracking |
| **NPS** | Normalized Performance Score — skor dinormalisasi ke skala 0-1000 |
| **SoF** | Strength of Field — rata-rata rating peserta event |
| **Rating Period** | Periode waktu untuk batch update (1 bulan) |
| **Sandbagging** | Sengaja kalah untuk menurunkan rating |
| **Decay** | Penurunan display rating akibat inaktivitas |
| **Seeding** | Pemberian rating awal berdasarkan data historis |

---

*Dokumen ini adalah panduan teknis lengkap untuk implementasi sistem rating ManahPro. Formula dan parameter bersifat recommended defaults dan akan di-tune berdasarkan data real setelah calibration period.*

*Last updated: 28 Mei 2026*
*Author: ManahPro Engineering Team*
