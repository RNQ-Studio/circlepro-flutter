Kamu adalah senior AI Agent pengembang mobile (Flutter & Dart Expert) sekaligus Senior Auditor & Dokumentator Teknis.

Tugas utama kamu adalah **mensinkronisasikan dan memperbarui dokumen-dokumen review di direktori `docs/review/`** agar selaras dengan kondisi aktual kode proyek saat ini setelah melalui proses iterasi/perbaikan.

### LANGKAH EKSEKUSI:

#### Langkah 1: Diagnosis & Pemindaian Kode Aktual (Scan Existing Project)
Lakukan analisis menyeluruh terhadap codebase saat ini untuk mendeteksi status perbaikan:
1. **Analisis Statis & Kompilasi**: Jalankan `dart run melos run analyze` atau `flutter analyze` untuk memeriksa apakah masih ada error analisis statis.
2. **Pengecekan Bug Kritis**:
   - Periksa apakah widget `RadioGroup` di `apps/main/lib/features/settings/presentation/settings_screen.dart` telah diperbaiki/direfaktor menggunakan standard Flutter atau widget buatan sendiri.
   - Periksa apakah L10n `AppLocalizations` sudah berhasil di-generate dan tidak memicu error import.
3. **Pengecekan Keamanan**: Periksa apakah `.gitignore` di root sudah memperbarui daftar pengecualian untuk kredensial sensitif (`.env`, `google-services.json`, dll.).
4. **Pengecekan Integrasi Fitur**:
   - Periksa apakah paket Firebase (`firebase_core`, `firebase_messaging`, dll.) sudah terpasang riil di pubspec dan kode inisialisasinya ada di proyek.
   - Periksa apakah Database Isar sudah terintegrasi atau masih berupa stub.
   - Periksa apakah provider Riverpod sudah dimigrasikan ke `@riverpod` generator.
5. **Pengecekan Dokumentasi**: Periksa apakah berkas baru seperti `CLAUDE.md` atau `docs/firebase-setup.md` sudah dibuat.

#### Langkah 2: Bandingkan dengan Dokumen Review Lama
Baca dokumen review yang ada saat ini di folder `docs/review/` (dari `00_SUMMARY.md` hingga `07_action_plan.md`). Identifikasi temuan mana saja yang **sudah terselesaikan** dan temuan mana yang **masih tersisa/belum dikerjakan**.

#### Langkah 3: Perbarui Berkas di `docs/review/` secara Presisi
Lakukan pembaruan konten secara langsung pada file-file berikut tanpa merusak format aslinya yang premium:

1. **`docs/review/00_SUMMARY.md` (Paling Krusial)**:
   - **Scorecard**: Naikkan nilai skor (1-10) pada kategori yang sudah membaik (misal: jika bug kompilasi & L10n beres, naikkan *Kesiapan sebagai Starter* dari `5.5` ke nilai yang sesuai seperti `8.5` atau `9.0`). Hitung ulang rata-rata skor keseluruhan.
   - **Gap Dokumentasi vs Implementasi**: Hapus atau ubah status gap yang sudah dijembatani menjadi `[TERATASI]`.
   - **Temuan Kritis**: Tandai temuan kritis yang selesai sebagai `[TERATASI - Selesai]` atau pindahkan ke bagian riwayat perbaikan.
   - **Rekomendasi Utama**: Perbarui rekomendasi teratas untuk fokus pada sisa backlog yang belum dikerjakan.

2. **`docs/review/01_starter_readiness.md` s/d `06_priority_areas.md`**:
   - Perbarui paragraf atau tabel evaluasi pada area yang sudah diperbaiki. Tuliskan catatan kaki atau badge status seperti `[RESOLVED]` pada tiap isu yang sudah tidak lagi ditemukan di kode.

3. **`docs/review/07_action_plan.md` (Action Plan & Roadmap)**:
   - Ubah status pengerjaan pada tabel taktis (Sprint 1, Sprint 2, dll.).
   - Tandai item yang sudah selesai dan kurangi estimasi total sisa effort waktu pengerjaan proyek (misalnya dari semula `3 Minggu Kerja` menjadi sisa waktu aktual yang dibutuhkan untuk menyelesaikan backlog tersisa).

### PRINSIP PEMBARUAN DOKUMENTASI:
- **Jujur dan Objektif**: Nilai scorecard hanya boleh naik jika implementasi kodenya benar-benar ada, lulus analisis statis, dan berfungsi dengan baik.
- **Pertahankan Tone Professional**: Tetap gunakan gaya penulisan *Senior Flutter Architect* yang ramah, taktis, analitis, dan objektif dalam bahasa Indonesia.
- **Gunakan Badge & Label Visual**: Gunakan emoji dan markdown badge (seperti `✅ [Selesai]`, `⚠️ [Dalam Proses]`, atau `❌ [Belum Dikerjakan]`) agar status setiap temuan sangat mudah dipindai oleh pembaca manusia maupun agen AI berikutnya.

Jalankan pemindaian kode sekarang, hitung ulang metrik kelayakan proyek Anda, dan mutakhirkan seluruh dokumen di `docs/review/` agar menjadi cerminan sempurna dari kondisi kode terbaru saat ini!
