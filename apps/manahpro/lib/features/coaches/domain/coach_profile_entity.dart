import '../../../shared/models/user_simple_entity.dart';

class CoachProfileEntity {
  const CoachProfileEntity({
    required this.id,
    required this.bio,
    required this.specialties,
    this.certification,
    required this.experienceYears,
    required this.hourlyRate,
    this.whatsappNumber,
    required this.isVerified,
    this.availability,
    required this.averageRating,
    required this.reviewsCount,
    required this.user,
    this.createdAt,
  });

  final String id;
  final String bio;
  final List<String> specialties;
  final String? certification;
  final int experienceYears;
  final double hourlyRate;
  final String? whatsappNumber;
  final bool isVerified;
  final List<String>? availability;
  final double averageRating;
  final int reviewsCount;
  final UserSimpleEntity user;
  final DateTime? createdAt;

  factory CoachProfileEntity.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>;
    return CoachProfileEntity(
      id: json['id'] as String,
      bio: json['bio'] as String? ?? '',
      specialties: List<String>.from(json['specialties'] as List<dynamic>? ?? []),
      certification: json['certification'] as String?,
      experienceYears: json['experience_years'] as int? ?? 0,
      hourlyRate: (json['hourly_rate'] as num? ?? 0).toDouble(),
      whatsappNumber: json['whatsapp_number'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      availability: json['availability'] != null
          ? List<String>.from(json['availability'] as List<dynamic>)
          : null,
      averageRating: (json['average_rating'] as num? ?? 0).toDouble(),
      reviewsCount: json['reviews_count'] as int? ?? 0,
      user: UserSimpleEntity.fromJson(userJson),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
}

class CoachReviewEntity {
  const CoachReviewEntity({
    required this.id,
    required this.coachProfileId,
    required this.rating,
    this.comment,
    required this.user,
    this.createdAt,
  });

  final String id;
  final String coachProfileId;
  final int rating;
  final String? comment;
  final UserSimpleEntity user;
  final DateTime? createdAt;

  factory CoachReviewEntity.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>;
    return CoachReviewEntity(
      id: json['id'] as String,
      coachProfileId: json['coach_profile_id'] as String? ?? '',
      rating: json['rating'] as int? ?? 0,
      comment: json['comment'] as String?,
      user: UserSimpleEntity.fromJson(userJson),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
}
