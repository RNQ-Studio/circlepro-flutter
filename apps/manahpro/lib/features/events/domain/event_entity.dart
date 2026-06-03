import 'package:equatable/equatable.dart';
import 'event_division_entity.dart';
import 'event_enums.dart';

class EventEntity extends Equatable {
  const EventEntity({
    required this.id,
    required this.organizationId,
    this.organizationName,
    this.organizationLogo,
    required this.createdBy,
    required this.title,
    required this.slug,
    this.description,
    this.bannerUrl,
    required this.tier,
    required this.format,
    required this.status,
    this.province,
    this.city,
    this.venueName,
    this.address,
    this.latitude,
    this.longitude,
    required this.startsAt,
    this.endsAt,
    this.registrationOpensAt,
    this.registrationClosesAt,
    this.capacity,
    this.schedule,
    this.rules,
    required this.isExternal,
    this.publishedAt,
    this.divisions = const [],
  });

  final String id;
  final String organizationId;
  final String? organizationName;
  final String? organizationLogo;
  final int createdBy;
  final String title;
  final String slug;
  final String? description;
  final String? bannerUrl;
  final EventTier tier;
  final EventFormat format;
  final EventStatus status;
  final String? province;
  final String? city;
  final String? venueName;
  final String? address;
  final double? latitude;
  final double? longitude;
  final DateTime startsAt;
  final DateTime? endsAt;
  final DateTime? registrationOpensAt;
  final DateTime? registrationClosesAt;
  final int? capacity;
  final List<dynamic>? schedule; // schedule structure
  final String? rules;
  final bool isExternal;
  final DateTime? publishedAt;
  final List<EventDivisionEntity> divisions;

  String get locationLabel {
    if (venueName != null && city != null) {
      return '$venueName, $city';
    }
    return venueName ?? city ?? province ?? 'Online / Lokasi Belum Ditentukan';
  }

  bool get isRegistrationOpen {
    final now = DateTime.now();
    if (status != EventStatus.registrationOpen) return false;
    if (registrationOpensAt != null && now.isBefore(registrationOpensAt!)) return false;
    if (registrationClosesAt != null && now.isAfter(registrationClosesAt!)) return false;
    return true;
  }

  @override
  List<Object?> get props => [
        id,
        organizationId,
        organizationName,
        organizationLogo,
        createdBy,
        title,
        slug,
        description,
        bannerUrl,
        tier,
        format,
        status,
        province,
        city,
        venueName,
        address,
        latitude,
        longitude,
        startsAt,
        endsAt,
        registrationOpensAt,
        registrationClosesAt,
        capacity,
        schedule,
        rules,
        isExternal,
        publishedAt,
        divisions,
      ];
}
