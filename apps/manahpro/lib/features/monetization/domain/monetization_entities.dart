class SubscriptionPlanEntity {
  const SubscriptionPlanEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.audience,
    required this.price,
    required this.interval,
    required this.features,
    required this.limits,
    required this.isActive,
    required this.sortOrder,
  });

  factory SubscriptionPlanEntity.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanEntity(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      audience: json['audience'] as String,
      price: json['price'] as int,
      interval: json['interval'] as String,
      features: (json['features'] as List?)?.map((e) => e as String).toList() ?? [],
      limits: json['limits'] as Map<String, dynamic>? ?? {},
      isActive: json['is_active'] as bool? ?? true,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  final String id;
  final String code;
  final String name;
  final String audience;
  final int price;
  final String interval;
  final List<String> features;
  final Map<String, dynamic> limits;
  final bool isActive;
  final int sortOrder;

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
        'audience': audience,
        'price': price,
        'interval': interval,
        'features': features,
        'limits': limits,
        'is_active': isActive,
        'sort_order': sortOrder,
      };
}

class SubscriptionEntity {
  const SubscriptionEntity({
    required this.id,
    required this.status,
    required this.provider,
    this.currentPeriodEnd,
    required this.plan,
  });

  factory SubscriptionEntity.fromJson(Map<String, dynamic> json) {
    return SubscriptionEntity(
      id: json['id'] as String,
      status: json['status'] as String,
      provider: json['provider'] as String,
      currentPeriodEnd: json['current_period_end'] != null
          ? DateTime.parse(json['current_period_end'] as String)
          : null,
      plan: SubscriptionPlanEntity.fromJson(json['plan'] as Map<String, dynamic>),
    );
  }

  final String id;
  final String status;
  final String provider;
  final DateTime? currentPeriodEnd;
  final SubscriptionPlanEntity plan;

  bool get isActive => status == 'active' || status == 'trialing';

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'provider': provider,
        'current_period_end': currentPeriodEnd?.toIso8601String(),
        'plan': plan.toJson(),
      };
}

class UserSubscriptionStatus {
  const UserSubscriptionStatus({
    this.subscription,
    required this.planCode,
    required this.planName,
    required this.scoringSessionsThisWeek,
    required this.scoringSessionsLimit,
    required this.isGated,
  });

  factory UserSubscriptionStatus.fromJson(Map<String, dynamic> json) {
    final subJson = json['subscription'];
    final detailsJson = json['plan_details'] as Map<String, dynamic>;
    final usageJson = json['usage'] as Map<String, dynamic>;

    return UserSubscriptionStatus(
      subscription: subJson != null
          ? SubscriptionEntity.fromJson(subJson as Map<String, dynamic>)
          : null,
      planCode: detailsJson['code'] as String,
      planName: detailsJson['name'] as String,
      scoringSessionsThisWeek: usageJson['scoring_sessions_this_week'] as int,
      scoringSessionsLimit: usageJson['scoring_sessions_limit'] as int,
      isGated: usageJson['is_gated'] as bool? ?? false,
    );
  }

  final SubscriptionEntity? subscription;
  final String planCode;
  final String planName;
  final int scoringSessionsThisWeek;
  final int scoringSessionsLimit;
  final bool isGated;

  bool get isPremium => planCode != 'free';
}

class AdEntity {
  const AdEntity({
    required this.id,
    required this.adCampaignId,
    required this.placement,
    this.imageUrl,
    this.title,
    this.body,
    this.clickUrl,
  });

  factory AdEntity.fromJson(Map<String, dynamic> json) {
    return AdEntity(
      id: json['id'] as String,
      adCampaignId: json['ad_campaign_id'] as String,
      placement: json['placement'] as String,
      imageUrl: json['image_url'] as String?,
      title: json['title'] as String?,
      body: json['body'] as String?,
      clickUrl: json['click_url'] as String?,
    );
  }

  final String id;
  final String adCampaignId;
  final String placement;
  final String? imageUrl;
  final String? title;
  final String? body;
  final String? clickUrl;

  Map<String, dynamic> toJson() => {
        'id': id,
        'ad_campaign_id': adCampaignId,
        'placement': placement,
        'image_url': imageUrl,
        'title': title,
        'body': body,
        'click_url': clickUrl,
      };
}
