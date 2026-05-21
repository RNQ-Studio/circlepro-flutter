# Sprint 008 — Home Screen (apps/main)

Tujuan: mengganti `HomeScreen` di `apps/main` yang saat ini masih stub menjadi tampilan nyata — berisi header informasi pengguna dan grid 15 menu navigasi dengan ikon dan warna yang beragam.

Acceptance criteria sprint: Home screen di `apps/main` menampilkan header user dan grid Menu 01–15 yang bisa di-scroll; tap menu memunculkan SnackBar "Fitur belum tersedia".

> **Desain keputusan:** Data user di header menggunakan `HomeRepositoryImpl` dengan data hardcoded (fake) untuk keperluan starter. Saat starter ini di-fork menjadi project nyata, implementasi repository diganti untuk membaca dari auth session atau profile API — domain dan presentation layer tidak perlu diubah.

> **Scope:** Hanya `apps/main`. `apps/variant` memiliki home screen-nya sendiri dan tidak diubah di sprint ini.

---

## Arsitektur

Mengikuti pedoman Clean Architecture di ARCHITECTURE.md — fitur eksklusif app ditempatkan di `apps/<app>/lib/features/` dengan tiga lapisan.

```text
apps/main/lib/features/home/
├── data/
│   └── repositories/
│       └── home_repository_impl.dart    ← fake data (diganti saat fork)
├── domain/
│   ├── entities/
│   │   └── user_profile.dart            ← entity UserProfile
│   ├── repositories/
│   │   └── home_repository.dart         ← abstract interface
│   └── usecases/
│       └── get_user_profile_use_case.dart
└── presentation/
    ├── home_provider.dart               ← Riverpod providers
    ├── home_screen.dart                 ← ConsumerWidget utama
    └── widgets/
        ├── home_user_header.dart        ← header avatar + info user
        └── home_menu_grid.dart          ← grid 15 menu
```

---

## Phase 1 — Domain Layer

### Entity: `UserProfile`

```dart
class UserProfile {
  const UserProfile({
    required this.name,
    required this.email,
    required this.gender,
    required this.age,
    required this.city,
  });
  // ...
}
```

### Repository Interface

```dart
abstract interface class HomeRepository {
  Future<UserProfile> getUserProfile();
}
```

### Use Case

```dart
class GetUserProfileUseCase {
  const GetUserProfileUseCase(this._repository);
  final HomeRepository _repository;
  Future<UserProfile> call() => _repository.getUserProfile();
}
```

**Selesai jika:** Tiga file domain terdefinisi tanpa import dari layer lain.

---

## Phase 2 — Data Layer

Buat `HomeRepositoryImpl` yang mengimplementasi `HomeRepository`. Saat ini mengembalikan data hardcoded sebagai fake — ganti dengan API call saat project di-fork.

**Selesai jika:** `HomeRepositoryImpl` mengimplementasi semua method interface.

---

## Phase 3 — Presentation Layer

### Providers (`home_provider.dart`)

Tiga provider berantai:
1. `homeRepositoryProvider` — menyediakan `HomeRepositoryImpl`
2. `getUserProfileUseCaseProvider` — menyediakan use case
3. `userProfileProvider` — `FutureProvider<UserProfile>` yang memanggil use case

### Widget: `HomeUserHeader`

Menerima `UserProfile` dan `onEditTap` sebagai parameter. Menampilkan avatar, nama, email, dan baris info (gender, usia, kota).

### Widget: `HomeMenuGrid`

Grid 4 kolom, 15 item. Setiap item berisi ikon berwarna + label. Tap memunculkan SnackBar.

| # | Label | Icon | Warna |
|---|-------|------|-------|
| 01 | Menu 01 | `Icons.track_changes` | `Colors.purple` |
| 02 | Menu 02 | `Icons.military_tech` | `Colors.deepOrange` |
| 03 | Menu 03 | `Icons.show_chart` | `Colors.teal` |
| 04 | Menu 04 | `Icons.storage` | `Colors.amber` |
| 05 | Menu 05 | `Icons.group_add` | `Colors.green` |
| 06 | Menu 06 | `Icons.person` | `Colors.cyan` |
| 07 | Menu 07 | `Icons.people` | `Color(0xFF00695C)` |
| 08 | Menu 08 | `Icons.bar_chart` | `Colors.deepPurple` |
| 09 | Menu 09 | `Icons.search` | `Colors.teal` |
| 10 | Menu 10 | `Icons.location_on` | `Colors.brown` |
| 11 | Menu 11 | `Icons.lightbulb_outline` | `Colors.amber` |
| 12 | Menu 12 | `Icons.calculate` | `Colors.blueGrey` |
| 13 | Menu 13 | `Icons.timer` | `Colors.red` |
| 14 | Menu 14 | `Icons.feedback_outlined` | `Colors.orange` |
| 15 | Menu 15 | `Icons.star_outline` | `Colors.indigo` |

### `HomeScreen`

`ConsumerWidget` yang membaca `userProfileProvider`. Menampilkan loading indicator, error state, atau `HomeUserHeader` sesuai state async.

**Selesai jika:** Screen merender ketiga state (loading, error, data) dengan benar.

---

## Checklist Acceptance

- [x] Domain layer terdefinisi: `UserProfile`, `HomeRepository`, `GetUserProfileUseCase`
- [x] Data layer terdefinisi: `HomeRepositoryImpl` dengan fake data
- [x] `home_provider.dart` dengan tiga provider berantai
- [x] `HomeUserHeader` menerima `UserProfile`, tampil dengan semua field
- [x] `HomeMenuGrid` tampil: 15 item dengan ikon dan warna sesuai tabel
- [x] `HomeScreen` sebagai `ConsumerWidget`, menangani loading/error/data
- [x] Tap menu → SnackBar "Fitur belum tersedia"
- [x] Tap Edit → SnackBar "Edit profil belum tersedia"
- [x] Seluruh konten bisa di-scroll tanpa overflow
- [x] Tidak ada perubahan di `apps/variant`
