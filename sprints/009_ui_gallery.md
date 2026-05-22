# Sprint 009 — UI Component Gallery (apps/main)

Tujuan: menambahkan **UI Component Gallery** ke `apps/main` — sebuah mini showcase interaktif berisi 8 layar demo yang memperlihatkan komponen UI Flutter beserta animasi, form, navigasi, feedback, loading state, dan utilitas umum. Gallery ini bisa dijadikan referensi visual saat mem-fork starter untuk project baru.

Acceptance criteria sprint: Menu "UI Gallery" muncul di Home screen `apps/main`; tap membuka halaman daftar 8 kategori; setiap kategori membuka layar demo yang fully interactive tanpa error.

> **Desain keputusan:** Gallery tidak menggunakan state management Riverpod — seluruh state UI lokal dikelola dengan `StatefulWidget` + `setState`. Keputusan ini sengaja dibuat agar kode demo lebih mudah dibaca oleh developer yang baru mengenal codebase, tanpa dependensi provider chain.

> **Scope:** Hanya `apps/main`. Tidak ada dependency baru yang ditambahkan ke `pubspec.yaml` — seluruh fitur dibangun dari widget dan library yang sudah ada di workspace (termasuk manual shimmer via `ShaderMask` menggantikan shimmer package).

---

## Arsitektur

Gallery ditempatkan sebagai fitur eksklusif `apps/main` mengikuti konvensi folder yang sudah ada.

```text
apps/main/lib/features/ui_gallery/
├── data/
│   └── dummy_data.dart              ← data statis: nama, roles, FAQ, token, dll
├── widgets/
│   ├── section_header.dart          ← header seksi dengan judul + subtitle opsional
│   ├── demo_card.dart               ← card wrapper untuk setiap demo komponen
│   └── gallery_menu_card.dart       ← card item di grid home gallery
└── screens/
    ├── ui_gallery_home_screen.dart  ← entry point: grid 2 kolom, 8 menu
    ├── dialog_popup_screen.dart     ← Dialog, BottomSheet, SnackBar
    ├── form_input_screen.dart       ← TextField, DatePicker, Checkbox, Switch, Slider
    ├── cards_list_screen.dart       ← Card variants, Dismissible list, ReorderableListView
    ├── navigation_tab_screen.dart   ← TabBar, Stepper, Drawer, BottomNavigationBar
    ├── loading_empty_screen.dart    ← Shimmer, Progress, Empty state, Pull-to-refresh
    ├── animation_screen.dart        ← Hero, Page transition, AnimatedList, Staggered
    ├── feedback_screen.dart         ← Star rating, Like button, Reaction picker, OTP input
    └── utilities_screen.dart        ← Clipboard, Search highlight, Color picker, Tooltip
```

Dua file existing yang dimodifikasi:

```text
apps/main/lib/router/app_router.dart          ← tambah route /ui-gallery
apps/main/lib/features/home/presentation/
    home_screen.dart                          ← tap "UI Gallery" push ke /ui-gallery
    widgets/home_menu_grid.dart               ← tambah item UI Gallery di posisi pertama
```

---

## Phase 1 — Shared Data & Widgets

### `DummyData` (`data/dummy_data.dart`)

Abstract class dengan static const lists yang dipakai oleh semua layar demo:

```dart
abstract class DummyData {
  static const List<String> names = [...];       // 8 nama developer fiktif
  static const List<String> roles = [...];       // 8 role (Frontend, Backend, dll)
  static const List<String> techStacks = [...];  // 6 opsi tech stack
  static const List<String> faqs = [...];        // 5 pertanyaan FAQ
  static const List<String> faqAnswers = [...];  // 5 jawaban FAQ
  static const List<String> searchItems = [...]; // 10 item untuk demo search
  static const List<String> comments = [...];    // 6 komentar dummy
  static const List<String> tokens = [...];      // 6 token design (Primary, Secondary, dll)
  static const List<String> tokenLabels = [...]; // label warna untuk token
}
```

### Widget: `SectionHeader`

```dart
SectionHeader(title: 'Basic Dialogs', subtitle: 'Tap tombol untuk membuka dialog')
```

Menampilkan judul berwarna `AppColors.primary`, subtitle opsional, dan trailing widget opsional.

### Widget: `DemoCard`

```dart
DemoCard(title: 'Alert Dialog', subtitle: 'Dialog standar dengan aksi', child: ...)
DemoCard(title: 'List', noPadding: true, child: ...)
```

Card dengan header (title + subtitle), divider, lalu area konten. Flag `noPadding: true` untuk konten yang butuh full-bleed (list item, dll).

### Widget: `GalleryMenuCard`

Card dengan colored border + icon container + title + subtitle. Dipakai di grid home gallery.

**Selesai jika:** Tiga widget dapat di-import tanpa error dan merender sesuai desain.

---

## Phase 2 — Routing & Home Integration

### Route (`app_router.dart`)

```dart
GoRoute(
  path: '/ui-gallery',
  builder: (context, state) => const UiGalleryHomeScreen(),
)
```

### Home Integration (`home_screen.dart`)

```dart
onMenuTap: (label) {
  if (label == 'UI Gallery') {
    context.push('/ui-gallery');
  } else {
    ScaffoldMessenger.of(context).showSnackBar(...);
  }
},
```

### Home Menu Grid (`home_menu_grid.dart`)

Tambah field `isGallery` pada `_MenuItem`. Item "UI Gallery" ditempatkan di posisi pertama dengan `boxShadow` dan bold label untuk membedakannya dari menu stub lainnya.

**Selesai jika:** Tap "UI Gallery" di Home screen membuka `UiGalleryHomeScreen` tanpa error.

---

## Phase 3 — Gallery Home Screen

`UiGalleryHomeScreen` adalah `StatelessWidget` dengan `GridView.builder` 2 kolom (`childAspectRatio: 1.1`). Navigasi ke masing-masing layar menggunakan `Navigator.push(MaterialPageRoute(...))`.

```dart
static final _menus = [
  (title: 'Dialog & Popup',    subtitle: '...', icon: Icons.chat_bubble_outline,  color: Colors.indigo),
  (title: 'Form & Input',      subtitle: '...', icon: Icons.edit_note,            color: Colors.teal),
  (title: 'Cards & Lists',     subtitle: '...', icon: Icons.dashboard_outlined,   color: Colors.orange),
  (title: 'Navigation & Tab',  subtitle: '...', icon: Icons.tab_outlined,         color: Colors.purple),
  (title: 'Loading & Empty',   subtitle: '...', icon: Icons.hourglass_empty,      color: Colors.blue),
  (title: 'Animation',         subtitle: '...', icon: Icons.animation,            color: Colors.pink),
  (title: 'Feedback & Input',  subtitle: '...', icon: Icons.thumb_up_alt_outlined, color: Colors.green),
  (title: 'Utilities',         subtitle: '...', icon: Icons.build_outlined,       color: Colors.brown),
];
```

**Selesai jika:** Delapan card tampil dalam grid 2 kolom, tap masing-masing membuka layar yang benar.

---

## Phase 4 — Layar Demo (8 Layar)

### 4.1 `DialogPopupScreen`

| Demo | Implementasi |
|------|--------------|
| Alert Dialog | `showDialog` + `AlertDialog` standar |
| Confirm Dialog | Dialog dengan dua tombol aksi (Batal/Konfirmasi) |
| Shake Dialog | `TweenSequence` shake animation via `SingleTickerProviderStateMixin` |
| Countdown Dialog | `Timer.periodic` + `CircularProgressIndicator` sebagai countdown ring |
| Loading Dialog | `barrierDismissible: false`, auto-dismiss via `Timer` setelah 3 detik |
| Bottom Sheet | `showModalBottomSheet` dengan konten scroll |
| Persistent Sheet | `showBottomSheet` dengan tombol close |
| SnackBar (4 varian) | Info / Success / Warning / Error menggunakan `AppColors` |

### 4.2 `FormInputScreen`

| Field | Detail |
|-------|--------|
| Nama | `TextEditingController`, required |
| Password | `obscureText` toggle, `TextEditingController` |
| Email | Validasi real-time via `RegExp` di `onChanged` |
| Tanggal Lahir | `showDatePicker` + `DateFormat('dd MMMM yyyy')` dari package `intl` |
| Catatan | `maxLines: 4`, multiline |
| Tech Stack | `DropdownButton<String>` |
| Tipe Akun | `Radio<String>` (Personal / Business / Developer) |
| Skills | `Map<String, bool>` + `Checkbox` |
| Notifikasi | `Switch` |
| Pengalaman | `Slider` (0–10 tahun) |

Submit: scroll ke field error pertama via `Scrollable.ensureVisible`; sukses menampilkan `AlertDialog` ringkasan data.

### 4.3 `CardsListScreen`

`DefaultTabController` dengan 2 tab:

- **Cards Tab:** 5 varian card (Basic, Outlined, Elevated, Image, Stats). Stats card menggunakan positional tuple `(String, String, IconData, Color)` diakses sebagai `s.$1 s.$2 s.$3 s.$4`.
- **Lists Tab:** `Dismissible` list dengan undo via `SnackBar` action; `ReorderableListView` dengan drag handle.

### 4.4 `NavigationTabScreen`

`DefaultTabController` dengan 4 tab:

- **Tab Bar** — demo `TabBar` + `TabBarView` dengan 4 tab
- **Stepper** — 3-step stepper (Info → Preferensi → Konfirmasi) dengan `controlsBuilder` custom
- **Drawer** — `Scaffold` dengan `Drawer` berisi `UserAccountsDrawerHeader`, nav items, dan item logout berwarna merah
- **Bottom Nav** — `BottomNavigationBar` (Material 2) dan `NavigationBar` (Material 3) ditampilkan berdampingan

### 4.5 `LoadingEmptyScreen`

`DefaultTabController` dengan 3 tab:

- **Loading Tab:**
  - Shimmer manual via `ShaderMask` + `LinearGradient` (tanpa package eksternal)
  - Linear progress: `TweenAnimationBuilder` + `Timer` loop 100ms
  - Circular progress: sama
- **Empty Tab:** 4 varian empty state (data kosong, error, no connection, no permission) masing-masing dengan ikon + pesan + tombol aksi
- **Refresh Tab:** `RefreshIndicator` + `Random` untuk mensimulasikan pull-to-refresh dengan data baru

### 4.6 `AnimationScreen`

| Demo | Implementasi |
|------|--------------|
| Hero | 4 colored box → `_HeroDetailScreen` via `Hero(tag: 'hero-$i')` |
| Page Transition | 3 tipe (Fade, Slide, Scale) via `PageRouteBuilder` |
| AnimatedList | `GlobalKey<AnimatedListState>` + `SizeTransition` + `FadeTransition` |
| Staggered | `TickerProviderStateMixin`, `List<AnimationController>`, stagger via `Future.delayed(Duration(milliseconds: i * 120))` |

### 4.7 `FeedbackScreen`

| Demo | Implementasi |
|------|--------------|
| Star Rating | `onHorizontalDragUpdate` untuk drag rating |
| Like Button | `TweenSequence([1.0→1.4, 1.4→1.0])` scale animation |
| Reaction Picker | 6 `AnimationController` (spring animation per emoji), `TickerProviderStateMixin` |
| OTP Input | 6 `TextEditingController` + `FocusNode`, auto-focus antar box, lebar responsif via `LayoutBuilder`: `((constraints.maxWidth - 80) / 6).clamp(36.0, 48.0)`. PIN benar = "123456". |

### 4.8 `UtilitiesScreen`

| Demo | Implementasi |
|------|--------------|
| Clipboard | `Clipboard.setData(ClipboardData(text: ...))` dari `package:flutter/services.dart` |
| Search & Filter | `RichText` + `TextSpan` untuk highlight teks yang cocok (bold + warna primary) |
| Color Picker | `AnimatedContainer` (scale saat terpilih) + hex display `#${color.value.toRadixString(16).substring(2).toUpperCase()}` |
| Tooltip & Badge | `Tooltip` widget standar + `Badge` Material 3 dengan count |

**Selesai jika:** Semua 8 layar terbuka, seluruh demo interaktif berfungsi, tidak ada overflow atau exception.

---

## Keputusan Teknis

**Shimmer tanpa package:** Menggunakan `ShaderMask` + `LinearGradient` + `AnimationController`. `begin: Alignment(shimmerOffset - 0.5, 0)` digeser setiap frame untuk efek kilap. Alasan: tidak ingin menambah dependency hanya untuk demo.

**TickerProvider selection:** `SingleTickerProviderStateMixin` untuk state class dengan tepat 1 `AnimationController`; `TickerProviderStateMixin` untuk state class dengan lebih dari 1 (Reaction Picker = 6, Staggered = N controllers).

**Dart 3 records:** Menu list di `UiGalleryHomeScreen` menggunakan named records (`title:`, `subtitle:`, `icon:`, `color:`) dan stats card menggunakan positional tuple. Keduanya valid di SDK `>=3.5.0` yang sudah terdefinisi di workspace.

**TextEditingController lifecycle:** Semua controller dideklarasikan sebagai field class, di-dispose di `dispose()`, dan tidak pernah dibuat di dalam `build()` untuk menghindari memory leak.

---

## Checklist Acceptance

- [x] Menu "UI Gallery" tampil di Home screen `apps/main` dengan visual berbeda (shadow + bold)
- [x] Tap "UI Gallery" membuka `UiGalleryHomeScreen` via GoRouter `/ui-gallery`
- [x] Grid 8 menu tampil dalam 2 kolom tanpa overflow
- [x] `DialogPopupScreen` — semua dialog, bottom sheet, dan snackbar berfungsi
- [x] `FormInputScreen` — validasi berjalan, date picker, submit dengan ringkasan
- [x] `CardsListScreen` — 5 varian card, dismissible + undo, reorderable list
- [x] `NavigationTabScreen` — TabBar, Stepper, Drawer, BottomNav semuanya interaktif
- [x] `LoadingEmptyScreen` — shimmer beranimasi, empty state 4 varian, pull-to-refresh
- [x] `AnimationScreen` — Hero transition, page transition 3 tipe, AnimatedList, staggered
- [x] `FeedbackScreen` — star rating via drag, like animation, reaction picker, OTP 6-digit
- [x] `UtilitiesScreen` — clipboard, search highlight, color picker, tooltip/badge
- [x] Tidak ada `pubspec.yaml` yang diubah (zero new dependencies)
- [x] Tidak ada perubahan di `apps/main/lib/main.dart`
- [x] Tidak ada file yang dihapus atau dimodifikasi di luar scope sprint ini
- [x] Tidak ada file yang ditambahkan ke folder `sprints/` selama eksekusi
- [x] Semua `AnimationController` dan `TextEditingController` di-dispose dengan benar
- [x] Tidak ada widget overflow pada layar 360px ke atas
