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
  // Nullable since Sprint 05: a guest row recorded on the host board has no
  // bow class (K8 — metadata optional). Solo sessions always set it.
  TextColumn get bowClass => text().nullable()();
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
  BoolColumn get isPersonalBest =>
      boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get source => text().withDefault(const Constant('mobile'))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  /// Pending sync action: 'create' | 'update' | 'delete' | null.
  TextColumn get syncAction => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  // ─── Latihan Bersama (group scoring) labels — Sprint 04, task 4.2 ──────
  // A session row that belongs to a group carries the binder id; a row scored
  // for a player without an account carries the guest display name. Reusing
  // this same table (instead of a separate DB) keeps "local join" trivial:
  // the host's own owned row stays a normal scoring session that still feeds
  // PB/stats, while guest rows are filtered out by [guestName]/null user.
  // These columns are introduced now (foundation); the host board that writes
  // them lands in Sprint 05. See arsitektur-dan-keputusan.md §2/§3.2 (K2).
  TextColumn get scoringSessionGroupId => text().nullable()();
  TextColumn get guestName => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Cached metadata of a group (Latihan Bersama) — Sprint 04, task 4.5.
///
/// The server stays the source of truth; this cache only lets the group list &
/// detail render offline (read-only). It is refreshed after every successful
/// create/list/detail fetch.
class GroupSessionRows extends Table {
  TextColumn get id => text()(); // group ULID
  TextColumn get joinCode => text()();
  TextColumn get title => text().nullable()();
  IntColumn get hostUserId => integer()();
  TextColumn get hostName => text().nullable()();
  TextColumn get distanceCategory => text()();
  IntColumn get distanceM => integer()();
  TextColumn get environment => text().withDefault(const Constant('outdoor'))();
  IntColumn get targetFaceCm => integer().nullable()();
  TextColumn get targetFaceId => text().nullable()();
  IntColumn get numEnds => integer()();
  IntColumn get arrowsPerEnd => integer()();
  IntColumn get sighterEndCount => integer().withDefault(const Constant(0))();
  TextColumn get roundPresetKey => text().nullable()();
  TextColumn get roundPresetLabel => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('in_progress'))();
  IntColumn get participantCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Cached roster summary of a group — Sprint 04, task 4.5. One row per
/// participant (an owned or guest `scoring_sessions` row on the server),
/// holding just enough to render the detail roster offline.
class GroupParticipantCacheRows extends Table {
  TextColumn get id => text()(); // participant scoring_session ULID
  TextColumn get groupId => text()();
  IntColumn get userId => integer().nullable()();
  TextColumn get displayName => text().nullable()();
  TextColumn get guestName => text().nullable()();
  BoolColumn get isGuest => boolean().withDefault(const Constant(false))();
  TextColumn get bowClass => text().nullable()();
  TextColumn get distanceCategory => text().nullable()();
  IntColumn get distanceM => integer().nullable()();
  IntColumn get targetFaceCm => integer().nullable()();
  IntColumn get targetButt => integer().nullable()();
  TextColumn get targetLetter => text().nullable()();
  IntColumn get lastScoredByUserId => integer().nullable()();
  IntColumn get totalScore => integer().withDefault(const Constant(0))();
  IntColumn get maxPossibleScore => integer().nullable()();
  IntColumn get arrowsShot => integer().withDefault(const Constant(0))();
  IntColumn get xCount => integer().withDefault(const Constant(0))();
  IntColumn get tenCount => integer().withDefault(const Constant(0))();
  TextColumn get status => text().nullable()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class ScoringEndRows extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text()();
  IntColumn get endNumber => integer()();
  BoolColumn get isSighter => boolean().withDefault(const Constant(false))();

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
///
/// Shared by both `features/scoring/` (individual TRACK) and
/// `features/group_scoring/` (Latihan Bersama). Reusing one DB — instead of a
/// second one — is the deliberate Sprint 04 decision (task 4.2): it keeps local
/// joins between a group and the host's own owned session trivial. The group
/// metadata/roster tables are read-only caches; the server stays authoritative.
@DriftDatabase(tables: [
  ScoringSessionRows,
  ScoringEndRows,
  ScoringArrowRows,
  TargetFaceRows,
  GroupSessionRows,
  GroupParticipantCacheRows,
])
class ScoringDatabase extends _$ScoringDatabase {
  ScoringDatabase([QueryExecutor? executor]) : super(executor ?? _open());

  @override
  int get schemaVersion =>
      12; // Sprint 21-22: sighter rounds and round presets in group cache

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // Destructive migration for development: drop all tables and start fresh
          await m.drop(scoringArrowRows);
          await m.drop(scoringEndRows);
          await m.drop(scoringSessionRows);
          await m.drop(targetFaceRows);
          await m.drop(groupSessionRows);
          await m.drop(groupParticipantCacheRows);
          await m.createAll();
        },
      );

  static QueryExecutor _open() => driftDatabase(name: 'manah_scoring');
}
