import '../entities/user_profile.dart';

abstract interface class HomeRepository {
  Future<UserProfile> getUserProfile();
}
