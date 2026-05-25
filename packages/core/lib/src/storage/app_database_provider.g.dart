// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

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

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
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
  AppDatabaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'appDatabaseProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'925cb211ff94d31a32cfb1079f7ba3c2be7962ed';
