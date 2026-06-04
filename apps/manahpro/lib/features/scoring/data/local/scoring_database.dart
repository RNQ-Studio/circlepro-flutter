import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'scoring_database.g.dart';

/// Local scoring session (offline-first). PK [id] is a client-generated ULID;
/// [clientUuid] is the idempotency key for server sync. Aggregates are cached
/// locally for instant dashboards. See database-design.md §8.
class ScoringSessionRows extends Table {
  TextColumn get id => text()();
  TextColumn get clientUuid => text()();
  TextColumn get equipmentProfileId => text().nullable()();
  TextColumn get title => text().nullable()();
  TextColumn get bowClass => text()();
  TextColumn get distanceCategory => text()();
  IntColumn get distanceM => integer()();
  TextColumn get environment => text().withDefault(const Constant('outdoor'))();
  IntColumn get targetFaceCm => integer().nullable()();
  TextColumn get targetFaceId => text().nullable()();
  IntColumn get numEnds => integer()();
  IntColumn get arrowsPerEnd => integer()();
  TextColumn get status => text().withDefault(const Constant('in_progress'))();
  IntColumn get totalScore => integer().withDefault(const Constant(0))();
  IntColumn get arrowsShot => integer().withDefault(const Constant(0))();
  IntColumn get xCount => integer().withDefault(const Constant(0))();
  IntColumn get tenCount => integer().withDefault(const Constant(0))();
  IntColumn get missCount => integer().withDefault(const Constant(0))();
  BoolColumn get isPersonalBest => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get source => text().withDefault(const Constant('mobile'))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  /// Pending sync action: 'create' | 'update' | 'delete' | null.
  TextColumn get syncAction => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ScoringEndRows extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text()();
  IntColumn get endNumber => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class ScoringArrowRows extends Table {
  TextColumn get id => text()();
  TextColumn get endId => text()();
  IntColumn get arrowIndex => integer()();
  IntColumn get scoreValue => integer()();
  BoolColumn get isX => boolean().withDefault(const Constant(false))();
  BoolColumn get isMiss => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class TargetFaceRows extends Table {
  TextColumn get id => text()();
  TextColumn get organizationId => text().nullable()();
  TextColumn get organizationName => text().nullable()();
  TextColumn get organizationSlug => text().nullable()();
  TextColumn get code => text().unique()();
  TextColumn get name => text()();
  TextColumn get imagePath => text().nullable()();
  TextColumn get scoringRulesJson => text()(); // Store rules as JSON string
  IntColumn get usedCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Dedicated offline database for ManahPro scoring (separate from the shared
/// `core` AppDatabase so the domain stays app-level).
@DriftDatabase(tables: [ScoringSessionRows, ScoringEndRows, ScoringArrowRows, TargetFaceRows])
class ScoringDatabase extends _$ScoringDatabase {
  ScoringDatabase([QueryExecutor? executor]) : super(executor ?? _open());

  @override
  int get schemaVersion => 8; // Bump version to trigger upgrade and reset tables

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // Destructive migration for development: drop all tables and start fresh
          await m.drop(scoringArrowRows);
          await m.drop(scoringEndRows);
          await m.drop(scoringSessionRows);
          await m.drop(targetFaceRows);
          await m.createAll();
        },
      );

  static QueryExecutor _open() => driftDatabase(name: 'manah_scoring');
}
