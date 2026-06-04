import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/api/manah_api.dart';
import '../data/monetization_repository.dart';
import '../domain/monetization_entities.dart';

part 'monetization_providers.g.dart';

@Riverpod(keepAlive: true)
MonetizationRepository monetizationRepository(Ref ref) {
  return MonetizationRepository(ref.watch(manahDioProvider));
}

@riverpod
Future<List<SubscriptionPlanEntity>> monetizationPlans(Ref ref) {
  return ref.watch(monetizationRepositoryProvider).fetchPlans();
}

@riverpod
class UserSubscription extends _$UserSubscription {
  @override
  Future<UserSubscriptionStatus> build() {
    return ref.watch(monetizationRepositoryProvider).fetchSubscription();
  }

  Future<void> upgradeWithGooglePlay(String planCode, String purchaseToken) async {
    state = const AsyncLoading();
    final updated = await ref.read(monetizationRepositoryProvider).purchaseGooglePlay(planCode, purchaseToken);
    state = AsyncData(updated);
    ref.invalidate(adsListProvider);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final updated = await ref.read(monetizationRepositoryProvider).fetchSubscription();
    state = AsyncData(updated);
  }
}

@riverpod
Future<List<AdEntity>> adsList(Ref ref, {String placement = 'feed'}) {
  return ref.watch(monetizationRepositoryProvider).fetchAds(placement: placement);
}
