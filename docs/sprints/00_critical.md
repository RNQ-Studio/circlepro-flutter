# 🔥 Fase 00: Temuan Kritis — Perbaikan Segera

> Dokumen ini berisi spesifikasi teknis dan instruksi langkah kerja detail untuk menyelesaikan **3 temuan kritis** yang menyebabkan kegagalan build/analisis atau kerentanan keamanan serius.
>
> **Prioritas**: SEGERA — Harus diselesaikan sebelum Sprint 1 dimulai.

---

## Daftar Tugas

- [x] [Tugas 0.1: Perbaiki Compile Error `RadioGroup`](#tugas-01-perbaiki-compile-error-radiogroup)
- [x] [Tugas 0.2: Generate File `AppLocalizations` (L10n)](#tugas-02-generate-file-applocalizations-l10n)
- [x] [Tugas 0.3: Amankan `.gitignore` dari Kebocoran Kredensial](#tugas-03-amankan-gitignore-dari-kebocoran-kredensial)

---

## Tugas 0.1: Perbaiki Compile Error `RadioGroup`

### Deskripsi & Konteks
Widget `RadioGroup` digunakan di layar Settings (`_ThemeTile` dan `_LanguageTile`) pada aplikasi `main`, namun widget ini **tidak terdefinisi** di mana pun di dalam repositori maupun SDK Flutter standar. Akibatnya, `dart analyze` gagal total dan aplikasi `main` tidak dapat dikompilasi.

### Lokasi Berkas
- **Package**: `apps/main`
- **File yang harus diubah**:
  - `apps/main/lib/features/settings/presentation/settings_screen.dart` (baris 70-100 sekitar `_ThemeTile` dan `_LanguageTile`)

### Langkah Eksekusi (Step-by-step)

1. **Buka** file `apps/main/lib/features/settings/presentation/settings_screen.dart`.
2. **Cari** widget `_ThemeTile` (sekitar baris 70).
3. **Hapus** pembungkus (`wrapper`) `RadioGroup<ThemeMode>(...)` dan ganti langsung dengan `Column(...)`.
4. **Tambahkan** properti `groupValue` dan `onChanged` secara langsung ke setiap `RadioListTile<ThemeMode>`:
   ```dart
   class _ThemeTile extends StatelessWidget {
     const _ThemeTile({required this.current, required this.onChanged});
     final ThemeMode current;
     final void Function(ThemeMode) onChanged;

     @override
     Widget build(BuildContext context) {
       final l10n = AppLocalizations.of(context)!;
       return Column(
         children: ThemeMode.values
             .map((mode) => RadioListTile<ThemeMode>(
                   title: Text(switch (mode) {
                     ThemeMode.system => l10n.themeSystem,
                     ThemeMode.light => l10n.themeLight,
                     ThemeMode.dark => l10n.themeDark,
                   }),
                   value: mode,
                   groupValue: current,
                   onChanged: (val) {
                     if (val != null) onChanged(val);
                   },
                 ))
             .toList(),
       );
     }
   }
   ```
5. **Cari** widget `_LanguageTile` (sekitar baris 95).
6. **Lakukan refaktor serupa**: hapus `RadioGroup<String>(...)` dan ganti dengan `Column(...)` yang berisi `RadioListTile<String>` dengan `groupValue` dan `onChanged` langsung:
   ```dart
   class _LanguageTile extends StatelessWidget {
     const _LanguageTile({required this.current, required this.onChanged});
     final Locale current;
     final void Function(Locale) onChanged;

     @override
     Widget build(BuildContext context) {
       final l10n = AppLocalizations.of(context)!;
       return Column(
         children: [
           RadioListTile<String>(
             title: Text(l10n.langIndonesia),
             value: 'id',
             groupValue: current.languageCode,
             onChanged: (val) {
               if (val != null) onChanged(Locale(val));
             },
           ),
           RadioListTile<String>(
             title: Text(l10n.langEnglish),
             value: 'en',
             groupValue: current.languageCode,
             onChanged: (val) {
               if (val != null) onChanged(Locale(val));
             },
           ),
         ],
       );
     }
   }
   ```
7. **Hapus** import `RadioGroup` jika ada baris import khusus (kemungkinan tidak ada karena widget ini memang tidak eksis).
8. **Periksa** juga file `apps/variant/lib/features/settings/presentation/settings_screen.dart` apakah memiliki masalah serupa. Jika ya, lakukan refaktor yang sama.

### Batasan Arsitektur (Architectural Constraints)
- Tidak boleh membuat widget kustom `RadioGroup` baru di `packages/core` hanya demi mempertahankan kode lama — pendekatan yang benar adalah menggunakan `RadioListTile` standar Flutter.
- Jika membuat widget helper, letakkan di `packages/core/lib/src/widgets/` dan ekspor di barrel `core.dart`.

### Cara Verifikasi
```bash
cd apps/main && flutter analyze
cd apps/variant && flutter analyze
```
Pastikan **0 error** terkait `RadioGroup` atau `Undefined name`.

### Estimasi Effort
**S** (< 1 jam) — Refaktor ringan UI, tidak ada perubahan arsitektur.

---

## Tugas 0.2: Generate File `AppLocalizations` (L10n)

### Deskripsi & Konteks
Kelas `AppLocalizations` yang diimpor oleh hampir seluruh layar UI belum di-*generate* secara lokal. Hal ini memicu **37 error analisis statis** bertipe `Target of URI doesn't exist` di seluruh workspace karena file `app_localizations.dart` dan `app_localizations_*.dart` belum terbentuk.

### Lokasi Berkas
- **Package**: `packages/core`
- **Konfigurasi**: `packages/core/l10n.yaml`
- **Folder sumber ARB**: `packages/core/lib/src/l10n/arb/`
- **Folder output generated**: `packages/core/lib/src/l10n/` (file `app_localizations.dart`, `app_localizations_en.dart`, `app_localizations_id.dart`)

### Langkah Eksekusi (Step-by-step)

1. **Verifikasi** keberadaan file konfigurasi `packages/core/l10n.yaml`. Pastikan field `arb-dir`, `output-dir`, dan `output-localization-file` sudah benar.
2. **Verifikasi** file ARB sumber tersedia di `packages/core/lib/src/l10n/arb/`:
   - `app_en.arb`
   - `app_id.arb` (jika tersedia)
3. **Jalankan perintah generate** dari dalam folder `packages/core`:
   ```bash
   cd packages/core
   flutter gen-l10n
   ```
4. **Verifikasi** file output ter-generate di `packages/core/lib/src/l10n/`:
   - `app_localizations.dart`
   - `app_localizations_en.dart`
   - `app_localizations_id.dart`
5. **Tambahkan langkah generate l10n** ke skrip Melos di root `pubspec.yaml` (bagian `melos > scripts`) agar proses ini otomatis saat bootstrap:
   ```yaml
   scripts:
     gen-l10n:
       run: cd packages/core && flutter gen-l10n
       description: Generate localization files
     postbootstrap:
       run: melos run gen-l10n
       description: Auto-generate l10n after bootstrap
   ```
6. **Update `README.md`** di root: tambahkan catatan bahwa setelah `melos bootstrap`, developer harus menjalankan `melos run gen-l10n` (atau otomatiskan via `postbootstrap`).

### Batasan Arsitektur (Architectural Constraints)
- File hasil generate l10n **harus** tetap berada di `packages/core/lib/src/l10n/` sesuai konfigurasi `l10n.yaml`.
- File `.arb` sumber **tidak boleh** dipindahkan ke luar `packages/core`.
- File hasil generate (`app_localizations*.dart`) sebaiknya **ditambahkan ke `.gitignore`** atau **di-commit** ke repositori — pilih salah satu strategi dan dokumentasikan. Rekomendasi: **commit** agar developer baru tidak perlu menjalankan gen-l10n manual.

### Cara Verifikasi
```bash
dart run melos run analyze
```
Pastikan 37 error `Target of URI doesn't exist: 'package:core/src/l10n/app_localizations.dart'` sudah hilang.

### Estimasi Effort
**S** (< 15 menit) — Hanya menjalankan satu perintah CLI dan memverifikasi output.

---

## Tugas 0.3: Amankan `.gitignore` dari Kebocoran Kredensial

### Deskripsi & Konteks
File `.gitignore` di root repositori belum mengecualikan file-file kredensial sensitif seperti `.env`, `google-services.json`, `GoogleService-Info.plist`, dan file keystore signing. Ini merupakan **kerentanan keamanan** jika repositori dipublikasikan ke platform terbuka.

### Lokasi Berkas
- **File yang harus diubah**: Root `.gitignore`

### Langkah Eksekusi (Step-by-step)

1. **Buka** file `.gitignore` di root repositori.
2. **Tambahkan** blok baru di bagian akhir file dengan komentar yang jelas:
   ```gitignore
   # ===== Kredensial & Rahasia =====
   # Environment variables
   .env
   .env.*
   *.env

   # Firebase configuration
   google-services.json
   GoogleService-Info.plist
   firebase_options.dart

   # Signing keys
   *.jks
   *.keystore
   key.properties
   upload-keystore.jks

   # FlutterFire CLI generated
   firebase_app_id_file.json
   ```
3. **Verifikasi** bahwa file-file tersebut belum ter-track oleh Git. Jika sudah ter-track, hapus dari tracking tanpa menghapus file lokal:
   ```bash
   git rm --cached google-services.json 2>/dev/null || true
   git rm --cached GoogleService-Info.plist 2>/dev/null || true
   git rm --cached .env 2>/dev/null || true
   ```
4. **Pastikan** file `key.properties.example` (template placeholder) tetap di-commit sebagai referensi bagi developer baru.

### Batasan Arsitektur (Architectural Constraints)
- Jangan hapus entri `.gitignore` bawaan Flutter yang sudah ada.
- Simpan file-file contoh/template (misalnya `key.properties.example`, `.env.example`) di repositori agar developer baru memiliki referensi.

### Cara Verifikasi
```bash
# Pastikan file sensitif tidak terdeteksi oleh git
git status
# Pastikan .gitignore mengandung entri baru
grep "google-services.json" .gitignore
grep ".env" .gitignore
grep "*.jks" .gitignore
```

### Estimasi Effort
**S** (< 15 menit) — Perubahan teks konfigurasi sederhana.
