import 'package:features_shared/features_shared.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User', () {
    test('holds id, name, email', () {
      const user = User(id: '1', name: 'Alice', email: 'alice@example.com');
      expect(user.id, '1');
      expect(user.name, 'Alice');
      expect(user.email, 'alice@example.com');
    });
  });
}
