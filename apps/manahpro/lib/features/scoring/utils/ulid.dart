import 'dart:math';

/// Dependency-free ULID + UUIDv4 generators for offline-first IDs.
///
/// The server PK is a 26-char ULID; clients generate it locally so records
/// have a stable identity before any sync. `client_uuid` is a separate UUIDv4
/// idempotency key. See database-design.md §8.
abstract final class Ids {
  static const String _crockford = '0123456789ABCDEFGHJKMNPQRSTVWXYZ';
  static final Random _rng = Random.secure();

  /// Generate a Crockford-base32 ULID (10 chars time + 16 chars randomness).
  static String ulid([DateTime? time]) {
    var ms = (time ?? DateTime.now()).millisecondsSinceEpoch;

    final chars = List<String>.filled(26, '0');

    // 48-bit timestamp → 10 chars.
    for (var i = 9; i >= 0; i--) {
      chars[i] = _crockford[ms & 0x1f];
      ms = ms >> 5;
    }

    // 80-bit randomness → 16 chars.
    for (var i = 10; i < 26; i++) {
      chars[i] = _crockford[_rng.nextInt(32)];
    }

    return chars.join();
  }

  /// Generate a RFC-4122 UUIDv4 string.
  static String uuid() {
    final bytes = List<int>.generate(16, (_) => _rng.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40; // version 4
    bytes[8] = (bytes[8] & 0x3f) | 0x80; // variant 10

    String hex(int start, int end) {
      final buffer = StringBuffer();
      for (var i = start; i < end; i++) {
        buffer.write(bytes[i].toRadixString(16).padLeft(2, '0'));
      }
      return buffer.toString();
    }

    return '${hex(0, 4)}-${hex(4, 6)}-${hex(6, 8)}-${hex(8, 10)}-${hex(10, 16)}';
  }
}
