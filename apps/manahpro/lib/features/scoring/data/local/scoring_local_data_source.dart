import 'dart:convert';
import 'package:drift/drift.dart';

import '../../domain/scoring_entities.dart';
import '../../domain/scoring_enums.dart';
import 'scoring_database.dart';

/// Local (Drift) persistence for scoring sessions, ends and arrows.
///
/// A session row caches its aggregates; ends/arrows are stored relationally
/// and rebuilt into [ScoringSessionEntity] on read.
class ScoringLocalDataSource {
  const ScoringLocalDataSource(this._db);

  final ScoringDatabase _db;

  /// Insert or replace a session (and its ends/arrows). Aggregates are cached
  /// from the entity; sync flags marked so the engine pushes it later.
  Future<void> upsertSession(
    ScoringSessionEntity session, {
    required String syncAction,
  }) async {
    await _db.transaction(() async {
      await _db.into(_db.scoringSessionRows).insertOnConflictUpdate(
            ScoringSessionRowsCompanion.insert(
              id: session.id,
              clientUuid: session.clientUuid,
              equipmentProfileId: Value(session.equipmentProfileId),
              title: Value(session.title),
              bowClass: session.bowClass.value,
              distanceCategory: session.distanceCategory.value,
              distanceM: session.distanceM,
              environment: Value(session.environment.value),
              targetFaceCm: Value(session.targetFaceCm),
              targetFaceId: Value(session.targetFaceId),
              numEnds: session.numEnds,
              arrowsPerEnd: session.arrowsPerEnd,
              status: Value(session.status.value),
              totalScore: Value(session.totalScore),
              arrowsShot: Value(session.arrowsShot),
              xCount: Value(session.xCount),
              tenCount: Value(session.tenCount),
              missCount: Value(session.missCount),
              isPersonalBest: Value(session.isPersonalBest),
              notes: Value(session.notes),
              startedAt: session.startedAt,
              completedAt: Value(session.completedAt),
              isSynced: const Value(false),
              syncAction: Value(syncAction),
              updatedAt: Value(DateTime.now()),
            ),
          );

      await _replaceEnds(session);
    });
  }

  Future<void> _replaceEnds(ScoringSessionEntity session) async {
    // Remove existing ends + their arrows, then re-insert.
    final existingEnds = await (_db.select(_db.scoringEndRows)
          ..where((t) => t.sessionId.equals(session.id)))
        .get();
    for (final end in existingEnds) {
      await (_db.delete(_db.scoringArrowRows)..where((t) => t.endId.equals(end.id))).go();
    }
    await (_db.delete(_db.scoringEndRows)..where((t) => t.sessionId.equals(session.id))).go();

    for (final end in session.ends) {
      await _db.into(_db.scoringEndRows).insert(
            ScoringEndRowsCompanion.insert(
              id: end.id,
              sessionId: session.id,
              endNumber: end.endNumber,
            ),
          );
      for (final arrow in end.arrows) {
        await _db.into(_db.scoringArrowRows).insert(
              ScoringArrowRowsCompanion.insert(
                id: arrow.id,
                endId: end.id,
                arrowIndex: arrow.arrowIndex,
                scoreValue: arrow.scoreValue,
                isX: Value(arrow.isX),
                isMiss: Value(arrow.isMiss),
              ),
            );
      }
    }
  }

  Future<ScoringSessionEntity?> getSession(String id) async {
    final row = await (_db.select(_db.scoringSessionRows)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return null;
    return _hydrate(row);
  }

  /// All non-deleted sessions, most recent first.
  Future<List<ScoringSessionEntity>> getAllSessions() async {
    final rows = await (_db.select(_db.scoringSessionRows)
          ..where((t) => t.syncAction.equals('delete').not())
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .get();
    return Future.wait(rows.map(_hydrate));
  }

  /// Sessions with pending sync work.
  Future<List<ScoringSessionEntity>> getUnsynced() async {
    final rows = await (_db.select(_db.scoringSessionRows)
          ..where((t) => t.isSynced.equals(false)))
        .get();
    return Future.wait(rows.map(_hydrate));
  }

  Future<void> markSynced(String id) async {
    await (_db.update(_db.scoringSessionRows)..where((t) => t.id.equals(id))).write(
      const ScoringSessionRowsCompanion(
        isSynced: Value(true),
        syncAction: Value(null),
      ),
    );
  }

  /// Soft-delete locally (queue server delete) or hard-delete if never synced.
  Future<void> markDeleted(String id) async {
    final row = await (_db.select(_db.scoringSessionRows)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return;

    if (row.syncAction == 'create' && !row.isSynced) {
      await deletePermanently(id);
    } else {
      await (_db.update(_db.scoringSessionRows)..where((t) => t.id.equals(id))).write(
        const ScoringSessionRowsCompanion(
          isSynced: Value(false),
          syncAction: Value('delete'),
        ),
      );
    }
  }

  Future<void> deletePermanently(String id) async {
    await _db.transaction(() async {
      final ends = await (_db.select(_db.scoringEndRows)..where((t) => t.sessionId.equals(id))).get();
      for (final end in ends) {
        await (_db.delete(_db.scoringArrowRows)..where((t) => t.endId.equals(end.id))).go();
      }
      await (_db.delete(_db.scoringEndRows)..where((t) => t.sessionId.equals(id))).go();
      await (_db.delete(_db.scoringSessionRows)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<ScoringSessionEntity> _hydrate(ScoringSessionRow row) async {
    final endRows = await (_db.select(_db.scoringEndRows)
          ..where((t) => t.sessionId.equals(row.id))
          ..orderBy([(t) => OrderingTerm.asc(t.endNumber)]))
        .get();

    final ends = <ScoringEndEntity>[];
    for (final endRow in endRows) {
      final arrowRows = await (_db.select(_db.scoringArrowRows)
            ..where((t) => t.endId.equals(endRow.id))
            ..orderBy([(t) => OrderingTerm.asc(t.arrowIndex)]))
          .get();

      ends.add(
        ScoringEndEntity(
          id: endRow.id,
          endNumber: endRow.endNumber,
          arrows: arrowRows
              .map((a) => ArrowScore(
                    id: a.id,
                    arrowIndex: a.arrowIndex,
                    scoreValue: a.scoreValue,
                    isX: a.isX,
                    isMiss: a.isMiss,
                  ))
              .toList(),
        ),
      );
    }

    return ScoringSessionEntity(
      id: row.id,
      clientUuid: row.clientUuid,
      equipmentProfileId: row.equipmentProfileId,
      title: row.title,
      bowClass: BowClass.fromValue(row.bowClass),
      distanceCategory: DistanceCategory.fromValue(row.distanceCategory),
      distanceM: row.distanceM,
      environment: ArcheryEnvironment.fromValue(row.environment),
      targetFaceCm: row.targetFaceCm,
      targetFaceId: row.targetFaceId,
      numEnds: row.numEnds,
      arrowsPerEnd: row.arrowsPerEnd,
      status: ScoringSessionStatus.fromValue(row.status),
      notes: row.notes,
      startedAt: row.startedAt,
      completedAt: row.completedAt,
      isPersonalBest: row.isPersonalBest,
      isSynced: row.isSynced,
      syncAction: row.syncAction,
      ends: ends,
    );
  }

  Future<void> saveTargetFaces(List<TargetFaceEntity> targets) async {
    await _db.transaction(() async {
      await _db.delete(_db.targetFaceRows).go();
      for (final t in targets) {
        await _db.into(_db.targetFaceRows).insertOnConflictUpdate(
              TargetFaceRowsCompanion.insert(
                id: t.id,
                organizationId: Value(t.organizationId),
                organizationName: Value(t.organizationName),
                organizationSlug: Value(t.organizationSlug),
                code: t.code,
                name: t.name,
                imagePath: Value(t.imagePath),
                scoringRulesJson: jsonEncode(t.scoringRules.map((r) => r.toJson()).toList()),
                usedCount: Value(t.usedCount),
              ),
            );
      }
    });
  }

  Future<List<TargetFaceEntity>> getTargetFaces() async {
    final rows = await _db.select(_db.targetFaceRows).get();
    return rows.map((r) {
      final rulesJson = jsonDecode(r.scoringRulesJson) as List<dynamic>;
      return TargetFaceEntity(
        id: r.id,
        organizationId: r.organizationId,
        organizationName: r.organizationName,
        organizationSlug: r.organizationSlug,
        code: r.code,
        name: r.name,
        imagePath: r.imagePath,
        usedCount: r.usedCount,
        scoringRules: rulesJson.map((x) => TargetFaceRule.fromJson(x as Map<String, dynamic>)).toList(),
      );
    }).toList();
  }

  Stream<List<TargetFaceEntity>> watchTargetFaces() {
    return _db.select(_db.targetFaceRows).watch().map((rows) {
      return rows.map((r) {
        final rulesJson = jsonDecode(r.scoringRulesJson) as List<dynamic>;
        return TargetFaceEntity(
          id: r.id,
          organizationId: r.organizationId,
          organizationName: r.organizationName,
          organizationSlug: r.organizationSlug,
          code: r.code,
          name: r.name,
          imagePath: r.imagePath,
          usedCount: r.usedCount,
          scoringRules: rulesJson.map((x) => TargetFaceRule.fromJson(x as Map<String, dynamic>)).toList(),
        );
      }).toList();
    });
  }
}
