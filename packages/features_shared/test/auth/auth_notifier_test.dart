import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:features_shared/features_shared.dart';
import 'package:core/core.dart';

import 'mock_auth_repository.dart';

void main() {
  late MockAuthRepository mockRepo;
  late ProviderContainer container;

  const tUser = User(id: '1', name: 'Test', email: 'test@test.com');

  setUp(() {
    mockRepo = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() => container.dispose());

  test('initial state is AuthInitial', () {
    expect(container.read(authNotifierProvider), isA<AuthInitial>());
  });

  test('login success → AuthAuthenticated', () async {
    when(() => mockRepo.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => tUser);

    await container
        .read(authNotifierProvider.notifier)
        .login(email: 'test@test.com', password: 'password');

    final state = container.read(authNotifierProvider);
    expect(state, isA<AuthAuthenticated>());
    expect((state as AuthAuthenticated).user, tUser);
  });

  test('login failure → AuthError with message', () async {
    when(() => mockRepo.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenThrow(const ServerException('Invalid credentials'));

    await container
        .read(authNotifierProvider.notifier)
        .login(email: 'wrong@test.com', password: 'wrongpass');

    final state = container.read(authNotifierProvider);
    expect(state, isA<AuthError>());
    expect((state as AuthError).message, 'Invalid credentials');
  });

  test('logout → AuthUnauthenticated', () async {
    when(() => mockRepo.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => tUser);
    when(() => mockRepo.logout()).thenAnswer((_) async {});

    await container
        .read(authNotifierProvider.notifier)
        .login(email: 'test@test.com', password: 'password');
    await container.read(authNotifierProvider.notifier).logout();

    expect(container.read(authNotifierProvider), isA<AuthUnauthenticated>());
  });

  test('checkCurrentUser with cached session → AuthAuthenticated', () async {
    when(() => mockRepo.getCurrentUser()).thenAnswer((_) async => tUser);

    await container.read(authNotifierProvider.notifier).checkCurrentUser();

    final state = container.read(authNotifierProvider);
    expect(state, isA<AuthAuthenticated>());
    expect((state as AuthAuthenticated).user, tUser);
  });

  test('checkCurrentUser with no session → AuthUnauthenticated', () async {
    when(() => mockRepo.getCurrentUser()).thenAnswer((_) async => null);

    await container.read(authNotifierProvider.notifier).checkCurrentUser();

    expect(container.read(authNotifierProvider), isA<AuthUnauthenticated>());
  });
}
