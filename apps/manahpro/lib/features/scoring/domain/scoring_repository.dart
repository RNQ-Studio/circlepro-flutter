import 'scoring_entities.dart';
import 'scoring_enums.dart';

/// Contract for the offline-first scoring repository (Module 1 — TRACK).
abstract interface class ScoringRepository {
  /// Create a brand-new in-progress session locally (pre-generated ULID).
  Future<ScoringSessionEntity> startSession({
    required BowClass bowClass,
    required DistanceCategory distanceCategory,
    required int distanceM,
    required int numEnds,
    required int arrowsPerEnd,
    ArcheryEnvironment environment = ArcheryEnvironment.outdoor,
    int? targetFaceCm,
    String? targetFaceId,
    int? maxPossibleScoreOverride,
    String? equipmentProfileId,
    String? title,
    int sighterEndCount = 0,
  });

  /// Persist the current arrows of an end (replaces that end's arrows).
  Future<ScoringSessionEntity> saveEnd({
    required String sessionId,
    required int endNumber,
    required List<ArrowScore> arrows,
  });

  /// Mark a session completed, recompute aggregates and detect a local PB.
  Future<ScoringSessionEntity> finishSession(String sessionId);

  /// Load a single session (with ends/arrows) from local storage.
  Future<ScoringSessionEntity?> getSession(String sessionId);

  /// History list (most-recent first), local-first.
  Future<List<ScoringSessionEntity>> getSessions();

  /// Delete a session (locally + queued for server delete).
  Future<void> deleteSession(String sessionId);

  /// Push all unsynced sessions to the server (idempotent batch sync).
  Future<void> sync();

  /// Watch target faces locally from SQLite database.
  Stream<List<TargetFaceEntity>> watchTargetFaces();

  /// Trigger a background update of target faces from the server.
  Future<void> refreshTargetFaces();
}
