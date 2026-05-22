import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Environment', () {
    test('fromString returns dev for unknown value', () {
      expect(Environment.fromString('unknown'), Environment.dev);
    });

    test('fromString returns staging', () {
      expect(Environment.fromString('staging'), Environment.staging);
    });

    test('fromString returns prod', () {
      expect(Environment.fromString('prod'), Environment.prod);
    });
  });
}
