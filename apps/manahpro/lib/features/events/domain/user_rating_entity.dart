class UserRatingEntity {
  const UserRatingEntity({
    required this.id,
    required this.organizationId,
    required this.userId,
    this.userName,
    this.username,
    this.avatarUrl,
    required this.bowClass,
    required this.gender,
    required this.ageGroup,
    required this.distanceCategory,
    required this.mu,
    required this.phi,
    required this.sigma,
    required this.displayRating,
    required this.status,
    required this.eventsCount,
    this.peakDisplayRating,
    this.lastEventDate,
    required this.title,
    required this.badge,
    required this.color,
  });

  final String id;
  final String organizationId;
  final int userId;
  final String? userName;
  final String? username;
  final String? avatarUrl;
  final String bowClass;
  final String gender;
  final String ageGroup;
  final String distanceCategory;
  final double mu;
  final double phi;
  final double sigma;
  final double displayRating;
  final String status;
  final int eventsCount;
  final double? peakDisplayRating;
  final String? lastEventDate;
  final String title;
  final String badge;
  final String color;
}
