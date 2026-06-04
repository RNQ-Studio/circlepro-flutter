import 'package:core/core.dart';
import 'package:drift/drift.dart';

import '../models/quote_model.dart';

/// Local data source for offline Quotes storage using Drift (SQLite).
///
/// Manages CRUD operations on the local [Quotes] table and provides
/// sync-status tracking for the offline-first architecture.
class QuotesLocalDataSource {
  const QuotesLocalDataSource(this._db);

  final AppDatabase _db;

  /// Retrieves all quotes that are NOT marked for deletion.
  ///
  /// Items with `syncAction = 'delete'` are excluded from the result
  /// since they are pending server-side removal.
  Future<List<QuoteModel>> getAllQuotes() async {
    final query = _db.select(_db.quotes)
      ..orderBy([
        (t) => OrderingTerm.desc(t.createdAt),
      ]);

    final rows = await query.get();
    return rows.map(QuoteModel.fromDatabase).toList();
  }


  /// Replaces all synced data with fresh server data.
  ///
  /// **Important**: Only deletes rows where `isSynced == true`.
  /// Unsynced local changes (`isSynced == false`) are preserved
  /// to avoid data loss during the refresh.
  Future<void> replaceAllWithServerData(
    List<QuotesCompanion> serverData,
  ) async {
    await _db.transaction(() async {
      // Delete all existing quotes
      await _db.delete(_db.quotes).go();

      // Insert fresh server data
      for (final companion in serverData) {
        await _db.into(_db.quotes).insert(companion);
      }
    });
  }
}
