import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Cache entries table for offline data persistence.
///
/// Uses a unique [key] to identify cached payloads, with optional
/// TTL (time-to-live) support for automatic expiration.
class CacheEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().unique()();
  TextColumn get jsonPayload => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// TTL in seconds. Null = never expires.
  IntColumn get ttlSeconds => integer().nullable()();
}

/// Main application database using Drift (SQLite).
///
/// Provides structured offline storage with a generic cache table.
/// Feature-specific tables can be added to [tables] as needed.
@DriftDatabase(tables: [CacheEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'app_cache');
  }

  // ─── Cache Operations ─────────────────────────────────────────

  /// Upserts a cache entry (insert or replace if key exists).
  Future<void> writeCache(
    String cacheKey,
    String jsonPayload, {
    int? ttlSeconds,
  }) async {
    await into(cacheEntries).insertOnConflictUpdate(
      CacheEntriesCompanion.insert(
        key: cacheKey,
        jsonPayload: jsonPayload,
        ttlSeconds: Value(ttlSeconds),
      ),
    );
  }

  /// Reads a cache entry by key. Returns `null` if not found or expired.
  Future<String?> readCache(String cacheKey) async {
    final entry = await (select(cacheEntries)
          ..where((t) => t.key.equals(cacheKey)))
        .getSingleOrNull();

    if (entry == null) return null;

    // Check TTL expiration
    if (entry.ttlSeconds != null) {
      final age = DateTime.now().difference(entry.createdAt).inSeconds;
      if (age > entry.ttlSeconds!) {
        await deleteCache(cacheKey);
        return null;
      }
    }

    return entry.jsonPayload;
  }

  /// Deletes a cache entry by key.
  Future<void> deleteCache(String cacheKey) async {
    await (delete(cacheEntries)..where((t) => t.key.equals(cacheKey))).go();
  }

  /// Evicts all expired cache entries. Returns the count of deleted entries.
  Future<int> evictExpired() async {
    final now = DateTime.now();
    final all = await select(cacheEntries).get();
    int deleted = 0;

    for (final entry in all) {
      if (entry.ttlSeconds != null) {
        final age = now.difference(entry.createdAt).inSeconds;
        if (age > entry.ttlSeconds!) {
          await (delete(cacheEntries)..where((t) => t.id.equals(entry.id)))
              .go();
          deleted++;
        }
      }
    }
    return deleted;
  }

  /// Clears all cache entries.
  Future<int> clearAllCache() async {
    return delete(cacheEntries).go();
  }
}
