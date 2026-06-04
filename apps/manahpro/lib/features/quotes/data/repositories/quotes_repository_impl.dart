import '../../domain/entities/quote_entity.dart';
import '../../domain/repositories/quotes_repository.dart';
import '../datasources/quotes_local_data_source.dart';
import '../datasources/quotes_remote_data_source.dart';

/// Offline-first implementation of [QuotesRepository].
///
/// Strategy:
/// - **Read**: Returns local SQLite data as single source of truth.
/// - **Sync**: Pulls latest data from server and replaces local cache.
/// - **Love/Unlove**: Calls server API directly (requires auth/online).
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

    // Refresh local data from server
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

  @override
  Future<int> loveQuote(int quoteId) async {
    final result = await _remoteDataSource.loveQuote(quoteId);
    return result['love_count'] as int;
  }

  @override
  Future<int> unloveQuote(int quoteId) async {
    final result = await _remoteDataSource.unloveQuote(quoteId);
    return result['love_count'] as int;
  }
}
