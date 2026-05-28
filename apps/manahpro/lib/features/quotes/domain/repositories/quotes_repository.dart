import '../../domain/entities/quote_entity.dart';

/// Abstract contract for the Quotes repository.
///
/// Defines the operations available for managing quotes
/// with offline-first architecture support.
abstract class QuotesRepository {
  /// Fetches all quotes. Tries remote first, falls back to local cache.
  Future<List<QuoteEntity>> getQuotes();

  /// Creates a new quote locally (and triggers background sync).
  Future<QuoteEntity> createQuote({
    required String text,
    required String author,
    String? source,
    bool isActive = true,
  });

  /// Updates an existing quote by its local ID.
  Future<QuoteEntity> updateQuote({
    required int localId,
    String? text,
    String? author,
    String? source,
    bool? isActive,
  });

  /// Marks a quote for deletion by its local ID.
  Future<void> deleteQuote(int localId);

  /// Synchronizes all pending local changes with the remote server.
  Future<void> syncQuotes();
}
