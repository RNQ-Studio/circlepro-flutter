import '../../domain/entities/quote_entity.dart';

/// Abstract contract for the Quotes repository.
///
/// Defines the operations available for managing quotes
/// with offline-first architecture support.
abstract class QuotesRepository {
  /// Fetches all quotes. Tries remote first, falls back to local cache.
  Future<List<QuoteEntity>> getQuotes();

  /// Synchronizes local data with the remote server (pull only).
  Future<void> syncQuotes();

  /// Loves a quote on the server. Returns updated love_count.
  Future<int> loveQuote(int quoteId);

  /// Unloves a quote on the server. Returns updated love_count.
  Future<int> unloveQuote(int quoteId);
}
