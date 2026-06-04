import 'package:dio/dio.dart';
import '../domain/monetization_entities.dart';

class MonetizationRepository {
  const MonetizationRepository(this._dio);

  final Dio _dio;

  Future<List<SubscriptionPlanEntity>> fetchPlans() async {
    final response = await _dio.get('v1/monetization/plans');
    final list = response.data['data'] as List;
    return list.map((item) => SubscriptionPlanEntity.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<UserSubscriptionStatus> fetchSubscription() async {
    final response = await _dio.get('v1/monetization/subscription');
    return UserSubscriptionStatus.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<UserSubscriptionStatus> purchaseGooglePlay(String planCode, String purchaseToken) async {
    await _dio.post(
      'v1/monetization/subscribe/google',
      data: {
        'plan_code': planCode,
        'purchase_token': purchaseToken,
      },
    );
    return fetchSubscription();
  }

  Future<Map<String, dynamic>> purchaseManual(String planCode) async {
    final response = await _dio.post(
      'v1/monetization/subscribe/manual',
      data: {
        'plan_code': planCode,
      },
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<void> purchaseClubSubscription(String clubId, String planCode) async {
    await _dio.post(
      'v1/clubs/$clubId/subscription',
      data: {
        'plan_code': planCode,
      },
    );
  }

  Future<List<AdEntity>> fetchAds({String placement = 'feed'}) async {
    final response = await _dio.get('v1/ads', queryParameters: {'placement': placement});
    final list = response.data['data'] as List;
    return list.map((item) => AdEntity.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<String?> trackAdClick(String adId) async {
    final response = await _dio.post('v1/ads/$adId/click');
    return response.data['data']?['click_url'] as String?;
  }
}
