# Redesign Create Sesi Scoring Individu

## Tujuan

Membuat proses menyiapkan sesi scoring individu terasa cepat, tegas, dan
premium tanpa mengubah kontrak offline-first, model sesi, atau route yang sudah
dipakai. Arah visualnya adalah **precision archery**: deep forest, graphite
dingin, brass secukupnya, garis tegas, radius terkendali, tanpa gradient,
glassmorphism, atau shadow berat.

## Masalah Saat Ini

- Semua opsi ditampilkan sebagai rangkaian label, chip, dan stepper panjang
  tanpa pengelompokan keputusan yang jelas.
- Preset ronde bersaing dengan pengaturan manual sehingga layar terasa padat.
- Ringkasan sesi baru muncul di bagian bawah dan CTA ikut tenggelam dalam
  scroll.
- Loading, empty, dan error target face masih generik; error membocorkan teks
  exception.
- Palet royal blue, amber, putih murni, dan permukaan abu-abu netral terasa
  kurang menyatu dengan identitas panahan ManahPro.
- Tombol kembali masih berupa ikon AppBar standar dan tidak memiliki identitas
  visual yang konsisten di halaman scoring.

## Pendekatan yang Dipilih

### Alternatif yang Dipertimbangkan

1. **Wizard tiga langkah.** Hierarki sangat jelas, tetapi menambah tap dan
   memperlambat pengguna yang rutin membuat sesi.
2. **Composer satu layar dengan progressive disclosure.** Keputusan inti tetap
   terlihat, preset dipindahkan ke bottom sheet, format manual tetap cepat,
   dan ringkasan selalu tersedia. Ini yang dipilih.
3. **Template-only quick start.** Paling cepat, tetapi terlalu membatasi format
   tradisional dan sesi latihan non-standar.

### Struktur Layar

1. App bar ringkas dengan tombol kembali berbingkai dan judul `Sesi baru`.
2. Header editorial kecil: `Scoring individu`, `Siapkan sesi`, dan penjelasan
   bahwa pengaturan terakhir tersimpan di perangkat.
3. Bagian `Busur`: kategori modern/tradisional, kelas busur, serta equipment
   opsional bila tersedia.
4. Bagian `Format latihan`: pemilih preset yang membuka modal bottom sheet,
   jarak, lingkungan, jumlah rambahan, panah per rambahan, dan rambahan
   percobaan.
5. Bagian `Target`: satu selector jelas dengan preview target dan status
   loading/empty/error/data lengkap.
6. Panel bawah tetap yang merangkum kelas busur, jarak, total panah dihitung,
   panah percobaan, serta CTA `Mulai sesi`.

Preset adalah akselerator, bukan mode terpisah. Memilih preset mengisi jarak,
lingkungan, jumlah rambahan, jumlah panah, sighter, dan target yang cocok.
Mengubah salah satu nilai manual melepaskan label preset tanpa mengubah
kontrak sesi.

## Sistem Warna

Tema app-level ManahPro diganti, tanpa menyentuh `packages/core`:

- Primary deep forest untuk tindakan utama dan fokus.
- Cool graphite untuk teks serta outline.
- Off-white kehijauan untuk background dan surface light, bukan putih murni.
- Forest-black dan green graphite untuk dark mode, bukan hitam murni.
- Brass hanya sebagai secondary/domain accent; warna target dan score tetap
  mengikuti makna olahraga.
- Semua widget membaca semantic `ColorScheme`, bukan branching light/dark.

Palet harus memenuhi rasio kontras minimal 4.5:1 untuk teks tombol utama pada
light dan dark theme. Uji tema menghitung rasio luminance secara eksplisit.

## Tombol Kembali

`ManahBackButton` menjadi komponen app-level di
`apps/manahpro/lib/shared/widgets/`:

- Hit area minimal 48x48 dp.
- Ikon chevron kiri 24 dp di dalam rounded rectangle radius 12.
- Background `surfaceContainerHigh`, border `outlineVariant`, dan foreground
  `onSurface`.
- Tooltip default `Kembali`; callback opsional untuk halaman seperti summary
  yang menutup ke home.
- Dipakai oleh seluruh halaman di fitur scoring: setup, target selector, score
  input termasuk error state, summary, preview scorecard, statistik, riwayat,
  dan setup busur.

Close pada summary tetap memakai ikon close dan tooltip `Tutup`, tetapi memakai
bahasa surface/border yang sama melalui komponen navigation button bersama.

## State dan Error Handling

- Target face loading menggunakan skeleton yang meniru selector final.
- Empty menjelaskan bahwa daftar target belum tersedia dan menawarkan retry.
- Error memakai kalimat manusiawi tanpa exception serta tombol `Coba lagi` yang
  memanggil `refreshTargetFaces` dan invalidasi provider.
- Data cache tetap ditampilkan dari stream lokal saat refresh jaringan gagal,
  sehingga flow tetap offline-first.
- Submit menampilkan progress kecil di dalam CTA. Exception pembuatan sesi
  berubah menjadi pesan inline `Sesi belum berhasil dibuat. Coba lagi.` dan
  input pengguna tetap utuh.
- Subscription yang belum termuat tidak memblokir scoring offline. Status gated
  yang sudah diketahui mengarahkan ke paywall seperti perilaku lama.

## Arsitektur dan Batas Scope

- Tidak ada perubahan backend, database, route, provider publik, atau payload
  `ScoringRepository.startSession`.
- `scoring_setup_screen.dart` tetap mengendalikan state form dan orchestration.
- Subtree visual yang besar dipisah menjadi widget privat atau file komponen
  terfokus agar layar tidak terus membesar.
- `ManahTheme` dan `ManahColors` adalah satu-satunya sumber warna baru.
- Tidak menambah dependency dan tidak mengubah `packages/core` atau
  `apps/variant`.
- Redesign back button dibatasi pada seluruh alur scoring individu agar tidak
  berbenturan dengan perubahan fitur lain yang sedang ada di worktree.

## Acceptance Criteria

1. Create sesi tampil sebagai composer satu layar yang terstruktur dan tidak
   lagi berupa daftar kontrol tanpa hierarki.
2. Preset ronde dipilih melalui bottom sheet dan tetap mengisi semua nilai
   domain yang sama seperti sebelumnya.
3. Ringkasan dan CTA tetap terlihat, memberi alasan saat belum dapat dimulai,
   serta mempertahankan state loading/gated/error.
4. Semua halaman scoring memakai navigation button baru dengan semantic dan
   touch target yang benar.
5. Tema ManahPro memakai palet forest/graphite baru pada light dan dark mode,
   tanpa warna inline baru di widget.
6. Layar tetap dapat digunakan pada 360x690, text scale 1.3 dan 2.0, light dan
   dark theme, tanpa overflow.
7. Widget tests membuktikan render, preset selection, target loading/error retry,
   start-session navigation, back navigation, dan kontras tema.
8. Analyze tidak menambah issue di atas baseline 101 info; seluruh test, build
   APK release, install, launch, dan push `main` berhasil.

## Asumsi yang Dikunci

- Bahasa UI tetap Indonesia mengikuti implementasi app ManahPro saat ini.
- Target face tetap wajib sebelum sesi dimulai, sama seperti perilaku lama.
- Pengaturan terakhir tetap disimpan dengan key SharedPreferences yang sama.
- Perubahan warna berlaku global pada app ManahPro karena user meminta tema
  diganti, tetapi komponen `core` dan app variant tidak ikut berubah.
