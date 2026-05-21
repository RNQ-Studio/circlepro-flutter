import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'settings_screen.dart';

final settingsRoute = GoRoute(
  path: AppRoutes.settings,
  builder: (context, state) => const SettingsScreen(),
);
