import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<Profile> getProfile(String userId);
  Future<Profile> updateProfile(Profile profile);
}
