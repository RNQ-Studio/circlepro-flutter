class UserProfile {
  const UserProfile({
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
    required this.role,
  });

  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String role;
}
