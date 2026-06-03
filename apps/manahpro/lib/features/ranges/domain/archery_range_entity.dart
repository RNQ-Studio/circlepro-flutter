class ArcheryRangeEntity {
  const ArcheryRangeEntity({
    required this.id,
    required this.name,
    this.description,
    this.address,
    this.city,
    this.province,
    this.latitude,
    this.longitude,
    required this.facilities,
    this.phone,
    required this.pricePerHour,
    this.imageUrl,
    this.distance,
    this.createdAt,
  });

  final String id;
  final String name;
  final String? description;
  final String? address;
  final String? city;
  final String? province;
  final double? latitude;
  final double? longitude;
  final List<String> facilities;
  final String? phone;
  final double pricePerHour;
  final String? imageUrl;
  final double? distance;
  final DateTime? createdAt;

  String get location => [city, province].where((s) => s != null && s.isNotEmpty).join(', ');

  factory ArcheryRangeEntity.fromJson(Map<String, dynamic> json) {
    return ArcheryRangeEntity(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      province: json['province'] as String?,
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
      facilities: List<String>.from(json['facilities'] as List<dynamic>? ?? []),
      phone: json['phone'] as String?,
      pricePerHour: (json['price_per_hour'] as num? ?? 0).toDouble(),
      imageUrl: json['image_url'] as String?,
      distance: json['distance'] != null ? (json['distance'] as num).toDouble() : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
}
