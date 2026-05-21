import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl();

  @override
  Future<Profile> getProfile(String userId) {
    throw UnimplementedError('ProfileRepositoryImpl.getProfile not yet implemented');
  }

  @override
  Future<Profile> updateProfile(Profile profile) {
    throw UnimplementedError('ProfileRepositoryImpl.updateProfile not yet implemented');
  }
}
