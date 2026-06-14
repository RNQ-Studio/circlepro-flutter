import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:features_shared/features_shared.dart';

import 'router/app_router.dart';
import 'shared/deep_link/deep_link_coordinator.dart';
import 'theme/manah_theme.dart';

class App extends StatelessWidget {
  const App({super.key, required this.storage, required this.database});

  final StorageService storage;
  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storage),
        appDatabaseProvider.overrideWithValue(database),
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
      ref.read(authProvider.notifier).checkCurrentUser();
    });
    // Start capturing Latihan Bersama invite deep links (Sprint 09).
    ref.read(deepLinkCoordinatorProvider);
    ref.listenManual<AuthState>(authProvider, (previous, next) {
      appRouter.refresh();
      // Resume a pending / deferred invite once the user is authenticated
      // (task 9.4): the stashed code becomes a navigation to the preview.
      if (next is AuthAuthenticated) {
        ref.read(deepLinkCoordinatorProvider.notifier).consumePending();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode =
        ref.watch(themeProvider).asData?.value ?? ThemeMode.system;
    final locale = ref.watch(localeProvider).asData?.value;

    return MaterialApp.router(
      title: 'ManahPro',
      theme: ManahTheme.light,
      darkTheme: ManahTheme.dark,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: appRouter,
    );
  }
}
