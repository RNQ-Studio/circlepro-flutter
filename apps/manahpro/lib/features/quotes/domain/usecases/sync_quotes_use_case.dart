import '../../domain/repositories/quotes_repository.dart';

/// Synchronizes all pending local changes with the remote server.
///
/// Processes unsynced quotes in order of their sync action:
/// - `'create'`: POST to server, then mark as synced with server ID.
/// - `'update'`: PUT to server, then mark as synced.
/// - `'delete'`: DELETE from server, then remove from local database.
///
/// Errors on individual items are logged but do not stop the
/// overall sync process.
class SyncQuotesUseCase {
  const SyncQuotesUseCase(this._repository);

  final QuotesRepository _repository;

  Future<void> call() => _repository.syncQuotes();
}
