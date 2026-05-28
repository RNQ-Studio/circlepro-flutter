import '../../domain/repositories/quotes_repository.dart';

/// Marks a quote for deletion by its local ID.
///
/// If the quote was never synced (server ID is null), it is deleted
/// immediately from SQLite. Otherwise, it is soft-deleted and will
/// be removed from the server during the next sync cycle.
class DeleteQuoteUseCase {
  const DeleteQuoteUseCase(this._repository);

  final QuotesRepository _repository;

  Future<void> call(int localId) => _repository.deleteQuote(localId);
}
