import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/profile_repository_impl.dart';
import '../domain/entities/profile.dart';
import '../domain/repositories/profile_repository.dart';
import '../domain/usecases/get_profile_use_case.dart';
import '../../auth/presentation/auth_repository_provider.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepositoryImpl(ref.watch(authRepositoryProvider)),
);

final profileProvider = FutureProvider<Profile?>((ref) {
  final repo = ref.watch(profileRepositoryProvider);
  return GetProfileUseCase(repo)();
});
