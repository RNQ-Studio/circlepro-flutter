import 'package:features_shared/features_shared.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<UserProfile> getUserProfile() async {
    final user = await _authRepository.getCurrentUser();
    if (user == null) {
      return const UserProfile(
        name: 'Guest',
        email: '-',
        phone: null,
        avatarUrl: null,
        role: 'Guest',
      );
    }

    // Format the first role nicely if available, otherwise default to 'Member'
    String userRole = 'Member';
    if (user.roles.isNotEmpty) {
      final firstRole = user.roles.first.trim();
      if (firstRole.isNotEmpty) {
        userRole = '${firstRole[0].toUpperCase()}${firstRole.substring(1)}';
      }
    }

    return UserProfile(
      name: user.name,
      email: user.email,
      phone: user.phone,
      avatarUrl: user.avatarUrl,
      role: userRole,
    );
  }
}
