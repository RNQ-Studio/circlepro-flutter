import '../../domain/entities/quote_entity.dart';

/// Abstract contract for the Quotes repository.
///
/// Defines the operations available for managing quotes
/// with offline-first architecture support.
abstract class QuotesRepository {
  /// Fetches all quotes. Tries remote first, falls back to local cache.
  Future<List<QuoteEntity>> getQuotes();



  /// Synchronizes all pending local changes with the remote server.
  Future<void> syncQuotes();
}
