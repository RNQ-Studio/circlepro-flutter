import '../domain/user_rating_entity.dart';

UserRatingEntity userRatingFromJson(Map<String, dynamic> json) {
  return UserRatingEntity(
    id: json['id'] as String,
    organizationId: json['organization_id'] as String? ?? '',
    userId: json['user_id'] as int,
    userName: json['user_name'] as String?,
    username: json['username'] as String?,
    avatarUrl: json['avatar_url'] as String?,
    bowClass: json['bow_class'] as String? ?? '',
    gender: json['gender'] as String? ?? '',
    ageGroup: json['age_group'] as String? ?? '',
    distanceCategory: json['distance_category'] as String? ?? '',
    mu: (json['mu'] as num?)?.toDouble() ?? 1500.0,
    phi: (json['phi'] as num?)?.toDouble() ?? 350.0,
    sigma: (json['sigma'] as num?)?.toDouble() ?? 0.06,
    displayRating: (json['display_rating'] as num?)?.toDouble() ?? 800.0,
    status: json['status'] as String? ?? 'provisional',
    eventsCount: json['events_count'] as int? ?? 0,
    peakDisplayRating: (json['peak_display_rating'] as num?)?.toDouble(),
    lastEventDate: json['last_event_date'] as String?,
    title: json['title'] as String? ?? 'Novice',
    badge: json['badge'] as String? ?? 'Starter',
    color: json['color'] as String? ?? 'default',
  );
}
