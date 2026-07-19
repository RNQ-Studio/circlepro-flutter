# Individual Scoring Setup Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Redesign create sesi scoring individu menjadi composer cepat dengan tema forest/graphite yang tegas dan navigation button khas di seluruh alur scoring.

**Architecture:** Pertahankan state form, provider Riverpod, route GoRouter, dan kontrak `ScoringRepository` yang ada. Pisahkan navigation control dan subtree composer menjadi widget app-level/feature-level kecil, sementara `ScoringSetupScreen` tetap menjadi orchestration boundary.

**Tech Stack:** Flutter Material 3, Riverpod 3, GoRouter, existing Manah design tokens, flutter_test.

---

### Task 1: Kunci tema forest/graphite dengan regression tests

**Files:**
- Create: `apps/manahpro/test/theme/manah_theme_test.dart`
- Modify: `apps/manahpro/lib/theme/manah_colors.dart`
- Modify: `apps/manahpro/lib/theme/manah_theme.dart`
- Modify: `apps/manahpro/lib/theme/manah_tokens.dart`

- [ ] **Step 1: Write failing palette and contrast tests**

Test harus memeriksa bahwa light/dark scheme memakai primary forest yang sama,
background bukan pure white/black, radius card/button tegas, dan rasio
`primary` terhadap `onPrimary` minimal 4.5.

```dart
double contrast(Color a, Color b) {
  final lighter = max(a.computeLuminance(), b.computeLuminance());
  final darker = min(a.computeLuminance(), b.computeLuminance());
  return (lighter + 0.05) / (darker + 0.05);
}

expect(ManahTheme.light.colorScheme.primary, ManahColors.brand);
expect(ManahTheme.light.scaffoldBackgroundColor, isNot(Colors.white));
expect(contrast(light.primary, light.onPrimary), greaterThanOrEqualTo(4.5));
```

- [ ] **Step 2: Run test and confirm RED**

Run: `flutter test apps/manahpro/test/theme/manah_theme_test.dart`

Expected: gagal karena palette lama masih royal blue/white dan token radius
belum mengikuti desain baru.

- [ ] **Step 3: Implement the new semantic scheme**

Ubah hanya app-level theme. Tetapkan deep forest primary, cool graphite
neutral, off-white green light surfaces, forest-black dark surfaces, semantic
outline/container roles, component themes untuk input, chip, segmented button,
card, divider, dan button.

- [ ] **Step 4: Run theme test and targeted analyze**

Run:

```powershell
flutter test apps/manahpro/test/theme/manah_theme_test.dart
dart analyze apps/manahpro/lib/theme apps/manahpro/test/theme/manah_theme_test.dart
```

Expected: test hijau dan tidak ada issue baru.

- [ ] **Step 5: Commit**

```powershell
git add apps/manahpro/lib/theme apps/manahpro/test/theme/manah_theme_test.dart
git commit -m "feat(theme): sharpen ManahPro forest palette"
```

### Task 2: Buat navigation button bersama dan pakai di semua halaman scoring

**Files:**
- Create: `apps/manahpro/lib/shared/widgets/manah_navigation_button.dart`
- Create: `apps/manahpro/test/shared/manah_navigation_button_test.dart`
- Modify: `apps/manahpro/lib/features/scoring/presentation/screens/scoring_setup_screen.dart`
- Modify: `apps/manahpro/lib/features/scoring/presentation/screens/target_face_selection_screen.dart`
- Modify: `apps/manahpro/lib/features/scoring/presentation/screens/score_input_screen.dart`
- Modify: `apps/manahpro/lib/features/scoring/presentation/screens/session_summary_screen.dart`
- Modify: `apps/manahpro/lib/features/scoring/presentation/screens/scorecard_preview_screen.dart`
- Modify: `apps/manahpro/lib/features/scoring/presentation/screens/progress_dashboard_screen.dart`
- Modify: `apps/manahpro/lib/features/scoring/presentation/screens/history_screen.dart`
- Modify: `apps/manahpro/lib/features/scoring/presentation/screens/bow_setup_screen.dart`

- [ ] **Step 1: Write failing back-navigation and semantics tests**

Pump dua route, tampilkan `ManahBackButton`, lalu verifikasi key, tooltip
`Kembali`, ukuran minimum 48, dan tap mem-pop satu route. Tambahkan variant
`ManahNavigationButton.close` untuk summary dengan tooltip `Tutup`.

- [ ] **Step 2: Run test and confirm RED**

Run: `flutter test apps/manahpro/test/shared/manah_navigation_button_test.dart`

Expected: gagal karena komponen belum ada.

- [ ] **Step 3: Implement the shared component**

Gunakan `IconButton` dengan style semantic:

```dart
IconButton(
  key: const ValueKey('manah-back-button'),
  tooltip: tooltip,
  onPressed: onPressed ?? () => Navigator.maybePop(context),
  icon: Icon(icon),
  style: IconButton.styleFrom(
    minimumSize: const Size(48, 48),
    backgroundColor: colors.surfaceContainerHigh,
    foregroundColor: colors.onSurface,
    side: BorderSide(color: colors.outlineVariant),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(ManahRadius.md)),
    ),
  ),
)
```

- [ ] **Step 4: Apply it to every scoring AppBar**

Set `leadingWidth: 64`, beri padding kiri 8 lewat wrapper komponen, dan
pertahankan action/close semantics masing-masing layar. Error state score input
juga harus memakai button yang sama.

- [ ] **Step 5: Run tests and targeted analyze**

Run:

```powershell
flutter test apps/manahpro/test/shared/manah_navigation_button_test.dart
dart analyze apps/manahpro/lib/shared/widgets/manah_navigation_button.dart apps/manahpro/lib/features/scoring/presentation/screens
```

Expected: test hijau dan tidak ada issue baru pada file yang disentuh.

- [ ] **Step 6: Commit**

```powershell
git add apps/manahpro/lib/shared/widgets/manah_navigation_button.dart apps/manahpro/lib/features/scoring/presentation/screens apps/manahpro/test/shared/manah_navigation_button_test.dart
git commit -m "feat(scoring): add distinctive navigation controls"
```

### Task 3: Tulis regression tests untuk composer sesi baru

**Files:**
- Create: `apps/manahpro/test/scoring/scoring_setup_screen_test.dart`

- [ ] **Step 1: Build a complete provider test harness**

Buat fake `ScoringRepository` yang menyimpan argumen `startSession`, stream
target face yang dapat berubah dari loading/error ke data, override
`equipmentListProvider`, dan override `userSubscriptionProvider` agar test tidak
menyentuh jaringan.

- [ ] **Step 2: Write failing structure and flow tests**

Test wajib:

1. Header `Siapkan sesi`, tiga section, sticky summary, dan CTA tampil.
2. CTA disabled dan helper target tampil sebelum target dipilih.
3. Pemilih preset membuka bottom sheet; memilih `Latihan 30m` mengubah ringkasan
   menjadi 30m, 30 panah dihitung, dan satu rambahan percobaan.
4. Target loading memakai skeleton, error tidak membocorkan exception, dan
   `Coba lagi` memicu refresh.
5. Memilih target lalu menekan CTA memanggil `startSession` dengan parameter
   benar dan membuka route input.
6. Submit failure menampilkan pesan manusiawi dan mempertahankan nilai form.
7. 360x690 light/dark pada text scale 1.3 dan 2.0 tidak melempar exception.

- [ ] **Step 3: Run tests and confirm RED**

Run: `flutter test apps/manahpro/test/scoring/scoring_setup_screen_test.dart`

Expected: gagal pada copy, key, bottom sheet, state, dan layout baru yang belum
ada.

- [ ] **Step 4: Commit the red tests**

```powershell
git add apps/manahpro/test/scoring/scoring_setup_screen_test.dart
git commit -m "test(scoring): specify the session composer redesign"
```

### Task 4: Implement composer, preset sheet, target states, and submit states

**Files:**
- Modify: `apps/manahpro/lib/features/scoring/presentation/screens/scoring_setup_screen.dart`
- Create: `apps/manahpro/lib/features/scoring/presentation/widgets/scoring_setup_components.dart`
- Test: `apps/manahpro/test/scoring/scoring_setup_screen_test.dart`

- [ ] **Step 1: Split presentation components from orchestration**

Pindahkan reusable/private visual units ke file widgets: section shell,
section heading, category selector, bow-class selector, preset field/sheet,
distance/environment controls, counter row, target selector states, usage
notice, and sticky session action bar. `ScoringSetupScreen` tetap memiliki state
dan callback domain.

- [ ] **Step 2: Implement target state handling**

Loading memakai skeleton berbentuk row, error/empty memakai copy manusiawi dan
retry callback, data memakai preview yang sama. Retry memanggil
`refreshTargetFaces` dan invalidasi provider tanpa menghapus data lokal.

- [ ] **Step 3: Implement preset bottom sheet**

Gunakan `showModalBottomSheet<RoundPreset>` dengan `SafeArea`, drag handle,
list row 72dp minimum, category + description, selected icon, dan dismiss aman.
Pilihan memanggil `_applyPreset`; tombol `Atur manual` hanya melepas preset.

- [ ] **Step 4: Implement sticky action bar and error state**

Action bar membaca live summary. CTA disabled hanya saat target belum dipilih
atau field domain invalid. Loading ada di dalam CTA. Catch exception submit
menjadi pesan inline; tidak ada raw exception atau modal spinner.

- [ ] **Step 5: Run composer tests until GREEN**

Run: `flutter test apps/manahpro/test/scoring/scoring_setup_screen_test.dart`

Expected: seluruh test composer lulus.

- [ ] **Step 6: Run focused tests and analyze**

Run:

```powershell
flutter test apps/manahpro/test/scoring apps/manahpro/test/shared apps/manahpro/test/theme
dart analyze apps/manahpro/lib/features/scoring/presentation apps/manahpro/lib/shared/widgets/manah_navigation_button.dart apps/manahpro/lib/theme apps/manahpro/test/scoring/scoring_setup_screen_test.dart
```

Expected: hijau dan nol issue baru.

- [ ] **Step 7: Commit**

```powershell
git add apps/manahpro/lib/features/scoring/presentation apps/manahpro/test/scoring/scoring_setup_screen_test.dart
git commit -m "feat(scoring): redesign individual session creation"
```

### Task 5: Quality gates, independent review, and Android delivery

**Files:**
- Verify all task files only.

- [ ] **Step 1: Format changed Dart files only**

Run `dart format` terhadap daftar file Dart yang berubah pada task ini.

- [ ] **Step 2: Run analyzer and compare baseline**

Run: `dart run melos run analyze`

Expected: exit 0 atau tepat 101 info baseline, tanpa issue baru pada file task.

- [ ] **Step 3: Run full test suite**

Run: `dart run melos run test`

Expected: seluruh test lulus.

- [ ] **Step 4: Run token and diff hygiene sweeps**

Periksa file widget yang berubah untuk `Color(0x`, `Colors.`, `fontSize:`,
`BorderRadius.circular(`, `BoxShadow(`, `withOpacity(`, `isDark`, spacing di
luar skala, TODO, debug print, dan secret. Jalankan `git diff --check` serta
`git diff --cached --check`.

- [ ] **Step 5: Request independent code review**

Review diff terhadap spec, fokus pada parameter session, offline behavior,
navigation semantics, overflow, contrast, dan pekerjaan user yang tidak boleh
ikut ter-stage. Perbaiki semua Critical/Important lalu ulangi gate terdampak.

- [ ] **Step 6: Build release APK**

Run: `dart run melos run build:android:manahpro`

Expected: `apps/manahpro/build/app/outputs/flutter-apk/app-release.apk` ada dan
hash SHA-256 dicatat.

- [ ] **Step 7: Install and launch on the physical Android device**

Deteksi dengan `adb devices -l`, pilih serial fisik eksplisit, install `-r`,
verifikasi `dumpsys package id.rnq.circlepro`, lalu launch dengan `monkey`.
Jangan melakukan walkthrough visual setelah launch.

- [ ] **Step 8: Commit, fetch, push main, and verify remote**

Stage hanya file task, commit, fetch, pastikan `origin/main` ancestor atau
integrasikan aman, push `HEAD:main` tanpa force, fetch lagi, lalu pastikan hash
lokal sama dengan remote main.
