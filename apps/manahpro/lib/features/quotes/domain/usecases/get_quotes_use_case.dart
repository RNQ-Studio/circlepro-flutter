import '../../domain/entities/quote_entity.dart';
import '../../domain/repositories/quotes_repository.dart';

/// Retrieves all quotes from the repository.
///
/// Uses offline-first strategy: tries remote first, falls back to local.
class GetQuotesUseCase {
  const GetQuotesUseCase(this._repository);

  final QuotesRepository _repository;

  Future<List<QuoteEntity>> call() => _repository.getQuotes();
}
