# ⚡ Modul 3: Memahami Riverpod Generator

Bagi programmer pemula yang terbiasa dengan provider manual (seperti `StateNotifierProvider` versi lama), sintaks Riverpod di starter project ini mungkin terlihat misterius. Mengapa tidak ada deklarasi provider manual? Di mana provider itu dibuat?

Proyek ini menggunakan **Riverpod Generator** (`@riverpod`). Ini adalah standar penulisan Riverpod paling modern yang didukung resmi oleh penciptanya (Remi Rousselet).

Mari kita bedah cara kerjanya!

---

## 1. Perbedaan Gaya Penulisan: Manual vs Generator

Sebelum ada generator, kita harus menulis banyak boilerplate kode untuk satu provider:

```dart
// ❌ GAYA LAMA (Boilerplate manual, panjang, & rentan salah tipe data)
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo);
});
```

Dengan **Riverpod Generator**, Anda cukup menulis kelas Notifier biasa dan memberikan anotasi `@riverpod`. Generator akan otomatis membuatkan variabel `authNotifierProvider` untuk Anda!

```dart
// ✅ GAYA BARU (Menggunakan Generator, ringkas, dan aman)
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    // Inisialisasi awal di sini
    return const AuthInitial();
  }
}
```

> [!IMPORTANT]
> Perhatikan kata kunci `_$AuthNotifier`. Kelas dasar (superclass) berawalan `_$Name` ini di-generate otomatis oleh Riverpod Generator di dalam file pendamping `.g.dart`. 
> Jika Anda melihat garis merah pada nama class ini saat membuat file baru, jangan panik! Cukup jalankan skrip codegen di terminal:
> `dart run melos run codegen`

---

## 2. Kapan Harus Menggunakan `@riverpod` Class vs Function?

Ada dua jenis provider yang bisa di-generate otomatis:

### A. Generator Berbasis Fungsi (Functional Provider)
Gunakan jika Anda hanya butuh data read-only yang bergantung pada provider lain, atau objek instansi statis (tidak ada *logic* pengubah state di dalamnya).

*Contoh*: Dependency Injection untuk Repository.
```dart
@riverpod
AuthRepository authRepository(Ref ref) {
  final remoteDS = ref.watch(authRemoteDataSourceProvider);
  final localDS = ref.watch(authLocalDataSourceProvider);
  return AuthRepositoryImpl(remoteDS, localDS);
}
```
*Hasil generate*: Otomatis membuat provider bernama `authRepositoryProvider`.

### B. Generator Berbasis Kelas (Class-based Notifier)
Gunakan jika Anda membutuhkan logika untuk mengubah *state* (misalnya dari `initial` ke `loading` lalu `success`).

*Contoh*: Mengatur status login user.
```dart
@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null); // Nilai awal state
  }

  Future<void> submit(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(authRepositoryProvider).login(email, password));
  }
}
```

---

## 3. Aturan Emas Riverpod: `ref.watch` vs `ref.read`

Kesalahan paling umum pemula adalah salah menggunakan `ref.watch` dan `ref.read`. Ingat baik-baik aturan berikut:

### `ref.watch` (Untuk Memantau Perubahan State & Rebuild UI)
* **Tempat**: Di dalam method `build(BuildContext context, WidgetRef ref)` pada widget, atau di dalam fungsi `build()` milik notifier.
* **Kegunaan**: Memantau state. Jika nilai provider berubah, widget Anda akan di-rebuild secara otomatis agar layar menampilkan data terbaru.

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  // ✅ BENAR: Memantau perubahan status auth
  final authState = ref.watch(authNotifierProvider);

  return authState.when(
    data: (data) => Text('Welcome ${data.name}'),
    loading: () => CircularProgressIndicator(),
    error: (err, stack) => Text('Error: $err'),
  );
}
```

### `ref.read` (Untuk Menjalankan Aksi / Event Callback)
* **Tempat**: Di dalam fungsi penanganan event seperti `onPressed`, `onTap`, atau di dalam fungsi inisiasi *lifecycle*.
* **Kegunaan**: Memanggil metode atau aksi dari provider **sekali jalan**. Kita tidak ingin me-rebuild tombol ketika state berubah, kita hanya ingin memicu aksi.

```dart
ElevatedButton(
  onPressed: () {
    // ✅ BENAR: Menggunakan ref.read untuk memicu fungsi login
    ref.read(authNotifierProvider.notifier).login(
          email: _emailController.text,
          password: _passwordController.text,
        );
  },
  child: const Text('Login'),
)
```

> [!WARNING]
> **DILARANG KERAS** menggunakan `ref.read` di dalam method `build` widget! Ini akan membuat UI tidak responsif (tidak ter-rebuild) saat data berubah, atau sebaliknya menyebabkan *bug* rendering yang tidak terprediksi.

---

## 4. Siklus Hidup Provider: `autoDispose` vs `keepAlive`

Secara bawaan (*default*), anotasi `@riverpod` akan bersifat **autoDispose**. Artinya, ketika widget yang memakai provider tersebut ditutup (tidak tampil lagi di layar), state dari provider tersebut akan dihapus dari memori secara otomatis.

Jika Anda ingin menyimpan state tersebut agar tetap ada sepanjang aplikasi berjalan (misal: data user login, tema aplikasi, lokalisasi bahasa), tambahkan parameter `keepAlive: true`:

```dart
// State tidak akan pernah dibuang dari memori
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier { ... }
```

---

Modul berikutnya akan menjelaskan bagaimana database lokal Drift SQLite diintegrasikan sebagai sistem caching offline!

👉 **[Lanjut ke Modul 4: Drift Database & Local Cache](file:///c:/Users/62822/Documents/Work/flutter/flutter-starter/docs/tutorial/04_local_cache_drift.md)**
