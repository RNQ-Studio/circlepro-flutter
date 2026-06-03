class UserSimpleEntity {
  const UserSimpleEntity({
    required this.id,
    this.fullName,
    this.username,
    this.avatarUrl,
    this.city,
    this.province,
  });

  final int id;
  final String? fullName;
  final String? username;
  final String? avatarUrl;
  final String? city;
  final String? province;

  String get displayName => (fullName?.isNotEmpty ?? false) ? fullName! : (username ?? 'Pemanah');

  String get location => [city, province].where((s) => s != null && s.isNotEmpty).join(', ');

  factory UserSimpleEntity.fromJson(Map<String, dynamic> json) {
    return UserSimpleEntity(
      id: json['id'] as int? ?? 0,
      fullName: json['full_name'] as String?,
      username: json['username'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      city: json['city'] as String?,
      province: json['province'] as String?,
    );
  }
}
