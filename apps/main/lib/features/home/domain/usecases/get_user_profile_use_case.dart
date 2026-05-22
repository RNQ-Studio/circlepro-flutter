import '../entities/user_profile.dart';
import '../repositories/home_repository.dart';

class GetUserProfileUseCase {
  const GetUserProfileUseCase(this._repository);

  final HomeRepository _repository;

  Future<UserProfile> call() => _repository.getUserProfile();
}
