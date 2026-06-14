import 'package:core/core.dart';

import '../domain/join_link.dart';

/// Persists a pending join code across an unauthenticated gap so the deferred
/// deep link can resume after the user registers / logs in (task 9.4).
///
/// When a deep link arrives while the user is signed out, the code is stashed
/// here; once auth succeeds it is consumed and the app navigates to the session
/// preview. Backed by the shared [StorageService] so it survives a cold start.
class PendingJoinStore {
  const PendingJoinStore(this._storage);

  static const String _key = 'pending_join_code';

  final StorageService _storage;

  /// Stash a (normalized) pending join code, ignoring anything unparseable.
  Future<void> save(String code) async {
    final normalized = JoinLink.parseCode(code);
    if (normalized == null) return;
    await _storage.write(_key, normalized);
  }

  /// Read the pending code, if any.
  Future<String?> read() => _storage.read(_key);

  /// Clear the pending code once consumed.
  Future<void> clear() => _storage.delete(_key);
}
