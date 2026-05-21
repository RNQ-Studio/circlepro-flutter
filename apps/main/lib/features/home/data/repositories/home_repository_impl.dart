// TODO: Ganti dengan data dari auth session / profile API saat project di-fork
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl();

  @override
  Future<UserProfile> getUserProfile() async => const UserProfile(
        name: 'Fulan bin Fulanah',
        email: 'fulan@example.com',
        gender: 'Putra',
        age: '32',
        city: 'Kota Surabaya',
      );
}
