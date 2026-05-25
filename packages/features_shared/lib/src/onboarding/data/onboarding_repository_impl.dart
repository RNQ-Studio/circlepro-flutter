import 'package:core/core.dart';

import '../domain/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(this._storage);

  final SharedPreferencesStorage _storage;

  @override
  Future<bool> hasCompletedOnboarding() async {
    final value = await _storage.read(AppConstants.keyOnboardingCompleted);
    return value == 'true';
  }

  @override
  Future<void> setOnboardingCompleted() async {
    await _storage.write(AppConstants.keyOnboardingCompleted, 'true');
  }
}
