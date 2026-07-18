# Individual Scoring Home Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Mengganti beranda multi-fitur ManahPro dengan beranda action-first yang hanya mempromosikan scoring individu.

**Architecture:** `HomeScreen` tetap menjadi entry route `/`, tetapi sumber kontennya berpindah dari profile/gamification/quotes ke `sessionsListProvider` yang offline-first. Widget privat memisahkan top bar, aksi utama, tautan scoring, sesi terakhir, loading, dan error tanpa menambah provider atau dependency baru.

**Tech Stack:** Flutter Material 3, Riverpod 3, GoRouter, existing ManahPro design tokens, Flutter widget test.

---

## File map

- Modify: `apps/manahpro/lib/features/home/presentation/home_screen.dart`
  - Menjadi seluruh composition root untuk beranda scoring individu.
- Modify: `apps/manahpro/test/home_screen_test.dart`
  - Menjadi regression suite untuk state, navigasi, dan compact accessibility.
- Delete: `apps/manahpro/lib/features/home/presentation/widgets/home_menu_grid.dart`
  - Grid sembilan fitur tidak lagi memiliki konsumen.
- Delete: `apps/manahpro/lib/features/home/presentation/widgets/home_quote_of_the_day.dart`
  - Quote tidak lagi menjadi bagian beranda fokus.
- Delete: `apps/manahpro/lib/features/home/presentation/widgets/home_user_header.dart`
  - Profil, XP, dan streak tidak lagi menjadi bagian beranda fokus.

## Task 1: Lock the focused empty state

**Files:**

- Modify: `apps/manahpro/test/home_screen_test.dart`
- Modify: `apps/manahpro/lib/features/home/presentation/home_screen.dart`

- [ ] **Step 1: Replace the old menu test with a failing focused-home test**

Tambahkan override `sessionsListProvider` dengan list kosong dan assertion berikut:

```dart
testWidgets('focuses the home screen on individual scoring', (tester) async {
  await tester.pumpWidget(buildSubject(sessions: const []));
  await tester.pumpAndSettle();

  expect(find.text('Scoring individu'), findsOneWidget);
  expect(find.text('Mulai scoring'), findsOneWidget);
  expect(find.text('Riwayat'), findsOneWidget);
  expect(find.text('Statistik'), findsOneWidget);
  expect(find.text('Bersama'), findsNothing);
  expect(find.text('Klub'), findsNothing);
  expect(find.text('Event'), findsNothing);
  expect(find.text('Pelatih'), findsNothing);
  expect(find.text('Lapangan'), findsNothing);
  expect(find.text('Artikel'), findsNothing);
});
```

- [ ] **Step 2: Run the test and verify RED**

Run:

```powershell
flutter test test/home_screen_test.dart --plain-name "focuses the home screen on individual scoring"
```

Expected: FAIL karena `Scoring individu` dan `Mulai scoring` belum ada serta menu lama masih terlihat.

- [ ] **Step 3: Implement the focused shell and empty state**

Ubah `HomeScreen` agar:

```dart
final sessionsAsync = ref.watch(sessionsListProvider);

return Scaffold(
  body: SafeArea(
    child: RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(sessionsListProvider);
        await ref.read(sessionsListProvider.future);
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          ManahSpacing.base,
          ManahSpacing.sm,
          ManahSpacing.base,
          ManahSpacing.xl,
        ),
        children: [
          _HomeTopBar(isAuthenticated: isAuthenticated),
          const SizedBox(height: ManahSpacing.xl),
          Text('Scoring individu', style: theme.textTheme.headlineSmall),
          const SizedBox(height: ManahSpacing.xs),
          Text(
            'Catat setiap anak panah, bahkan saat offline.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: ManahSpacing.lg),
          sessionsAsync.when(
            loading: _HomeLoading.new,
            error: (_, __) => _HomeError(
              onRetry: () => ref.invalidate(sessionsListProvider),
            ),
            data: (sessions) => _HomeScoringContent(sessions: sessions),
          ),
        ],
      ),
    ),
  ),
);
```

`_HomeScoringContent` untuk list kosong menampilkan satu surface dengan `Icons.adjust_rounded`, title `Mulai scoring individu`, body `Atur busur, jarak, dan target untuk memulai sesi.`, caption `Siap dipakai offline`, serta `FilledButton.icon` berlabel `Mulai scoring` yang memanggil `context.push(ScoringRoutes.setup)`.

- [ ] **Step 4: Run the focused test and verify GREEN**

Run command yang sama. Expected: PASS.

- [ ] **Step 5: Commit the first slice**

```powershell
git add apps/manahpro/lib/features/home/presentation/home_screen.dart apps/manahpro/test/home_screen_test.dart
git commit -m "feat(home): focus empty state on individual scoring"
```

## Task 2: Resume active scoring and show the latest result

**Files:**

- Modify: `apps/manahpro/test/home_screen_test.dart`
- Modify: `apps/manahpro/lib/features/home/presentation/home_screen.dart`

- [ ] **Step 1: Add failing active and completed-session tests**

Gunakan entity nyata:

```dart
final activeSession = ScoringSessionEntity(
  id: 'active-session',
  clientUuid: 'active-client',
  bowClass: BowClass.recurve,
  distanceCategory: DistanceCategory.d50m,
  distanceM: 50,
  numEnds: 6,
  arrowsPerEnd: 6,
  startedAt: DateTime(2026, 7, 19, 8),
  ends: const [
    ScoringEndEntity(
      id: 'active-end',
      endNumber: 1,
      arrows: [
        ArrowScore(id: 'a1', arrowIndex: 0, scoreValue: 10),
        ArrowScore(id: 'a2', arrowIndex: 1, scoreValue: 9),
      ],
    ),
  ],
);
```

Assert `Lanjutkan scoring`, `2 dari 36 panah`, dan tap menuju test destination `Input active-session`.

Gunakan sesi selesai 3 panah dengan total 28 dari 30. Assert `Sesi terakhir`, `28`, `/ 30`, lalu tap menuju test destination `Summary completed-session`.

- [ ] **Step 2: Run both tests and verify RED**

```powershell
flutter test test/home_screen_test.dart --plain-name "continues the latest active scoring session"
flutter test test/home_screen_test.dart --plain-name "opens the latest completed session summary"
```

Expected: FAIL karena state session belum dirender.

- [ ] **Step 3: Implement active and latest-session derivation**

Di `_HomeScoringContent.build`:

```dart
final activeSession = _firstWhereOrNull(
  sessions,
  (session) => session.status == ScoringSessionStatus.inProgress,
);
final latestCompletedSession = _firstWhereOrNull(
  sessions,
  (session) => session.status == ScoringSessionStatus.completed,
);
```

Gunakan helper lokal berikut agar tidak menambah dependency extension:

```dart
ScoringSessionEntity? _firstWhereOrNull(
  List<ScoringSessionEntity> sessions,
  bool Function(ScoringSessionEntity) predicate,
) {
  for (final session in sessions) {
    if (predicate(session)) return session;
  }
  return null;
}
```

Active surface menampilkan metadata `${session.bowClass.label} · ${session.distanceCategory.label}`, progress `${session.arrowsShot} dari ${session.plannedArrows} panah`, `LinearProgressIndicator`, dan tombol menuju `ScoringRoutes.input(session.id)`.

Latest-result row menampilkan skor, maksimum, metadata, tanggal dari `_formatSessionDate`, status `Tersinkron` atau `Menunggu sinkronisasi`, lalu membuka `ScoringRoutes.summary(session.id)`.

- [ ] **Step 4: Run both tests and verify GREEN**

Run kedua command Step 2. Expected: PASS.

- [ ] **Step 5: Commit the session-aware slice**

```powershell
git add apps/manahpro/lib/features/home/presentation/home_screen.dart apps/manahpro/test/home_screen_test.dart
git commit -m "feat(home): resume active scoring from home"
```

## Task 3: Navigation, error state, and compact themes

**Files:**

- Modify: `apps/manahpro/test/home_screen_test.dart`
- Modify: `apps/manahpro/lib/features/home/presentation/home_screen.dart`

- [ ] **Step 1: Add failing navigation, error, and compact-theme tests**

Tambahkan route test destination untuk setup, history, dashboard, input, summary, settings, dan login. Assert:

```dart
await tester.tap(find.text('Riwayat'));
await tester.pumpAndSettle();
expect(find.text('History destination'), findsOneWidget);
```

Ulangi untuk Statistik. Untuk error, override provider dengan `Future.error(StateError('failed'))` dan assert `Data scoring belum bisa dimuat.` serta `Coba lagi` tanpa exception mentah.

Untuk compact theme:

```dart
await tester.binding.setSurfaceSize(const Size(360, 690));
addTearDown(() => tester.binding.setSurfaceSize(null));

await tester.pumpWidget(buildSubject(
  sessions: [activeSession, completedSession],
  themeMode: ThemeMode.light,
  textScaler: const TextScaler.linear(1.3),
));
await tester.pumpAndSettle();
expect(tester.takeException(), isNull);
```

Ulangi dengan dark theme.

- [ ] **Step 2: Run the new tests and verify RED where behavior is absent**

```powershell
flutter test test/home_screen_test.dart
```

Expected: FAIL pada route sekunder, error copy, atau compact state sebelum implementasi lengkap.

- [ ] **Step 3: Implement secondary rows and resilient states**

Tambahkan `_ScoringLinkRow` untuk Riwayat dan Statistik dengan minimum tinggi 56, `InkWell`, icon, label, description, dan chevron. Tambahkan `_HomeLoading` berupa semantic skeleton surface serta `_HomeError` dengan copy manusiawi dan `OutlinedButton.icon` Coba lagi.

Semua styling menggunakan `Theme.of(context).colorScheme`, `TextTheme`, `ManahSpacing`, dan `ManahRadius`; jangan menambah `Colors.*`, `Color(0x`, `fontSize`, `BoxShadow`, `withOpacity`, atau radius bebas di widget.

- [ ] **Step 4: Run the whole home test and verify GREEN**

```powershell
flutter test test/home_screen_test.dart
```

Expected: seluruh test PASS dan `tester.takeException()` null pada light/dark compact cases.

- [ ] **Step 5: Commit the resilient interaction slice**

```powershell
git add apps/manahpro/lib/features/home/presentation/home_screen.dart apps/manahpro/test/home_screen_test.dart
git commit -m "test(home): cover focused scoring states"
```

## Task 4: Remove obsolete home widgets and run full verification

**Files:**

- Delete: `apps/manahpro/lib/features/home/presentation/widgets/home_menu_grid.dart`
- Delete: `apps/manahpro/lib/features/home/presentation/widgets/home_quote_of_the_day.dart`
- Delete: `apps/manahpro/lib/features/home/presentation/widgets/home_user_header.dart`

- [ ] **Step 1: Verify the widgets have no consumers**

```powershell
rg -n "HomeMenuGrid|HomeQuoteOfTheDay|HomeUserHeader" apps/manahpro/lib apps/manahpro/test
```

Expected: hanya definisi file lama; tidak ada call site.

- [ ] **Step 2: Delete the three obsolete files**

Hapus ketiga file melalui patch. Jangan menghapus `home_provider.dart` karena `StoryHeaderListWidget` masih mengimpornya.

- [ ] **Step 3: Format changed Dart files**

```powershell
dart format apps/manahpro/lib/features/home/presentation/home_screen.dart apps/manahpro/test/home_screen_test.dart
```

Expected: exit 0.

- [ ] **Step 4: Run focused and workspace gates**

```powershell
flutter test apps/manahpro/test/home_screen_test.dart
dart run melos run analyze
dart run melos run test
dart run melos run build:android:manahpro
```

Expected: home test pass; analyze tidak menambah issue dibanding baseline 124 info; workspace test pass; APK release build exit 0.

- [ ] **Step 5: Run token and diff hygiene sweeps**

```powershell
rg --pcre2 -n "Color\(0x|Colors\.(?!transparent)|fontSize:|BorderRadius\.circular\(|BoxShadow\(|withOpacity\(|isDark" apps/manahpro/lib/features/home/presentation/home_screen.dart
git diff --check
git diff --cached --check
git status --short
```

Expected: token sweep tidak menemukan pola terlarang di `home_screen.dart`; diff checks exit 0; status hanya memuat perubahan home milik task plus perubahan user yang sudah ada sebelumnya.

- [ ] **Step 6: Commit only the relevant final cleanup**

```powershell
git add apps/manahpro/lib/features/home/presentation/home_screen.dart apps/manahpro/lib/features/home/presentation/widgets/home_menu_grid.dart apps/manahpro/lib/features/home/presentation/widgets/home_quote_of_the_day.dart apps/manahpro/lib/features/home/presentation/widgets/home_user_header.dart apps/manahpro/test/home_screen_test.dart apps/manahpro/docs/superpowers/plans/2026-07-19-individual-scoring-home.md
git commit -m "feat(home): simplify ManahPro around individual scoring"
```

- [ ] **Step 7: Deliver without disturbing unrelated work**

Fetch remote, verify ancestry, and push only if the existing dirty feature branch can fast-forward `origin/main` without including unrelated uncommitted files. Detect one physical Android device; build, install, and launch the same APK if available. If no device is connected, report the exact ready-to-install APK path and command.
