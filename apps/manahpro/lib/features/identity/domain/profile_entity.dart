import '../../scoring/domain/scoring_enums.dart';

/// Athletic stats summary shown on a profile.
class ProfileStats {
  const ProfileStats({
    this.totalSessions = 0,
    this.totalArrows = 0,
    this.totalScore = 0,
    this.personalBests = 0,
  });

  final int totalSessions;
  final int totalArrows;
  final int totalScore;
  final int personalBests;

  factory ProfileStats.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ProfileStats();
    return ProfileStats(
      totalSessions: json['total_sessions'] as int? ?? 0,
      totalArrows: json['total_arrows'] as int? ?? 0,
      totalScore: json['total_score'] as int? ?? 0,
      personalBests: json['personal_bests'] as int? ?? 0,
    );
  }
}

/// Merged identity + athletic profile (mirrors backend ProfileResource).
class ProfileEntity {
  const ProfileEntity({
    required this.id,
    this.username,
    this.fullName,
    this.email,
    this.phone,
    this.avatarUrl,
    this.bannerUrl,
    this.bio,
    this.gender,
    this.birthDate,
    this.ageGroup,
    this.province,
    this.city,
    this.primaryBowClass,
    this.homeClubId,
    this.peakTitle,
    this.stats = const ProfileStats(),
  });

  final int id;
  final String? username;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? avatarUrl;
  final String? bannerUrl;
  final String? bio;
  final String? gender;
  final String? birthDate;
  final String? ageGroup;
  final String? province;
  final String? city;
  final BowClass? primaryBowClass;
  final String? homeClubId;
  final String? peakTitle;
  final ProfileStats stats;

  String get displayName => (fullName?.isNotEmpty ?? false) ? fullName! : (username ?? 'Pemanah');

  factory ProfileEntity.fromJson(Map<String, dynamic> json) {
    return ProfileEntity(
      id: json['id'] as int,
      username: json['username'] as String?,
      fullName: json['full_name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      bannerUrl: json['banner_url'] as String?,
      bio: json['bio'] as String?,
      gender: json['gender'] as String?,
      birthDate: json['birth_date'] as String?,
      ageGroup: json['age_group'] as String?,
      province: json['province'] as String?,
      city: json['city'] as String?,
      primaryBowClass:
          json['primary_bow_class'] != null ? BowClass.fromValue(json['primary_bow_class'] as String) : null,
      homeClubId: json['home_club_id'] as String?,
      peakTitle: json['peak_title'] as String?,
      stats: ProfileStats.fromJson(json['stats'] as Map<String, dynamic>?),
    );
  }
}
