# 🎯 Modul 6: Barrel Exports & Localization (L10n)

Selamat! Anda telah sampai di modul terakhir dari panduan belajar Flutter Starter. Di modul ini, kita akan membahas dua detail kecil namun sangat berdampak pada kerapian dan fungsionalitas aplikasi: **Barrel Exports** dan **Sistem Multi-Bahasa (Localization / L10n)**.

---

## 1. Apa itu Barrel Exports?

Pernahkah Anda melihat berkas impor di Flutter yang sangat panjang dan berantakan seperti ini?
```dart
// ❌ SANGAT BERANTAKAN (Banyak baris impor untuk satu fitur)
import 'package:features_shared/src/auth/domain/entities/user.dart';
import 'package:features_shared/src/auth/domain/usecases/login_use_case.dart';
import 'package:features_shared/src/auth/presentation/login_screen.dart';
import 'package:features_shared/src/auth/presentation/auth_state.dart';
```

Untuk mengatasinya, kita menggunakan pola **Barrel Export**. 
Konsepnya sederhana: Kita membuat satu berkas "pintu masuk utama" di root package yang bertugas mengekspor semua file internal penting dari sub-folder `src`.

Di proyek ini, berkas pintu gerbang tersebut berada di:
* [packages/core/lib/core.dart](file:///c:/Users/62822/Documents/Work/flutter/flutter-starter/packages/core/lib/core.dart)
* [packages/features_shared/lib/features_shared.dart](file:///c:/Users/62822/Documents/Work/flutter/flutter-starter/packages/features_shared/lib/features_shared.dart)

Di dalam file barrel tersebut, kita menulis deklarasi ekspor seperti:
```dart
export 'src/auth/domain/entities/user.dart';
export 'src/auth/presentation/login_screen.dart';
```

Berkat adanya barrel export ini, siapapun (termasuk modul aplikasi utama di `apps/main`) cukup menulis **satu baris impor** saja untuk mengakses seluruh fitur tersebut!
```dart
// ✅ SANGAT RAPI (Cukup satu baris impor)
import 'package:features_shared/features_shared.dart';
```

> [!WARNING]
> **Ingat aturan penting ini!**
> Setiap kali Anda membuat berkas baru (misal: UseCase baru, model baru, widget baru) di dalam package, pastikan Anda mendaftarkan ekspor berkas tersebut di file barrel utama (`core.dart` atau `features_shared.dart`) agar bisa dibaca dari luar package. Jika Anda lupa, compiler akan menganggap berkas tersebut bersifat privat dan aplikasi luar tidak akan bisa memanggilnya.

---

## 2. Bagaimana Sistem Multi-Bahasa (Localization / L10n) Bekerja?

Di starter project ini, sistem multibahasa tidak lagi ditulis secara hardcode di dalam widget, melainkan dipusatkan di dalam paket `core` menggunakan modul **l10n** bawaan Flutter (`flutter_localizations`).

### A. Di mana Letak Berkas Terjemahan?
Semua berkas kamus kata bahasa disimpan dalam format `.arb` (Application Resource Bundle) di folder [packages/core/lib/src/l10n](file:///c:/Users/62822/Documents/Work/flutter/flutter-starter/packages/core/lib/src/l10n):
* **`app_id.arb`**: Berisi kamus terjemahan Bahasa Indonesia.
* **`app_en.arb`**: Berisi kamus terjemahan Bahasa Inggris.

Format penulisannya berbentuk key-value JSON seperti:
```json
{
  "login": "Masuk",
  "email": "Surel",
  "password": "Kata Sandi"
}
```

### B. Bagaimana Cara Meng-generate File L10n?
Setiap kali Anda menambah key baru di file `.arb`, Anda harus men-generate file kode Dart-nya agar bisa dipanggil dengan aman (*type-safe*).

Jalankan perintah pintas Melos berikut di terminal Anda:
```bash
dart run melos run l10n
```

### C. Cara Menggunakannya di UI (Widget)
Gunakan ekstensi bawaan `BuildContext` dari core untuk memanggil kata yang sudah diterjemahkan:

```dart
import 'package:core/core.dart'; // Impor core terlebih dahulu

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ✅ Memanggil terjemahan teks "login" secara aman
        Text(context.l10n.login),
        
        // ✅ Memanggil terjemahan teks "password"
        Text(context.l10n.password),
      ],
    );
  }
}
```

Sistem akan secara otomatis mendeteksi bahasa perangkat pengguna saat ini (atau bahasa yang dipilih pengguna di menu pengaturan) dan mengganti teks tersebut secara dinamis tanpa restart aplikasi!

---

## 🎉 Selamat Belajar & Selamat Berkontribusi!

Kini Anda telah menguasai konsep-konsep kunci tingkat enterprise yang ada di starter project ini:
1. **Struktur Monorepo & Melos** yang modular.
2. **Clean Architecture** yang terstandarisasi.
3. **Riverpod Generator** modern untuk manajemen state.
4. **Drift SQLite** untuk database offline yang efisien.
5. **Mason CLI** untuk automasi pembuatan kode boilerplate.
6. **Barrel Exports & L10n** untuk kerapian kode dan dukungan multibahasa.

Jika Anda memiliki pertanyaan lebih lanjut saat bekerja, Anda bisa merujuk ke berkas [README.md](file:///c:/Users/62822/Documents/Work/flutter/flutter-starter/README.md) di root proyek atau bertanya langsung kepada AI Agent yang ramah ini!

*Selamat menulis kode Flutter berkualitas tinggi!* 🚀
