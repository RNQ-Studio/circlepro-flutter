import 'package:core/core.dart';
import 'package:features_shared/features_shared.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/quotes_local_data_source.dart';
import '../../data/datasources/quotes_remote_data_source.dart';
import '../../data/repositories/quotes_repository_impl.dart';
import '../../domain/repositories/quotes_repository.dart';
import '../../domain/usecases/create_quote_use_case.dart';
import '../../domain/usecases/delete_quote_use_case.dart';
import '../../domain/usecases/get_quotes_use_case.dart';
import '../../domain/usecases/sync_quotes_use_case.dart';
import '../../domain/usecases/update_quote_use_case.dart';

part 'quotes_providers.g.dart';

// ─── Internal Data-Source Providers ─────────────────────────────

@Riverpod(keepAlive: true)
DioClient _dioClient(Ref ref) {
  return DioClient(ref.watch(storageServiceProvider));
}

@Riverpod(keepAlive: true)
QuotesRemoteDataSource _quotesRemoteDataSource(Ref ref) {
  return QuotesRemoteDataSource(ref.watch(_dioClientProvider).dio);
}

@Riverpod(keepAlive: true)
QuotesLocalDataSource _quotesLocalDataSource(Ref ref) {
  return QuotesLocalDataSource(ref.watch(appDatabaseProvider));
}

// ─── Repository Provider ────────────────────────────────────────

@Riverpod(keepAlive: true)
QuotesRepository quotesRepository(Ref ref) {
  return QuotesRepositoryImpl(
    ref.watch(_quotesRemoteDataSourceProvider),
    ref.watch(_quotesLocalDataSourceProvider),
  );
}

// ─── UseCase Providers ──────────────────────────────────────────

@riverpod
GetQuotesUseCase getQuotesUseCase(Ref ref) {
  return GetQuotesUseCase(ref.watch(quotesRepositoryProvider));
}

@riverpod
CreateQuoteUseCase createQuoteUseCase(Ref ref) {
  return CreateQuoteUseCase(ref.watch(quotesRepositoryProvider));
}

@riverpod
UpdateQuoteUseCase updateQuoteUseCase(Ref ref) {
  return UpdateQuoteUseCase(ref.watch(quotesRepositoryProvider));
}

@riverpod
DeleteQuoteUseCase deleteQuoteUseCase(Ref ref) {
  return DeleteQuoteUseCase(ref.watch(quotesRepositoryProvider));
}

@riverpod
SyncQuotesUseCase syncQuotesUseCase(Ref ref) {
  return SyncQuotesUseCase(ref.watch(quotesRepositoryProvider));
}
