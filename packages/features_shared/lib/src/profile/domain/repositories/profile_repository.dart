import '../entities/profile.dart';

abstract class ProfileRepository {
  /// Membaca profil dari sesi auth yang sedang aktif.
  /// Mengembalikan null jika user belum login.
  Future<Profile?> getProfile();

  /// Memperbarui data profil.
  /// TODO: implementasi via API — Sprint 006 scope hanya read-only.
  Future<void> updateProfile(Profile profile);
}
