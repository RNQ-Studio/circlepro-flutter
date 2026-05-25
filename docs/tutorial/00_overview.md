# 🎓 Panduan Belajar Flutter Starter untuk Pemula

Selamat datang di modul panduan belajar **Flutter Starter**! Proyek ini menggunakan arsitektur modern berskala besar (*enterprise-ready*). Bagi *programmer* pemula atau yang baru transisi dari proyek Flutter skala kecil, arsitektur monorepo, arsitektur Clean Architecture, dan *state management* Riverpod modern dengan generator di proyek ini mungkin terasa asing pada awalnya.

Modul tutorial ini dirancang khusus untuk memandu Anda memahami **konsep-konsep kunci** yang ada di starter project ini agar Anda bisa berkontribusi dengan cepat dan percaya diri.

---

## 🗺️ Peta Jalur Belajar (Curriculum Table)

Kami membagi konsep-konsep tingkat lanjut di proyek ini menjadi beberapa bagian yang mudah dicerna:

| No | Modul Belajar | Deskripsi Konsep | Tingkat Kesulitan |
| :--- | :--- | :--- | :--- |
| 1 | [📦 Monorepo & Melos](file:///c:/Users/62822/Documents/Work/flutter/flutter-starter/docs/tutorial/01_monorepo_melos.md) | Memahami konsep multi-package, konfigurasi Melos, aturan dependensi, serta perbedaan antara *relative imports* vs *barrel exports*. | ⭐⭐ (Mudah) |
| 2 | [🏗️ Clean Architecture](file:///c:/Users/62822/Documents/Work/flutter/flutter-starter/docs/tutorial/02_clean_architecture.md) | Memahami pemisahan tanggung jawab 3-layer (Data, Domain, Presentation), kegunaan *UseCase*, dan hubungan antar layer. | ⭐⭐⭐ (Sedang) |
| 3 | [⚡ Riverpod Generator](file:///c:/Users/62822/Documents/Work/flutter/flutter-starter/docs/tutorial/03_riverpod_generator.md) | Menguasai cara kerja anotasi `@riverpod` modern, *Notifier*, proses auto-generation `.g.dart`, serta kapan harus menggunakan `ref.watch` vs `ref.read`. | ⭐⭐⭐⭐ (Cukup Menantang) |
| 4 | [🗄️ Drift Database & Local Cache](file:///c:/Users/62822/Documents/Work/flutter/flutter-starter/docs/tutorial/04_local_cache_drift.md) | Mengerti implementasi penyimpanan offline SQLite menggunakan Drift, skema tabel, mekanisme cache generik, dan kebijakan *TTL (Time-to-Live)*. | ⭐⭐⭐⭐ (Cukup Menantang) |
| 5 | [🧱 Mason Bricks & Automasi](file:///c:/Users/62822/Documents/Work/flutter/flutter-starter/docs/tutorial/05_mason_bricks.md) | Belajar cara menghemat waktu dengan generator otomatis `mason` untuk membuat fitur baru secara instan dalam 1 detik. | ⭐⭐ (Mudah) |
| 6 | [🎯 Barrel Exports & L10n](file:///c:/Users/62822/Documents/Work/flutter/flutter-starter/docs/tutorial/06_barrel_exports_l10n.md) | Mengerti pentingnya *barrel exports* untuk kebersihan import dan bagaimana sistem multi-bahasa (*localization*) terintegrasi otomatis. | ⭐⭐ (Mudah) |

---

## 💡 Mindset Penting Sebelum Memulai

Sebelum Anda masuk menulis kode, pastikan Anda memahami beberapa prinsip emas proyek ini:

1. **Anti-Manual Boilerplate**: Jangan menulis folder Clean Architecture atau Provider Riverpod secara manual dari nol. Gunakan `mason make feature` dan jalankan `dart run melos run codegen`.
2. **Ketat dengan Aturan Impor**: Kode di folder `packages/core` tidak boleh mengimpor apa pun dari `features_shared` atau `apps`. Ini demi menjaga modularitas dan kebersihan *dependency tree*.
3. **Selalu Jalankan Tes**: Proyek ini memiliki safety net berupa unit & widget test. Sebelum melakukan *push* kode baru, pastikan semua tes lolos dengan perintah `dart run melos run test`.

*Mari mulai perjalanan belajar Anda dengan menekan tautan modul pertama di bawah ini!*

👉 **[Mulai Modul 1: Monorepo & Melos](file:///c:/Users/62822/Documents/Work/flutter/flutter-starter/docs/tutorial/01_monorepo_melos.md)**
