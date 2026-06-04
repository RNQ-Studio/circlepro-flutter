import 'dart:developer';

import 'package:core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/entities/quote_entity.dart';
import 'providers/quotes_providers.dart';

part 'quotes_notifier.g.dart';

/// Async notifier managing the Quotes list state with offline-first
/// auto-synchronization.
///
/// The [build] method initializes by triggering a background sync,
/// then returns the local SQLite data as the single source of truth.
///
/// All sync methods use read-only pulling. Love/unlove uses optimistic UI.
@riverpod
class QuotesNotifier extends _$QuotesNotifier {
  @override
  Future<List<QuoteEntity>> build() async {
    // Listen to network status changes and trigger background sync when coming online
    ref.listen(connectivityServiceProvider, (previous, next) {
      final isOnline = next.value ?? false;
      final wasOnline = previous?.value ?? false;

      // Trigger sync ONLY when transitioning from offline to online
      if (isOnline && !wasOnline) {
        log('Connectivity changed from Offline to Online. Flushing sync queue...',
            name: 'QuotesNotifier');
        syncInBackground();
      }
    });

    // Trigger background sync (don't block UI loading)
    syncInBackground();

    // Return local data as the initial state
    return _loadLocalQuotes();
  }

  /// Toggles the love state for a quote with optimistic UI update.
  ///
  /// 1. Immediately updates the UI (optimistic)
  /// 2. Calls the server API
  /// 3. Updates state with server response
  /// 4. Rolls back if the call fails
  Future<void> toggleLove(int quoteId, bool currentlyLoved) async {
    final repository = ref.read(quotesRepositoryProvider);
    final previousState = state.value;
    if (previousState == null) return;

    // Optimistic update
    final updatedQuotes = previousState.map((q) {
      if (q.id == quoteId) {
        return q.copyWith(
          isLoved: !currentlyLoved,
          loveCount: currentlyLoved
              ? (q.loveCount > 0 ? q.loveCount - 1 : 0)
              : q.loveCount + 1,
        );
      }
      return q;
    }).toList();
    state = AsyncData(updatedQuotes);

    try {
      final int serverLoveCount;
      if (currentlyLoved) {
        serverLoveCount = await repository.unloveQuote(quoteId);
      } else {
        serverLoveCount = await repository.loveQuote(quoteId);
      }

      // Update with server-confirmed love count
      final confirmedQuotes = state.value?.map((q) {
        if (q.id == quoteId) {
          return q.copyWith(loveCount: serverLoveCount);
        }
        return q;
      }).toList();

      if (confirmedQuotes != null) {
        state = AsyncData(confirmedQuotes);
      }
    } catch (e, st) {
      log(
        'QuotesNotifier.toggleLove: failed for quoteId=$quoteId',
        error: e,
        stackTrace: st,
        name: 'QuotesNotifier',
      );

      // Rollback to previous state on failure
      state = AsyncData(previousState);
    }
  }

  /// Manually refreshes the quotes list.
  ///
  /// Shows a loading state, syncs with the server, then reloads
  /// local data. Useful for pull-to-refresh.
  Future<void> refreshQuotes() async {
    state = const AsyncLoading();

    try {
      // Sync first to push/pull latest data
      await _syncData();

      // Reload local data
      state = AsyncData(await _loadLocalQuotes());
    } catch (e, st) {
      log(
        'QuotesNotifier.refreshQuotes: failed',
        error: e,
        stackTrace: st,
        name: 'QuotesNotifier',
      );
      state = AsyncError(e, st);
    }
  }

  // ─── Internal Helpers ─────────────────────────────────────────

  /// Loads all visible quotes from the local SQLite database.
  Future<List<QuoteEntity>> _loadLocalQuotes() async {
    final repository = ref.read(quotesRepositoryProvider);
    return repository.getQuotes();
  }

  /// Runs the full sync cycle in the background without blocking UI.
  ///
  /// After sync completes, silently updates the state with fresh data.
  /// Errors are logged but never thrown to the UI.
  void syncInBackground() {
    Future(() async {
      try {
        // Set state to loading while retaining the current local data
        state = const AsyncLoading<List<QuoteEntity>>();

        await _syncData();
        // Silently refresh state after successful sync
        final freshData = await _loadLocalQuotes();
        state = AsyncData(freshData);
      } catch (e) {
        // Swallow — background sync should never crash the UI
        print('QuotesNotifier.syncInBackground: failed silently, error: $e');
        // Fallback to local database data
        final local = await _loadLocalQuotes();
        state = AsyncData(local);
      }
    });
  }

  /// Executes the sync cycle: pulls the latest data from the server.
  Future<void> _syncData() async {
    final repository = ref.read(quotesRepositoryProvider);
    await repository.syncQuotes();
  }
}
