import '../../scoring/domain/scoring_entities.dart';
import '../../scoring/domain/scoring_enums.dart';
import 'board_participant_entity.dart';
import 'group_claim.dart';
import 'group_entities.dart';
import 'group_live_leaderboard.dart';

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
    int sighterEndCount = 0,
    String? roundPresetKey,
    String? roundPresetLabel,
    bool hostParticipates = false,
    BowClass? hostBowClass,
  });

  /// Groups the user hosts or participates in (local-first, refreshed online).
  Future<List<ScoringGroupEntity>> getGroups();

  /// A single group with its roster (local-first, refreshed online).
  Future<ScoringGroupEntity?> getGroup(String groupId);

  /// Preview a group by its join code before joining (online-only, no cache).
  Future<ScoringGroupEntity> lookup(String joinCode);

  // ─── Self-join & self-scoring (Sprint 10) ───────────────────────────────

  /// Self-join [groupId] as an owned `self` row (task 10.1). [bowClass] is
  /// optional (K8). Online action: on success the group + roster is refreshed
  /// into the local cache so the joined member can score their own row
  /// offline-first. Returns the joined participant's session id.
  Future<String> joinGroup(
    String groupId, {
    BowClass? bowClass,
    int? distanceM,
    int? targetFaceCm,
  });

  /// Leave a group by removing one's own row (task 10.5). Deletes the row on the
  /// server, then clears the local copy so it no longer shows on the board.
  Future<void> leaveGroup(String groupId, String sessionId);

  // ─── Host board (Sprint 05) ─────────────────────────────────────────────

  /// Load the host board for [group]: seed local participant rows from the
  /// roster (so they can be scored offline), then return them with their local
  /// ends/arrows. Offline-first — works from cache when the network is down.
  Future<List<BoardParticipant>> loadBoard(ScoringGroupEntity group);

  /// Add a guest to the board entirely offline (minimal add — Sprint 05). The
  /// guest is minted on the server on the next sync. Returns the updated board.
  Future<List<BoardParticipant>> addGuest(
      ScoringGroupEntity group, String name);

  /// Quick-add several guests at once (Sprint 06): all names land locally in one
  /// batch, then mint on the server in a single background sync. Returns the
  /// updated board. Offline-first — never fails on a dead network.
  Future<List<BoardParticipant>> addGuests(
      ScoringGroupEntity group, List<String> names);

  /// Save one end's arrows for several participants at once ("Simpan Rambahan"),
  /// keyed by participant session id. Persists locally first (never fails on a
  /// dead network), kicks a best-effort background sync, returns the updated
  /// board. [endNumber] is 1-based. [sync] may be set false to persist
  /// locally without kicking a push — used by self-scoring to save each arrow
  /// crash-safe while only pushing once the end is complete (sparing the radio).
  Future<List<BoardParticipant>> saveEnd({
    required ScoringGroupEntity group,
    required int endNumber,
    required Map<String, List<ArrowScore>> arrowsByParticipantId,
    bool? isSighter,
    bool sync = true,
  });

  /// Best-effort push of unsynced participant scores to the group sync endpoint.
  /// Forgives a dead/flaky connection (kept local for the next attempt).
  Future<void> syncBoard(ScoringGroupEntity group);

  // ─── Per-bantalan scoring (Sprint 17-19) ────────────────────────────────

  /// Fetch grouped roster/status per target butt. [version] is the lightweight
  /// polling cursor; unchanged replies carry an empty butt list.
  Future<GroupButtStatusEnvelope> fetchButts(
    String groupId, {
    String? version,
  });

  /// Claim the right to score one target butt on this device/user.
  Future<GroupScorerEntity> claimButt(String groupId, int targetButt);

  /// Host/owner distance override before the participant has submitted scores.
  Future<GroupParticipantEntity> assignParticipantDistance(
    String groupId,
    String sessionId, {
    required int distanceM,
    int? targetFaceCm,
  });

  // ─── Live leaderboard polling (Sprint 11) ───────────────────────────────

  /// Fetch the server-aggregated live leaderboard for [groupId] (task 11.1).
  /// Passing the last-seen [version] lets the server reply "unchanged" with an
  /// empty payload when nothing moved — the frugal polling cursor. Online-only:
  /// this is the multi-device fair board, so a failure surfaces to the caller
  /// (which falls back to the offline local board).
  Future<LiveLeaderboardSnapshot> fetchLeaderboard(
    String groupId, {
    String? version,
  });

  // ─── Claim ("Ini Saya") — Sprint 14, Phase 2 ────────────────────────────

  /// Guest slots of [groupId] a code-holder may claim (task 14.1). Online-only:
  /// the deep-link landing needs the live truth. Each slot carries this user's
  /// own claim status so the UI can paint the "Menunggu persetujuan host" badge.
  Future<List<ClaimableSlot>> claimableSlots(String groupId);

  /// Submit a claim over a guest slot ("Ini Saya" — task 14.2). [message] is an
  /// optional note to the host. Idempotent server-side (revives a prior
  /// cancelled/rejected claim).
  Future<void> submitClaim(String groupId, String sessionId, {String? message});

  /// The host inbox of claims to review for [groupId] (task 14.3), optionally
  /// filtered by [status]. Online-only.
  Future<List<HostClaim>> hostClaims(String groupId, {ClaimStatus? status});

  /// Approve or reject a claim, host-only (task 14.3). [approve] true approves
  /// (transfers ownership), false rejects.
  Future<void> resolveClaim(String claimId, {required bool approve});

  /// Cancel one's own pending claim (claimant-only).
  Future<void> cancelClaim(String claimId);
}
