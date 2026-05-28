import '../../domain/entities/quote_entity.dart';
import '../../domain/repositories/quotes_repository.dart';

/// Creates a new quote in the local database.
///
/// The quote is stored locally first with `isSynced = false`
/// and will be synced to the server in the background.
class CreateQuoteUseCase {
  const CreateQuoteUseCase(this._repository);

  final QuotesRepository _repository;

  Future<QuoteEntity> call({
    required String text,
    required String author,
    String? source,
    bool isActive = true,
  }) =>
      _repository.createQuote(
        text: text,
        author: author,
        source: source,
        isActive: isActive,
      );
}
