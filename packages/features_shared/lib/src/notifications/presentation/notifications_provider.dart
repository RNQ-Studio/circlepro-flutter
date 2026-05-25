import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/repositories/notifications_repository_impl.dart';
import '../domain/repositories/notifications_repository.dart';

part 'notifications_provider.g.dart';

@riverpod
NotificationsRepository notificationsRepository(Ref ref) {
  return const NotificationsRepositoryImpl();
}
