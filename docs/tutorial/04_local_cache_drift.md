# 🗄️ Modul 4: Drift Database & Local Cache

Salah satu keunggulan utama dari starter project ini adalah dukungan **Offline-first** menggunakan database SQLite terstruktur berkinerja tinggi: **Drift** (sebelumnya dikenal sebagai Moor).

Bagi pemula yang hanya terbiasa dengan `SharedPreferences` (penyimpanan key-value sederhana), mengelola database relasional di Flutter bisa terasa rumit.

Mari kita bahas bagaimana Drift bekerja dan bagaimana sistem caching otomatis di proyek ini dibangun!

---

## 1. Mengapa Menggunakan Drift SQLite?

`SharedPreferences` sangat lambat dan tidak cocok untuk menyimpan data kompleks yang berstruktur besar (seperti daftar produk, riwayat transaksi, atau data profil lengkap). 

Drift memberikan kita kekuatan:
* Database SQLite asli yang berkinerja tinggi.
* Keamanan Tipe Data (*Type-safe queries*) ditulis dengan sintaks Dart yang ramah pengembang.
* Dukungan migrasi skema database yang andal.

Di starter project ini, file konfigurasi database utama dapat ditemukan di [app_database.dart](file:///c:/Users/62822/Documents/Work/flutter/flutter-starter/packages/core/lib/src/storage/app_database.dart).

---

## 2. Mendefinisikan Tabel Database di Drift

Untuk membuat tabel baru di SQLite menggunakan Drift, kita cukup mendeklarasikan kelas Dart yang meng-extend kelas `Table`.

Mari kita lihat tabel `CacheEntries` bawaan kita:

```dart
class CacheEntries extends Table {
  // id sebagai primary key yang auto increment
  IntColumn get id => integer().autoIncrement()();
  
  // key bersifat unik untuk menyimpan identitas cache (misal: 'get_profile_1')
  TextColumn get key => text().unique()();
  
  // payload berformat JSON string hasil dari API response
  TextColumn get jsonPayload => text()();
  
  // Tanggal & waktu entri cache dibuat
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  // Batas kedaluwarsa cache dalam satuan detik (null jika tidak kedaluwarsa)
  IntColumn get ttlSeconds => integer().nullable()();
}
```

Setelah tabel ditulis, kita mendaftarkannya di anotasi `@DriftDatabase`:
```dart
@DriftDatabase(tables: [CacheEntries])
class AppDatabase extends _$AppDatabase { ... }
```
Setelah itu, jalankan `dart run melos run codegen` agar Drift meng-generate file SQL dan pemetaan objek Dart di berkas `.g.dart`.

---

## 3. Strategi Caching Pintar dengan TTL (Time-To-Live)

Salah satu bagian tercerdas di proyek ini adalah pemanfaatan database lokal sebagai **Local Cache Generik**. Alih-alih membuat tabel untuk setiap jenis respon API, kita menyimpan respon API sebagai string JSON di dalam tabel `CacheEntries` dengan waktu kedaluwarsa (TTL).

Bagaimana mekanisme pembacaan cache bekerja? Perhatikan logika berikut di [app_database.dart](file:///c:/Users/62822/Documents/Work/flutter/flutter-starter/packages/core/lib/src/storage/app_database.dart#L52-L70):

```dart
Future<String?> readCache(String cacheKey) async {
  // 1. Cari data di database berdasarkan key unik
  final entry = await (select(cacheEntries)
        ..where((t) => t.key.equals(cacheKey)))
      .getSingleOrNull();

  if (entry == null) return null; // Data tidak ada di lokal

  // 2. Jika TTL diatur, hitung apakah cache sudah kedaluwarsa
  if (entry.ttlSeconds != null) {
    final age = DateTime.now().difference(entry.createdAt).inSeconds;
    if (age > entry.ttlSeconds!) {
      // Cache sudah basi! Hapus dari database dan kembalikan null
      await deleteCache(cacheKey);
      return null;
    }
  }

  // 3. Cache masih segar, kembalikan isi payload-nya!
  return entry.jsonPayload;
}
```

---

## 4. Mekanisme Pembersihan Otomatis (Eviction Policy)

Untuk mencegah memori perangkat pengguna penuh oleh data cache yang sudah kedaluwarsa (*stale cache*), kita memiliki fungsi `evictExpired()`. Fungsi ini secara asinkron memindai seluruh tabel dan menghapus entri cache yang masa berlakunya telah habis.

```dart
Future<int> evictExpired() async {
  final now = DateTime.now();
  final all = await select(cacheEntries).get();
  int deleted = 0;

  for (final entry in all) {
    if (entry.ttlSeconds != null) {
      final age = now.difference(entry.createdAt).inSeconds;
      if (age > entry.ttlSeconds!) {
        await (delete(cacheEntries)..where((t) => t.id.equals(entry.id))).go();
        deleted++;
      }
    }
  }
  return deleted;
}
```

### Bagaimana Cara Programmer Pemula Menggunakan Sistem Cache Ini?
Di layer Repository Implementation, Anda cukup memanfaatkan provider `appDatabaseProvider` untuk menulis dan membaca cache sebelum melakukan *network request* ke internet.

Contoh sederhana:
```dart
Future<Profile> getProfile(String userId) async {
  final cacheKey = 'profile_$userId';
  
  // 1. Coba baca dari local database dahulu
  final cachedJson = await _database.readCache(cacheKey);
  if (cachedJson != null) {
    return ProfileModel.fromJson(jsonDecode(cachedJson));
  }
  
  // 2. Jika cache kosong/expired, panggil API internet
  final freshModel = await _remoteDataSource.getProfile(userId);
  
  // 3. Simpan data baru tersebut ke cache untuk pemanggilan berikutnya dengan TTL 1 Jam (3600 detik)
  await _database.writeCache(cacheKey, jsonEncode(freshModel.toJson()), ttlSeconds: 3600);
  
  return freshModel;
}
```

Sistem caching ini sangat ampuh dalam mengurangi beban server backend, menghemat kuota internet pengguna, dan membuat transisi aplikasi terasa instan bagi pengguna!

---

Modul berikutnya akan memandu Anda mempercepat proses coding modul baru menggunakan kekuatan Mason!

👉 **[Lanjut ke Modul 5: Mason Bricks & Automasi](file:///c:/Users/62822/Documents/Work/flutter/flutter-starter/docs/tutorial/05_mason_bricks.md)**
