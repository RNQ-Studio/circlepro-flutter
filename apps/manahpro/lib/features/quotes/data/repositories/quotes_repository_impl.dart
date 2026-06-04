import 'dart:developer';

import 'package:core/core.dart';
import 'package:drift/drift.dart';

import '../../domain/entities/quote_entity.dart';
import '../../domain/repositories/quotes_repository.dart';
import '../datasources/quotes_local_data_source.dart';
import '../datasources/quotes_remote_data_source.dart';

/// Offline-first implementation of [QuotesRepository].
///
/// Strategy:
/// - **Read**: Try remote first → save to local → return local data.
///   Falls back to local-only if the network is unavailable.
/// - **Write**: Always write to local first (optimistic), then sync
///   to the server in the background.
/// - **Sync**: Process all unsynced items (create/update/delete) one
///   by one. Errors on individual items are logged but do not halt
///   the overall sync process.
class QuotesRepositoryImpl implements QuotesRepository {
  const QuotesRepositoryImpl(this._remoteDataSource, this._localDataSource);

  final QuotesRemoteDataSource _remoteDataSource;
  final QuotesLocalDataSource _localDataSource;

  @override
  Future<List<QuoteEntity>> getQuotes() async {
    // Always return data from local database immediately (single source of truth)
    // Background synchronization will fetch and update this in the background.
    return _localDataSource.getAllQuotes();
  }

  @override
  Future<void> syncQuotes() async {
    print('QuotesRepository.syncQuotes: Starting sync cycle...');
    // Check server availability first
    final isOnline = await _remoteDataSource.checkHealth();
    if (!isOnline) {
      print(
          'QuotesRepository.syncQuotes: server unreachable (health check returned false), skipping sync');
      return;
    }


    // After syncing all pending items, refresh local data from server
    try {
      print(
          'QuotesRepository.syncQuotes: fetching latest quotes from server...');
      final remoteQuotes = await _remoteDataSource.fetchAll();
      print(
          'QuotesRepository.syncQuotes: fetched ${remoteQuotes.length} quotes from server. Updating local DB...');
      final companions =
          remoteQuotes.map((q) => q.toDatabaseCompanion()).toList();
      await _localDataSource.replaceAllWithServerData(companions);
      print(
          'QuotesRepository.syncQuotes: local DB successfully updated with server quotes.');
    } catch (e) {
      print(
          'QuotesRepository.syncQuotes: failed to refresh from server after sync, error: $e');
    }
  }
}
