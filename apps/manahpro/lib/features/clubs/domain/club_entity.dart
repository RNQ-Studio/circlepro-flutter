/// A club (organization type=club) as seen by the app.
class ClubEntity {
  const ClubEntity({
    required this.id,
    required this.name,
    this.slug,
    this.description,
    this.logoUrl,
    this.bannerUrl,
    this.province,
    this.city,
    this.address,
    this.isVerified = false,
    this.memberCount = 0,
    this.myRole,
    this.isMember = false,
  });

  final String id;
  final String name;
  final String? slug;
  final String? description;
  final String? logoUrl;
  final String? bannerUrl;
  final String? province;
  final String? city;
  final String? address;
  final bool isVerified;
  final int memberCount;
  final String? myRole;
  final bool isMember;

  bool get isAdmin => myRole == 'owner' || myRole == 'admin';

  String get location =>
      [city, province].where((s) => s != null && s.isNotEmpty).join(', ');

  factory ClubEntity.fromJson(Map<String, dynamic> json) {
    return ClubEntity(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      logoUrl: json['logo_url'] as String?,
      bannerUrl: json['banner_url'] as String?,
      province: json['province'] as String?,
      city: json['city'] as String?,
      address: json['address'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      memberCount: json['member_count'] as int? ?? 0,
      myRole: json['my_role'] as String?,
      isMember: json['is_member'] as bool? ?? false,
    );
  }
}

/// A club membership row.
class ClubMemberEntity {
  const ClubMemberEntity({
    required this.id,
    required this.userId,
    this.fullName,
    this.username,
    this.avatarUrl,
    required this.role,
    this.status,
  });

  final String id;
  final int? userId;
  final String? fullName;
  final String? username;
  final String? avatarUrl;
  final String role;
  final String? status;

  factory ClubMemberEntity.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    return ClubMemberEntity(
      id: json['id'] as String,
      userId: user?['id'] as int?,
      fullName: user?['full_name'] as String?,
      username: user?['username'] as String?,
      avatarUrl: user?['avatar_url'] as String?,
      role: json['role'] as String? ?? 'member',
      status: json['status'] as String?,
    );
  }
}
