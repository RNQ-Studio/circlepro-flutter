import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginWithGoogleUseCase {
  const LoginWithGoogleUseCase(this._repository);

  final AuthRepository _repository;

  Future<User> call({required String idToken}) =>
      _repository.loginWithGoogle(idToken: idToken);
}
