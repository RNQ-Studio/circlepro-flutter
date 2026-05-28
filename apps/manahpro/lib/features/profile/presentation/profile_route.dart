import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:features_shared/features_shared.dart';

final profileRoute = GoRoute(
  path: AppRoutes.profile,
  builder: (context, state) => const ProfileScreen(),
  routes: [
    GoRoute(
      path: 'edit',
      builder: (context, state) => const EditProfileScreen(),
    ),
  ],
);
