import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  const UpdateProfileUseCase(this._repository);

  final ProfileRepository _repository;

  // TODO: Sprint 006 scope hanya read-only.
  // Usecase ini disiapkan untuk extension di sprint selanjutnya.
  Future<void> call(Profile profile) => _repository.updateProfile(profile);
}
