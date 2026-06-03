class BadgeEntity {
  const BadgeEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.iconCode,
    required this.requirementType,
    required this.requirementValue,
    required this.unlocked,
    this.unlockedAt,
  });

  final String id;
  final String name;
  final String description;
  final String iconCode;
  final String requirementType;
  final int requirementValue;
  final bool unlocked;
  final DateTime? unlockedAt;

  factory BadgeEntity.fromJson(Map<String, dynamic> json) {
    return BadgeEntity(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      iconCode: json['icon_code'] as String? ?? 'military_tech',
      requirementType: json['requirement_type'] as String? ?? '',
      requirementValue: json['requirement_value'] as int? ?? 0,
      unlocked: json['unlocked'] as bool? ?? false,
      unlockedAt: json['unlocked_at'] != null ? DateTime.parse(json['unlocked_at'] as String) : null,
    );
  }
}

class UserStatsEntity {
  const UserStatsEntity({
    required this.xp,
    required this.level,
    required this.currentStreak,
    required this.longestStreak,
    this.lastSessionAt,
    required this.badges,
  });

  final int xp;
  final int level;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastSessionAt;
  final List<BadgeEntity> badges;

  factory UserStatsEntity.fromJson(Map<String, dynamic> json) {
    final badgesList = json['badges'] as List<dynamic>? ?? [];
    return UserStatsEntity(
      xp: json['xp'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      currentStreak: json['current_streak'] as int? ?? 0,
      longestStreak: json['longest_streak'] as int? ?? 0,
      lastSessionAt: json['last_session_at'] != null ? DateTime.parse(json['last_session_at'] as String) : null,
      badges: badgesList.map((e) => BadgeEntity.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
