import 'package:core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/onboarding_repository_impl.dart';
import '../domain/onboarding_repository.dart';

part 'onboarding_notifier.g.dart';

@riverpod
Future<OnboardingRepository> onboardingRepository(Ref ref) async {
  final storage = SharedPreferencesStorage();
  await storage.init();
  return OnboardingRepositoryImpl(storage);
}

@riverpod
class OnboardingNotifier extends _$OnboardingNotifier {
  @override
  Future<bool> build() async {
    final repo = await ref.watch(onboardingRepositoryProvider.future);
    return repo.hasCompletedOnboarding();
  }

  /// Mark onboarding as completed and navigate away.
  Future<void> completeOnboarding() async {
    final repo = await ref.read(onboardingRepositoryProvider.future);
    await repo.setOnboardingCompleted();
    state = const AsyncData(true);
  }
}
