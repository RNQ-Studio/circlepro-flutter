import 'package:go_router/go_router.dart';

import 'login_screen.dart';

const authLoginPath = '/login';

final List<GoRoute> authRoutes = [
  GoRoute(
    path: authLoginPath,
    builder: (context, state) => const LoginScreen(),
  ),
];
