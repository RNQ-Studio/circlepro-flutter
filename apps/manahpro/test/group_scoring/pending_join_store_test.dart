import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manahpro/features/group_scoring/data/pending_join_store.dart';

/// In-memory [StorageService] so the deferred-link persistence is testable
/// without platform plugins.
class _FakeStorage implements StorageService {
  final Map<String, String> _map = {};

  @override
  Future<void> init() async {}

  @override
  Future<void> write(String key, String value) async => _map[key] = value;

  @override
  Future<String?> read(String key) async => _map[key];

  @override
  Future<void> delete(String key) async => _map.remove(key);

  @override
  Future<void> clear() async => _map.clear();
}

void main() {
  group('PendingJoinStore', () {
    late PendingJoinStore store;

    setUp(() => store = PendingJoinStore(_FakeStorage()));

    test('saves a normalized code and reads it back', () async {
      await store.save('abc234');
      expect(await store.read(), 'ABC234');
    });

    test('extracts the code when an invite link is stashed', () async {
      await store.save('https://circlepro.web.id/j/abc234');
      expect(await store.read(), 'ABC234');
    });

    test('ignores unparseable input', () async {
      await store.save('!!!');
      expect(await store.read(), isNull);
    });

    test('clears the pending code once consumed', () async {
      await store.save('abc234');
      await store.clear();
      expect(await store.read(), isNull);
    });
  });
}
