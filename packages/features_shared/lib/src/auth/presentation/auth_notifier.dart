import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/usecases/get_current_user_use_case.dart';
import '../domain/usecases/login_use_case.dart';
import '../domain/usecases/logout_use_case.dart';
import '../domain/usecases/register_use_case.dart';
import 'auth_repository_provider.dart';
import 'auth_state.dart';

class AuthNotifier extends Notifier<AuthState> {
  late GetCurrentUserUseCase _getCurrentUser;
  late LoginUseCase _login;
  late LogoutUseCase _logout;
  late RegisterUseCase _register;

  @override
  AuthState build() {
    final repo = ref.watch(authRepositoryProvider);
    _getCurrentUser = GetCurrentUserUseCase(repo);
    _login = LoginUseCase(repo);
    _logout = LogoutUseCase(repo);
    _register = RegisterUseCase(repo);
    return const AuthInitial();
  }

  /// Call this once during app bootstrap to restore a cached session.
  Future<void> checkCurrentUser() async {
    state = const AuthLoading();
    try {
      final user = await _getCurrentUser();
      state = user != null ? AuthAuthenticated(user) : const AuthUnauthenticated();
    } on Exception catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = const AuthLoading();
    try {
      final user = await _login(email: email, password: password);
      state = AuthAuthenticated(user);
    } on Exception catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();
    try {
      final user = await _register(name: name, email: email, password: password);
      state = AuthAuthenticated(user);
    } on Exception catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> logout() async {
    state = const AuthLoading();
    try {
      await _logout();
      state = const AuthUnauthenticated();
    } on Exception catch (e) {
      state = AuthError(e.toString());
    }
  }
}

final authNotifierProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
