import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppException.toString', () {
    test('ServerException returns message', () {
      const e = ServerException('Server error');
      expect(e.toString(), 'Server error');
    });

    test('NetworkException returns message', () {
      const e = NetworkException('No connection', statusCode: 503);
      expect(e.toString(), 'No connection');
    });

    test('CacheException returns message', () {
      const e = CacheException('Cache miss');
      expect(e.toString(), 'Cache miss');
    });

    test('UnauthorizedException returns Unauthorized', () {
      const e = UnauthorizedException();
      expect(e.toString(), 'Unauthorized');
    });
  });
}
