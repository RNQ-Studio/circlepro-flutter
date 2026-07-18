# Individual Scoring Home Design

**Tanggal:** 19 Juli 2026

## Tujuan

Mengubah halaman utama ManahPro dari hub banyak fitur menjadi pintu masuk yang fokus pada satu pekerjaan utama: mencatat scoring individu secara offline-first.

## Batas cakupan

- Perubahan hanya pada halaman utama aplikasi ManahPro dan test terkait.
- Fitur non-scoring, route, data, dan layar lain tetap berada di codebase, tetapi tidak dipromosikan dari halaman utama.
- Alur scoring yang sudah ada tetap dipakai: setup, input skor, ringkasan, riwayat, dan statistik.
- Tidak ada perubahan backend, database, kontrak API, atau package bersama.

## Pendekatan yang dipilih

Beranda memakai pola **action-first scoring**. Satu aksi paling relevan selalu tampil paling dominan:

1. Jika ada sesi `inProgress`, tampilkan sesi tersebut dengan progres panah dan tombol **Lanjutkan scoring**.
2. Jika tidak ada sesi aktif, tampilkan ajakan singkat dan tombol **Mulai scoring**.
3. Di bawah aksi utama, tampilkan dua akses sekunder yang masih berada dalam domain scoring: **Riwayat** dan **Statistik**.
4. Jika sudah ada sesi selesai, tampilkan satu ringkasan **Sesi terakhir** yang dapat dibuka ke detail.

Pendekatan ini dipilih dibanding sekadar memangkas grid karena menghasilkan satu hierarki aksi yang jelas, dan dibanding dashboard analitik penuh karena tetap ringan untuk pengguna baru.

## Struktur layar

### Top bar

- Wordmark/logo ManahPro di kiri.
- Pengguna terautentikasi melihat satu tombol Pengaturan di kanan.
- Pengguna tamu melihat aksi Masuk yang ringkas di kanan.
- Logout tidak lagi menjadi aksi langsung di beranda.

### Intro

- Judul: **Scoring individu**.
- Deskripsi satu kalimat: **Catat setiap anak panah, bahkan saat offline.**
- Tidak ada profil, XP, streak, stories, quote, atau sapaan panjang.

### Aksi utama

- State loading menampilkan skeleton yang mengikuti bentuk kartu akhir.
- State error menampilkan pesan lokal yang tenang dan tombol **Coba lagi**.
- State kosong atau tanpa sesi aktif menampilkan ikon target, copy singkat, dan tombol **Mulai scoring** menuju `ScoringRoutes.setup`.
- State sesi aktif menampilkan format busur, jarak, progres jumlah panah, progress bar, dan tombol **Lanjutkan scoring** menuju `ScoringRoutes.input(session.id)`.
- Bila terdapat beberapa sesi aktif, gunakan sesi terbaru karena daftar repository sudah berurutan terbaru lebih dulu.

### Akses sekunder

- Dua baris aksi sederhana, bukan grid kartu: Riwayat dan Statistik.
- Masing-masing memiliki ikon, label, deskripsi pendek, dan chevron.
- Seluruh baris memiliki touch target minimal 48 dp.

### Sesi terakhir

- Hanya muncul jika ada sesi berstatus `completed`.
- Menampilkan total skor, skor maksimum, jenis busur, jarak, tanggal relatif sederhana, dan status sinkronisasi lewat ikon plus label.
- Tap membuka `ScoringRoutes.summary(session.id)`.
- Tidak menampilkan chart, badge gamifikasi, atau data sosial.

## Data dan state

`HomeScreen` mengonsumsi `sessionsListProvider`, yang sudah bersumber dari repository scoring offline-first. Tidak dibuat provider atau layer data baru.

Derivasi dilakukan secara lokal dan deterministik:

- `activeSession`: sesi pertama dengan status `inProgress`.
- `latestCompletedSession`: sesi pertama dengan status `completed`.

Refresh menginvalidasi `sessionsListProvider`. Error repository tidak membocorkan exception mentah ke copy utama.

## Desain visual dan aksesibilitas

- Gunakan `ManahSpacing`, `ManahRadius`, `ThemeData`, dan semantic colors yang sudah ada.
- Warna aksen tunggal menggunakan primary ManahPro yang sedang aktif di implementasi.
- Hindari gradient, shadow custom, nested card, nilai styling bebas, dan font kecil.
- Layout harus aman pada viewport 360 x 690, text scale 1.3 dan tetap dapat dipakai pada text scale 2.0.
- Semua tombol icon-only memiliki tooltip.
- Light dan dark theme mengikuti semantic colors tanpa branch warna manual di widget.

## Penghapusan dari beranda

- `HomeUserHeader`
- `HomeMenuGrid`
- `HomeQuoteOfTheDay`
- `StoryHeaderListWidget`
- Kode mati `_QuickStartCard`
- Footer versi aplikasi
- Import dan routing callback untuk fitur non-scoring

File fitur lain tidak dihapus hanya karena pintu masuk berandanya hilang. File widget home yang tidak lagi memiliki konsumen dapat dihapus agar tidak meninggalkan dead code; provider profil lama dipertahankan sementara karena masih direferensikan oleh widget stories di luar perubahan utama.

## Testing

Widget test halaman utama harus membuktikan:

- hanya surface scoring yang ditampilkan dan sembilan menu lama tidak muncul;
- tanpa sesi, tombol Mulai scoring membuka setup;
- dengan sesi aktif, progress dan tombol Lanjutkan scoring membuka input sesi yang benar;
- sesi selesai terbaru tampil dan membuka ringkasan;
- Riwayat dan Statistik membuka route yang benar;
- state error menyediakan Coba lagi;
- viewport kompak 360 x 690 dengan text scale 1.3 tidak menghasilkan exception pada light dan dark theme.

Test ditulis dan dijalankan gagal sebelum implementasi, lalu dijalankan kembali setelah perubahan.

## Acceptance criteria

1. Beranda hanya berfokus pada scoring individu.
2. Satu CTA utama selalu jelas dan sesuai state sesi lokal.
3. Pengguna dapat masuk ke setup, melanjutkan sesi, membuka riwayat, statistik, dan hasil terakhir.
4. Beranda tetap berguna tanpa koneksi karena memakai sumber data lokal scoring.
5. Tidak ada route atau fitur non-scoring yang dihapus dari aplikasi.
6. Tidak ada issue analyzer baru, overflow, atau regresi widget test.
