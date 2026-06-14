import '../../scoring/domain/scoring_enums.dart';
import 'group_entities.dart';

/// Contract for the Latihan Bersama (group scoring) repository — Phase 0.
///
/// Group metadata is online-first (server is the source of truth) but reads are
/// cached locally so the list & detail render offline (Sprint 04, task 4.5).
/// Participant *scores* remain offline-first via the shared scoring Drift DB
/// (arrives Sprint 05).
abstract interface class GroupScoringRepository {
  /// Create a group on the server; the caller becomes host and a unique
  /// `join_code` is returned. [hostParticipates] adds the host to the roster as
  /// an owned ("saya ikut menembak") row.
  Future<ScoringGroupEntity> createGroup({
    required DistanceCategory distanceCategory,
    required int distanceM,
    required int numEnds,
    required int arrowsPerEnd,
    ArcheryEnvironment environment = ArcheryEnvironment.outdoor,
    int? targetFaceCm,
    String? targetFaceId,
    String? title,
    bool hostParticipates = false,
    BowClass? hostBowClass,
  });

  /// Groups the user hosts or participates in (local-first, refreshed online).
  Future<List<ScoringGroupEntity>> getGroups();

  /// A single group with its roster (local-first, refreshed online).
  Future<ScoringGroupEntity?> getGroup(String groupId);

  /// Preview a group by its join code before joining (online-only, no cache).
  Future<ScoringGroupEntity> lookup(String joinCode);
}
