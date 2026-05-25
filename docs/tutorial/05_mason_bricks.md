# 🧱 Modul 5: Mason Bricks & Automasi Pembuatan Fitur

Salah satu hambatan terbesar bagi pengembang ketika bekerja dengan arsitektur berskala besar seperti Clean Architecture adalah **kejenuhan menulis kode boilerplate**. 

Untuk membuat satu fitur sederhana seperti "fitur kupon", Anda harus membuat 10+ folder dan berkas kosong, menulis import yang tepat, membuat kerangka class untuk DataSource, Repository, Notifier, Screen, hingga State. Hal ini membuang waktu dan sangat rentan terhadap kesalahan ketik (*typo*).

Di proyek ini, kita memecahkan masalah tersebut dengan **Mason CLI**.

---

## 1. Apa itu Mason?

**Mason** adalah alat pembuat template kode (*code generator*) yang andal untuk Flutter/Dart. Mason menggunakan konsep **Bricks** (cetakan bata) yang dapat kita rakit dan jalankan lewat baris perintah (CLI).

Proyek kita mendefinisikan template modular di folder [bricks/feature](file:///c:/Users/62822/Documents/Work/flutter/flutter-starter/bricks/feature). Cetakan ini sudah dirancang agar menghasilkan berkas Clean Architecture yang 100% pas dengan konvensi proyek ini, termasuk:
* Menggunakan Riverpod generator modern.
* Membuat struktur folder 3-layer (`data`, `domain`, `presentation`).
* Menyediakan nama kelas dinamis berdasarkan input (misal `PaymentScreen`, `PaymentNotifier`).
* Mengatur *relative imports* secara otomatis dan presisi.

---

## 2. Cara Menggunakan Mason di Proyek Ini

Kami telah menyederhanakan pemanggilan Mason melalui integrasi perintah Melos. Anda tidak perlu menginstal Mason secara global di komputer Anda!

### Langkah 1: Jalankan Perintah Pembuatan Fitur
Buka terminal Anda di root folder proyek ini, dan jalankan perintah sakti berikut:
```bash
dart run melos run make-feature
```

### Langkah 2: Isi Pertanyaan Interaktif
Terminal akan menampilkan prompt interaktif:
1. **`What is the feature name?`**
   * Masukkan nama fitur Anda menggunakan huruf kecil (*lowercase*), misalnya: `payment` atau `order_history`.
2. **`Which package should contain this feature?`**
   * Tekan Enter untuk memilih opsi bawaan (`features_shared`), atau arahkan ke `apps/main` jika fitur tersebut khusus hanya untuk aplikasi utama.

### Langkah 3: Saksikan Keajaiban Terjadi!
Hanya dalam 1 detik, Mason akan mencetak struktur folder lengkap di dalam [packages/features_shared/lib/src/payment](file:///c:/Users/62822/Documents/Work/flutter/flutter-starter/packages/features_shared/lib/src/). 

Semua kelas pendukung seperti `PaymentLocalDataSource`, `PaymentRepositoryImpl`, `PaymentUseCase`, `PaymentNotifier`, hingga `PaymentScreen` telah siap digunakan!

---

## 3. Apa yang Harus Dilakukan Setelah Menjalankan Mason?

Setelah file-file dasar terbuat secara otomatis, ada **dua langkah wajib** yang harus Anda lakukan agar kode baru tersebut dapat dikenali dan dikompilasi tanpa error:

### Wajib 1: Jalankan Code Generation (Codegen)
Karena cetakan Mason menyertakan notifier berbasis Riverpod generator, Anda akan melihat garis merah error pada kelas dasar `_$PaymentNotifier` yang belum di-generate.

Jalankan perintah ini di root terminal untuk menghasilkan berkas `.g.dart` yang hilang:
```bash
dart run melos run codegen
```

### Wajib 2: Daftarkan ke Pintu Gerbang (Barrel Export)
Ingat aturan monorepo di Modul 1? Aplikasi luar tidak boleh mengintip folder internal `src/` secara langsung. 

Anda harus mendaftarkan kelas-kelas yang ingin diakses oleh aplikasi luar ke berkas barrel export utama di [packages/features_shared/lib/features_shared.dart](file:///c:/Users/62822/Documents/Work/flutter/flutter-starter/packages/features_shared/lib/features_shared.dart).

Cukup tambahkan baris ekspor di akhir berkas tersebut, misalnya:
```dart
// payment — presentation
export 'src/payment/presentation/payment_screen.dart';
export 'src/payment/presentation/payment_provider.dart';
```

---

## 4. Aturan Wajib AI Agent: Penggunaan Mason

> [!IMPORTANT]
> Proyek ini memiliki aturan ketat untuk seluruh developer maupun **AI Agent** yang ditugaskan bekerja di repositori ini:
> **Setiap kali menambahkan modul/fitur baru, WAJIB menggunakan perintah `mason make feature` (atau `melos run make-feature`).**
> 
> Dilarang keras menulis folder arsitektur secara manual demi menjaga konsistensi kode 100%!

---

Modul terakhir akan menjelaskan mengenai pentingnya gerbang *Barrel Exports* dan bagaimana sistem multi-bahasa (Localization) diatur secara terpusat!

👉 **[Lanjut ke Modul 6: Barrel Exports & L10n](file:///c:/Users/62822/Documents/Work/flutter/flutter-starter/docs/tutorial/06_barrel_exports_l10n.md)**
