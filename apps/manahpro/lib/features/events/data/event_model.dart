import '../../scoring/domain/scoring_enums.dart';
import '../domain/event_division_entity.dart';
import '../domain/event_entity.dart';
import '../domain/event_enums.dart';

EventDivisionEntity eventDivisionFromJson(Map<String, dynamic> json) {
  return EventDivisionEntity(
    id: json['id'] as String,
    eventId: json['event_id'] as String,
    bowClass: BowClass.fromValue(json['bow_class'] as String?),
    gender: Gender.fromValue(json['gender'] as String?),
    ageGroup: AgeGroup.fromValue(json['age_group'] as String?),
    distanceCategory: DistanceCategory.fromValue(json['distance_category'] as String?),
    distanceM: json['distance_m'] as int,
    numArrows: json['num_arrows'] as int,
    maxScore: json['max_score'] as int,
    entryFee: json['entry_fee'] as int,
    capacity: json['capacity'] as int?,
    numParticipants: json['num_participants'] as int? ?? 0,
    sofAvgRating: json['sof_avg_rating'] != null ? double.tryParse(json['sof_avg_rating'].toString()) : null,
    ratingStatus: json['rating_status'] as String? ?? 'unrated',
    ratedAt: json['rated_at'] != null ? DateTime.parse(json['rated_at'] as String) : null,
  );
}

Map<String, dynamic> eventDivisionToJson(EventDivisionEntity d) {
  return {
    'id': d.id,
    'event_id': d.eventId,
    'bow_class': d.bowClass.value,
    'gender': d.gender.value,
    'age_group': d.ageGroup.value,
    'distance_category': d.distanceCategory.value,
    'distance_m': d.distanceM,
    'num_arrows': d.numArrows,
    'max_score': d.maxScore,
    'entry_fee': d.entryFee,
    if (d.capacity != null) 'capacity': d.capacity,
  };
}

EventEntity eventFromJson(Map<String, dynamic> json) {
  final divisionsJson = json['divisions'] as List<dynamic>? ?? [];
  final divisions = divisionsJson
      .map((d) => eventDivisionFromJson(d as Map<String, dynamic>))
      .toList();

  return EventEntity(
    id: json['id'] as String,
    organizationId: json['organization_id'] as String,
    organizationName: json['organization_name'] as String?,
    organizationLogo: json['organization_logo'] as String?,
    createdBy: json['created_by'] as int,
    title: json['title'] as String,
    slug: json['slug'] as String,
    description: json['description'] as String?,
    bannerUrl: json['banner_url'] as String?,
    tier: EventTier.fromValue(json['tier'] as String?),
    format: EventFormat.fromValue(json['format'] as String?),
    status: EventStatus.fromValue(json['status'] as String?),
    province: json['province'] as String?,
    city: json['city'] as String?,
    venueName: json['venue_name'] as String?,
    address: json['address'] as String?,
    latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
    longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
    startsAt: DateTime.parse(json['starts_at'] as String),
    endsAt: json['ends_at'] != null ? DateTime.parse(json['ends_at'] as String) : null,
    registrationOpensAt: json['registration_opens_at'] != null
        ? DateTime.parse(json['registration_opens_at'] as String)
        : null,
    registrationClosesAt: json['registration_closes_at'] != null
        ? DateTime.parse(json['registration_closes_at'] as String)
        : null,
    capacity: json['capacity'] as int?,
    schedule: json['schedule'] as List<dynamic>?,
    rules: json['rules'] as String?,
    isExternal: json['is_external'] as bool? ?? false,
    publishedAt: json['published_at'] != null ? DateTime.parse(json['published_at'] as String) : null,
    divisions: divisions,
  );
}

Map<String, dynamic> eventToJson(EventEntity e) {
  return {
    'id': e.id,
    'organization_id': e.organizationId,
    'title': e.title,
    'slug': e.slug,
    if (e.description != null) 'description': e.description,
    if (e.bannerUrl != null) 'banner_url': e.bannerUrl,
    'tier': e.tier.value,
    'format': e.format.value,
    'status': e.status.value,
    if (e.province != null) 'province': e.province,
    if (e.city != null) 'city': e.city,
    if (e.venueName != null) 'venue_name': e.venueName,
    if (e.address != null) 'address': e.address,
    if (e.latitude != null) 'latitude': e.latitude,
    if (e.longitude != null) 'longitude': e.longitude,
    'starts_at': e.startsAt.toUtc().toIso8601String(),
    if (e.endsAt != null) 'ends_at': e.endsAt!.toUtc().toIso8601String(),
    if (e.registrationOpensAt != null)
      'registration_opens_at': e.registrationOpensAt!.toUtc().toIso8601String(),
    if (e.registrationClosesAt != null)
      'registration_closes_at': e.registrationClosesAt!.toUtc().toIso8601String(),
    if (e.capacity != null) 'capacity': e.capacity,
    if (e.schedule != null) 'schedule': e.schedule,
    if (e.rules != null) 'rules': e.rules,
    'is_external': e.isExternal,
    'divisions': e.divisions.map((d) => eventDivisionToJson(d)).toList(),
  };
}
