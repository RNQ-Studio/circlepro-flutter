/// Contract for managing the onboarding status.
abstract class OnboardingRepository {
  /// Returns `true` if the user has already completed the onboarding flow.
  Future<bool> hasCompletedOnboarding();

  /// Persists that the user has completed onboarding.
  Future<void> setOnboardingCompleted();
}
