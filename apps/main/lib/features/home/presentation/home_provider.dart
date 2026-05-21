import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/home_repository_impl.dart';
import '../domain/entities/user_profile.dart';
import '../domain/repositories/home_repository.dart';
import '../domain/usecases/get_user_profile_use_case.dart';

final homeRepositoryProvider = Provider<HomeRepository>(
  (_) => const HomeRepositoryImpl(),
);

final getUserProfileUseCaseProvider = Provider<GetUserProfileUseCase>(
  (ref) => GetUserProfileUseCase(ref.read(homeRepositoryProvider)),
);

final userProfileProvider = FutureProvider<UserProfile>(
  (ref) => ref.read(getUserProfileUseCaseProvider).call(),
);
