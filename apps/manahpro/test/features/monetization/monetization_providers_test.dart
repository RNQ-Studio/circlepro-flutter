import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:manahpro/features/monetization/data/monetization_repository.dart';
import 'package:manahpro/features/monetization/presentation/monetization_providers.dart';
import 'package:manahpro/shared/api/manah_api.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
  });

  final dummyPlanJson = {
    'id': 'plan_pro_id',
    'code': 'pro',
    'name': 'Pro Individual',
    'audience': 'user',
    'price': 49000,
    'interval': 'monthly',
    'features': ['Unlimited scoring', 'No ads'],
    'limits': {'max_scoring_sessions_per_week': -1},
    'is_active': true,
    'sort_order': 1,
  };

  final dummySubscriptionJson = {
    'subscription': null,
    'plan_details': {
      'code': 'free',
      'name': 'Free Tier',
    },
    'usage': {
      'scoring_sessions_this_week': 2,
      'scoring_sessions_limit': 3,
      'is_gated': false,
    }
  };

  test('MonetizationRepository parses plans correctly', () async {
    when(() => mockDio.get('v1/monetization/plans')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: 'v1/monetization/plans'),
        data: {
          'success': true,
          'data': [dummyPlanJson],
        },
        statusCode: 200,
      ),
    );

    final repo = MonetizationRepository(mockDio);
    final plans = await repo.fetchPlans();

    expect(plans.length, 1);
    expect(plans.first.code, 'pro');
    expect(plans.first.price, 49000);
    expect(plans.first.features.length, 2);
  });

  test('MonetizationRepository parses subscription status correctly', () async {
    when(() => mockDio.get('v1/monetization/subscription')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: 'v1/monetization/subscription'),
        data: {
          'success': true,
          'data': dummySubscriptionJson,
        },
        statusCode: 200,
      ),
    );

    final repo = MonetizationRepository(mockDio);
    final subStatus = await repo.fetchSubscription();

    expect(subStatus.planCode, 'free');
    expect(subStatus.scoringSessionsThisWeek, 2);
    expect(subStatus.isGated, false);
    expect(subStatus.isPremium, false);
  });

  test('Riverpod userSubscriptionProvider refreshes and upgrades subscription', () async {
    final upgradedSubscriptionJson = {
      'subscription': {
        'id': 'sub_123',
        'status': 'active',
        'provider': 'google_play',
        'current_period_end': '2026-07-05T12:00:00Z',
        'plan': dummyPlanJson,
      },
      'plan_details': {
        'code': 'pro',
        'name': 'Pro Individual',
      },
      'usage': {
        'scoring_sessions_this_week': 2,
        'scoring_sessions_limit': -1,
        'is_gated': false,
      }
    };

    when(() => mockDio.get('v1/monetization/subscription')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: 'v1/monetization/subscription'),
        data: {
          'success': true,
          'data': dummySubscriptionJson,
        },
        statusCode: 200,
      ),
    );

    when(() => mockDio.post('v1/monetization/subscribe/google', data: {
          'plan_code': 'pro',
          'purchase_token': 'mock-token',
        })).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: 'v1/monetization/subscribe/google'),
        data: {
          'success': true,
        },
        statusCode: 200,
      ),
    );

    when(() => mockDio.get('v1/ads', queryParameters: {'placement': 'feed'})).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: 'v1/ads'),
        data: {
          'success': true,
          'data': [],
        },
        statusCode: 200,
      ),
    );

    final container = ProviderContainer(
      overrides: [
        manahDioProvider.overrideWithValue(mockDio),
      ],
    );

    // Initial state
    final initial = await container.read(userSubscriptionProvider.future);
    expect(initial.planCode, 'free');
    expect(initial.isPremium, false);

    // Simulate returning upgraded details on subscription check after upgrade
    when(() => mockDio.get('v1/monetization/subscription')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: 'v1/monetization/subscription'),
        data: {
          'success': true,
          'data': upgradedSubscriptionJson,
        },
        statusCode: 200,
      ),
    );

    // Trigger upgrade
    final notifier = container.read(userSubscriptionProvider.notifier);
    await notifier.upgradeWithGooglePlay('pro', 'mock-token');

    final updated = container.read(userSubscriptionProvider).value!;
    expect(updated.planCode, 'pro');
    expect(updated.isPremium, true);
    expect(updated.subscription?.id, 'sub_123');
    expect(updated.subscription?.status, 'active');
  });
}
