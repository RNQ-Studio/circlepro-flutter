class Profile {
  const Profile({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.bio,
  });

  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? bio;
}
