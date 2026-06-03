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
    expect(container.read(authProvider), isA<AuthInitial>());
  });

  test('login success → AuthAuthenticated', () async {
    when(() => mockRepo.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => tUser);

    await container
        .read(authProvider.notifier)
        .login(email: 'test@test.com', password: 'password');

    final state = container.read(authProvider);
    expect(state, isA<AuthAuthenticated>());
    expect((state as AuthAuthenticated).user, tUser);
  });

  test('login failure → AuthError with message', () async {
    when(() => mockRepo.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenThrow(const ServerException('Invalid credentials'));

    await container
        .read(authProvider.notifier)
        .login(email: 'wrong@test.com', password: 'wrongpass');

    final state = container.read(authProvider);
    expect(state, isA<AuthError>());
    expect((state as AuthError).message, 'Invalid credentials');
  });

  test('loginWithGoogle success → AuthAuthenticated', () async {
    when(() => mockRepo.loginWithGoogle(
          idToken: any(named: 'idToken'),
        )).thenAnswer((_) async => tUser);

    await container
        .read(authProvider.notifier)
        .loginWithGoogle('valid-id-token');

    final state = container.read(authProvider);
    expect(state, isA<AuthAuthenticated>());
    expect((state as AuthAuthenticated).user, tUser);
  });

  test('loginWithGoogle failure → AuthError with message', () async {
    when(() => mockRepo.loginWithGoogle(
          idToken: any(named: 'idToken'),
        )).thenThrow(const ServerException('Google auth failed'));

    await container
        .read(authProvider.notifier)
        .loginWithGoogle('invalid-id-token');

    final state = container.read(authProvider);
    expect(state, isA<AuthError>());
    expect((state as AuthError).message, 'Google auth failed');
  });

  test('logout → AuthUnauthenticated', () async {
    when(() => mockRepo.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => tUser);
    when(() => mockRepo.logout()).thenAnswer((_) async {});

    await container
        .read(authProvider.notifier)
        .login(email: 'test@test.com', password: 'password');
    await container.read(authProvider.notifier).logout();

    expect(container.read(authProvider), isA<AuthUnauthenticated>());
  });

  test('checkCurrentUser with cached session → AuthAuthenticated', () async {
    when(() => mockRepo.getCurrentUser()).thenAnswer((_) async => tUser);

    await container.read(authProvider.notifier).checkCurrentUser();

    final state = container.read(authProvider);
    expect(state, isA<AuthAuthenticated>());
    expect((state as AuthAuthenticated).user, tUser);
  });

  test('checkCurrentUser with no session → AuthUnauthenticated', () async {
    when(() => mockRepo.getCurrentUser()).thenAnswer((_) async => null);

    await container.read(authProvider.notifier).checkCurrentUser();

    expect(container.read(authProvider), isA<AuthUnauthenticated>());
  });
}
