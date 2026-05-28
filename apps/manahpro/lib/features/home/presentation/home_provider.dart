import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:features_shared/features_shared.dart';

import '../data/repositories/home_repository_impl.dart';
import '../domain/entities/user_profile.dart';
import '../domain/repositories/home_repository.dart';
import '../domain/usecases/get_user_profile_use_case.dart';

part 'home_provider.g.dart';

@riverpod
HomeRepository homeRepository(Ref ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return HomeRepositoryImpl(authRepo);
}

@riverpod
GetUserProfileUseCase getUserProfileUseCase(Ref ref) {
  return GetUserProfileUseCase(ref.read(homeRepositoryProvider));
}

@riverpod
Future<UserProfile> userProfile(Ref ref) {
  // Watch authProvider so it automatically invalidates/rebuilds when authState changes
  ref.watch(authProvider);
  return ref.read(getUserProfileUseCaseProvider).call();
}
