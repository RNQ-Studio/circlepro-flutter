# Sprint 008 — Home Screen (apps/main)

Tujuan: mengganti `HomeScreen` di `apps/main` yang saat ini masih stub menjadi tampilan nyata — berisi header informasi pengguna dan grid 15 menu navigasi dengan ikon dan warna yang beragam.

Acceptance criteria sprint: Home screen di `apps/main` menampilkan header user (data statis/faker) dan grid Menu 01–15 yang bisa di-scroll; tap menu memunculkan SnackBar "Fitur belum tersedia".

> **Desain keputusan:** Data user di header menggunakan nilai hardcoded (fake) untuk keperluan starter. Saat starter ini di-fork menjadi project nyata, data diganti dengan data dari auth session atau profile API. Tidak ada dependency faker eksternal — cukup konstanta di file terpisah agar mudah diganti.

> **Scope:** Hanya `apps/main`. `apps/variant` memiliki home screen-nya sendiri dan tidak diubah di sprint ini.

---

## Arsitektur

```text
apps/main/lib/
└── home/
    ├── home_screen.dart         ← diganti total (widget utama)
    ├── widgets/
    │   ├── home_user_header.dart   ← widget header informasi user
    │   └── home_menu_grid.dart     ← widget grid 15 menu
    └── home_fake_data.dart         ← konstanta data user palsu (diganti saat fork)
```

---

## Phase 1 — Fake User Data

Buat file `apps/main/lib/home/home_fake_data.dart` berisi konstanta yang merepresentasikan data pengguna. File ini tidak membuat class baru — cukup satu `Map<String, String>` atau konstanta top-level yang mudah ditemukan dan diganti.

```dart
// TODO: Ganti dengan data dari auth session / profile API saat project di-fork
const kFakeUserName    = 'Fulan bin Fulanah';
const kFakeUserEmail   = 'fulan@example.com';
const kFakeUserGender  = 'Putra';
const kFakeUserAge     = '32';
const kFakeUserCity    = 'Kota Surabaya';
```

**Selesai jika:** Konstanta terdefinisi dan bisa diimpor dari widget lain.

---

## Phase 2 — Widget: HomeUserHeader

Buat `apps/main/lib/home/widgets/home_user_header.dart`.

Tampilan (dari atas ke bawah):
- Avatar lingkaran besar (gunakan `CircleAvatar` dengan ikon person sebagai placeholder)
- Nama pengguna: `"Hi, $kFakeUserName"` — bold, font besar
- Email
- Baris info: `"$kFakeUserGender | Usia $kFakeUserAge | Domisili di $kFakeUserCity"`
- Tombol Edit (ikon pensil, di pojok kanan atas header) — tap tampilkan SnackBar "Edit profil belum tersedia"

Widget menerima semua data sebagai parameter (tidak langsung membaca konstanta) agar mudah diganti sumber datanya.

**Selesai jika:** Header tampil dengan semua field di atas.

---

## Phase 3 — Widget: HomeMenuGrid

Buat `apps/main/lib/home/widgets/home_menu_grid.dart`.

Grid berisi tepat 15 item — `Menu 01` hingga `Menu 15`. Setiap item terdiri dari:
- Kotak ikon berwarna dengan sudut membulat (`BorderRadius.circular(16)`)
- Label teks di bawah ikon

Layout: `GridView` dengan `crossAxisCount: 4`, `mainAxisSpacing` dan `crossAxisSpacing` yang cukup (misal 12).

### Daftar Menu, Ikon, dan Warna

| # | Label | Icon | Warna |
|---|-------|------|-------|
| 01 | Menu 01 | `Icons.track_changes` | `Colors.purple` |
| 02 | Menu 02 | `Icons.military_tech` | `Colors.deepOrange` |
| 03 | Menu 03 | `Icons.show_chart` | `Colors.teal` |
| 04 | Menu 04 | `Icons.storage` | `Colors.amber` |
| 05 | Menu 05 | `Icons.group_add` | `Colors.green` |
| 06 | Menu 06 | `Icons.person` | `Colors.cyan` |
| 07 | Menu 07 | `Icons.people` | `Colors.teal.shade700` |
| 08 | Menu 08 | `Icons.bar_chart` | `Colors.deepPurple` |
| 09 | Menu 09 | `Icons.search` | `Colors.teal` |
| 10 | Menu 10 | `Icons.location_on` | `Colors.brown` |
| 11 | Menu 11 | `Icons.lightbulb_outline` | `Colors.amber` |
| 12 | Menu 12 | `Icons.calculate` | `Colors.blueGrey` |
| 13 | Menu 13 | `Icons.timer` | `Colors.red` |
| 14 | Menu 14 | `Icons.feedback_outlined` | `Colors.orange` |
| 15 | Menu 15 | `Icons.star_outline` | `Colors.indigo` |

Tap pada item mana pun memunculkan SnackBar: `"Fitur belum tersedia"`.

**Selesai jika:** Grid tampil dengan 15 item, ikon dan warna sesuai tabel, tap memunculkan SnackBar.

---

## Phase 4 — Rakit HomeScreen

Ganti isi `apps/main/lib/home/home_screen.dart` dengan layout:

```
Scaffold
└── CustomScrollView (agar header + grid bisa scroll bersama)
    ├── SliverToBoxAdapter → HomeUserHeader (dengan padding)
    ├── SliverToBoxAdapter → SizedBox (jarak)
    └── SliverPadding → HomeMenuGrid (dibungkus SliverGrid atau SliverToBoxAdapter)
```

Tidak perlu `AppBar` — header user sudah cukup sebagai identitas halaman.

**Selesai jika:** Scroll halaman menggerakkan header dan grid sekaligus; tidak ada overflow di berbagai ukuran layar.

---

## Checklist Acceptance

- [x] `home_fake_data.dart` terdefinisi dengan 5 konstanta user
- [x] `HomeUserHeader` tampil: avatar, nama, email, baris info, tombol Edit
- [x] `HomeMenuGrid` tampil: 15 item dengan ikon dan warna sesuai tabel
- [x] Tap menu → SnackBar "Fitur belum tersedia"
- [x] Tap Edit → SnackBar "Edit profil belum tersedia"
- [x] Seluruh konten bisa di-scroll tanpa overflow
- [x] Tidak ada perubahan di `apps/variant`
