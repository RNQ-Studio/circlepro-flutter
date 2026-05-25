# Add Feature Guide

Panduan ini menjelaskan cara menambah fitur baru di starter ini. Fokusnya adalah keputusan lokasi fitur, struktur file, export public API, routing, provider, dan verifikasi.

---

## Cara Cepat (Mason CLI)

Jika Mason CLI sudah terinstal (`dart pub global activate mason_cli`), buat fitur baru dengan satu perintah:

```bash
# Generate di features_shared (default)
mason make feature --feature_name order --output-dir packages/features_shared/lib/src/

# Atau via Melos script
dart run melos run make-feature
```

Perintah ini menghasilkan struktur Clean Architecture lengkap:
- `domain/` — entity, repository interface, use cases
- `data/` — model, remote & local data source, repository impl
- `presentation/` — Riverpod notifier, screen

Setelah generate, lanjutkan ke bagian **4. Export Shared Feature** untuk mendaftarkan public API.

## 1. Tentukan Lokasi Fitur

Sebelum membuat file, jawab pertanyaan ini:

| Pertanyaan | Lokasi |
|------------|--------|
| Dipakai oleh semua app/flavor? | `packages/features_shared/lib/src/<feature>/` |
| Hanya dipakai `apps/main`? | `apps/main/lib/features/<feature>/` |
| Hanya dipakai `apps/variant`? | `apps/variant/lib/features/<feature>/` |
| Fondasi lintas fitur seperti theme, storage, network, l10n, constants, responsive? | `packages/core/lib/src/` |

Aturan penting:

- Jangan import dari `apps/main` ke `features_shared`.
- Jangan import dari `apps/variant` ke `features_shared`.
- `features_shared` boleh import `core`.
- `apps/*` boleh import `core` dan `features_shared`.
- Dari luar package, import lewat barrel file: `package:core/core.dart` atau `package:features_shared/features_shared.dart`.

---

## 2. Pilih Bentuk Struktur

Untuk fitur bisnis dengan data source, entity, repository, usecase, dan UI, gunakan struktur tiga lapisan:

```text
<feature>/
|-- data/
|   |-- datasources/
|   |-- models/
|   `-- repositories/
|-- domain/
|   |-- entities/
|   |-- repositories/
|   `-- usecases/
`-- presentation/
    |-- providers/
    |-- widgets/
    |-- <feature>_screen.dart
    `-- <feature>_route.dart
```

Untuk fitur kecil seperti preference sederhana, struktur boleh lebih pendek:

```text
<feature>/
|-- <feature>_repository.dart
|-- <feature>_repository_impl.dart
|-- <feature>_providers.dart
`-- <feature>_notifier.dart
```

Gunakan struktur sederhana hanya jika fitur belum punya boundary `data/domain/presentation` yang jelas.

---

## 3. Menambah Shared Feature

Contoh fitur: `orders`, dipakai oleh semua app.

Buat struktur:

```text
packages/features_shared/lib/src/orders/
|-- data/
|   |-- datasources/
|   |   `-- orders_remote_data_source.dart
|   |-- models/
|   |   `-- order_model.dart
|   `-- repositories/
|       `-- orders_repository_impl.dart
|-- domain/
|   |-- entities/
|   |   `-- order.dart
|   |-- repositories/
|   |   `-- orders_repository.dart
|   `-- usecases/
|       `-- get_orders_use_case.dart
`-- presentation/
    |-- orders_provider.dart
    |-- orders_screen.dart
    `-- orders_routes.dart
```

### Entity

```dart
class Order {
  const Order({
    required this.id,
    required this.title,
  });

  final String id;
  final String title;
}
```

### Repository Interface

```dart
abstract class OrdersRepository {
  Future<List<Order>> getOrders();
}
```

### Usecase

```dart
class GetOrdersUseCase {
  const GetOrdersUseCase(this._repository);

  final OrdersRepository _repository;

  Future<List<Order>> call() => _repository.getOrders();
}
```

### Provider

```dart
final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  return OrdersRepositoryImpl();
});

final ordersProvider = FutureProvider<List<Order>>((ref) {
  final repository = ref.watch(ordersRepositoryProvider);
  return GetOrdersUseCase(repository)();
});
```

Jika repository membutuhkan dependency dari app, buat provider yang dioverride di app root, seperti pola `storageServiceProvider` pada auth.

---

## 4. Export Shared Feature

Setelah fitur shared dibuat, export public API di:

```text
packages/features_shared/lib/features_shared.dart
```

Contoh:

```dart
// orders - domain
export 'src/orders/domain/entities/order.dart';
export 'src/orders/domain/repositories/orders_repository.dart';
export 'src/orders/domain/usecases/get_orders_use_case.dart';

// orders - data
export 'src/orders/data/repositories/orders_repository_impl.dart';

// orders - presentation
export 'src/orders/presentation/orders_provider.dart';
export 'src/orders/presentation/orders_screen.dart';
export 'src/orders/presentation/orders_routes.dart';
```

Jangan export file internal yang tidak perlu dipakai app, misalnya private helper atau model DTO yang hanya dipakai repository.

---

## 5. Menambah App-Specific Feature

Jika fitur hanya milik app tertentu, buat di app tersebut.

Contoh untuk `apps/main`:

```text
apps/main/lib/features/reports/
|-- data/
|-- domain/
`-- presentation/
    |-- reports_screen.dart
    `-- reports_route.dart
```

Route app-specific tidak perlu diexport dari `features_shared`. Import langsung dari router app:

```dart
import '../features/reports/presentation/reports_route.dart';
```

Lalu daftarkan di:

```text
apps/main/lib/router/app_router.dart
```

---

## 6. Tambah Route

Jika route dipakai lintas app, tambahkan konstanta di:

```text
packages/core/lib/src/router/app_routes.dart
```

Contoh:

```dart
abstract final class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String orders = '/orders';
}
```

Buat route definition di fitur:

```dart
final ordersRoute = GoRoute(
  path: AppRoutes.orders,
  builder: (context, state) => const OrdersScreen(),
);
```

Daftarkan route di app router:

```dart
final appRouter = GoRouter(
  initialLocation: '/',
  redirect: authRedirect,
  observers: [AppNavigatorObserver()],
  routes: [
    ...authRoutes,
    ordersRoute,
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
```

Jika route hanya milik satu app, konstanta boleh tetap di file route app-specific. Gunakan `AppRoutes` untuk route yang menjadi kontrak lintas app.

---

## 7. Tambah Navigasi Dari UI

Gunakan GoRouter:

```dart
IconButton(
  icon: const Icon(Icons.list_alt),
  onPressed: () => context.push(AppRoutes.orders),
)
```

Import yang umum dipakai:

```dart
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
```

---

## 8. Tambah L10n Jika Ada Teks Baru

File ARB berada di:

```text
packages/core/lib/src/l10n/app_id.arb
packages/core/lib/src/l10n/app_en.arb
```

Tambahkan key yang sama di semua file ARB.

Contoh:

```json
{
  "ordersTitle": "Pesanan"
}
```

```json
{
  "ordersTitle": "Orders"
}
```

Generate ulang localization dari package `core`:

```bash
cd packages/core
flutter gen-l10n
```

Gunakan dari UI:

```dart
final l10n = AppLocalizations.of(context);
Text(l10n.ordersTitle);
```

---

## 9. Tambah Dependency

Tambahkan dependency ke package/app yang mengimport langsung package tersebut.

Contoh:

- Jika hanya `apps/main` yang import package baru, tambahkan ke `apps/main/pubspec.yaml`.
- Jika `features_shared` yang import package baru, tambahkan ke `packages/features_shared/pubspec.yaml`.
- Jika `core` yang import package baru, tambahkan ke `packages/core/pubspec.yaml`.

Setelah update:

```bash
dart pub get
```

Jangan mengandalkan transitive dependency untuk import langsung.

---

## 10. Tambah Test

Minimal test disesuaikan dengan risiko fitur:

| Tipe logic | Test yang disarankan |
|------------|----------------------|
| Entity/model | parsing, equality sederhana, required field |
| Repository | success, empty result, error mapping |
| Notifier/provider | loading, success, error state |
| Usecase | memanggil repository yang benar |
| Screen | widget smoke test dan state utama |
| Route guard | redirect saat authenticated/unauthenticated |

Lokasi test mengikuti package/app pemilik fitur:

```text
packages/features_shared/test/
apps/main/test/
apps/variant/test/
```

Contoh nama file:

```text
packages/features_shared/test/orders/orders_provider_test.dart
apps/main/test/reports/reports_screen_test.dart
```

---

## 11. Verifikasi

Jalankan dari root repo:

```bash
dart analyze packages/core packages/features_shared apps/main apps/variant
flutter test apps/main/test apps/variant/test packages/core/test packages/features_shared/test
```

Jika menambah l10n, pastikan generated file ikut berubah:

```bash
cd packages/core
flutter gen-l10n
```

Jika menambah route, jalankan app dan cek navigasi manual:

```bash
melos run dev
melos run dev:variant
```

---

## 12. Checklist Pull Request Fitur

- [ ] Lokasi fitur sudah benar: shared atau app-specific.
- [ ] Dependency direction tetap satu arah.
- [ ] Public API yang perlu dipakai app sudah diexport dari barrel file.
- [ ] Route sudah didaftarkan di app router yang sesuai.
- [ ] `AppRoutes` hanya berisi route yang memang menjadi kontrak lintas app.
- [ ] Teks baru sudah masuk ke semua file ARB.
- [ ] Dependency baru ditambahkan ke package/app yang mengimport langsung.
- [ ] Test minimal sudah ditambahkan.
- [ ] `dart analyze` clean.
- [ ] `flutter test` pass.
