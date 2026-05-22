import 'package:core/core.dart';
import 'package:features_shared/features_shared.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dev/fake_auth_repository.dart';
import 'router/app_router.dart';

class App extends StatelessWidget {
  const App({super.key, required this.storage});

  final StorageService storage;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storage),
        if (kDebugMode)
          authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
      ],
      child: const _AppRouter(),
    );
  }
}

class _AppRouter extends ConsumerStatefulWidget {
  const _AppRouter();

  @override
  ConsumerState<_AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends ConsumerState<_AppRouter> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authNotifierProvider.notifier).checkCurrentUser();
    });
    ref.listenManual(authNotifierProvider, (_, __) => appRouter.refresh());
  }

  @override
  Widget build(BuildContext context) {
    final themeMode =
        ref.watch(themeNotifierProvider).asData?.value ?? ThemeMode.system;
    final locale = ref.watch(localeNotifierProvider).asData?.value;

    return MaterialApp.router(
      title: 'Flutter Starter Variant',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: appRouter,
    );
  }
}
