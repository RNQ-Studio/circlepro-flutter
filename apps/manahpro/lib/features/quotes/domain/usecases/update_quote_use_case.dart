import '../../domain/entities/quote_entity.dart';
import '../../domain/repositories/quotes_repository.dart';

/// Updates an existing quote by its local ID.
///
/// Only the provided fields will be updated; others remain unchanged.
/// The update is saved locally first, then synced to the server.
class UpdateQuoteUseCase {
  const UpdateQuoteUseCase(this._repository);

  final QuotesRepository _repository;

  Future<QuoteEntity> call({
    required int localId,
    String? text,
    String? author,
    String? source,
    bool? isActive,
  }) =>
      _repository.updateQuote(
        localId: localId,
        text: text,
        author: author,
        source: source,
        isActive: isActive,
      );
}
