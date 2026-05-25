import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'app_database.dart';

part 'app_database_provider.g.dart';

/// Provider for the application's Drift database.
///
/// This provider must be overridden at the app scope with a
/// pre-initialized [AppDatabase] instance.
///
/// Example in bootstrap:
/// ```dart
/// final db = AppDatabase();
/// runApp(
///   ProviderScope(
///     overrides: [
///       appDatabaseProvider.overrideWithValue(db),
///     ],
///     child: const MyApp(),
///   ),
/// );
/// ```
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  throw UnimplementedError(
    'appDatabaseProvider must be overridden with a pre-initialized instance',
  );
}
