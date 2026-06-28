import 'package:equatable/equatable.dart';

import '../../scoring/domain/scoring_entities.dart';
import '../../scoring/domain/scoring_enums.dart';

/// A participant as seen on the **host board** (Sprint 05): one local
/// `scoring_sessions` row that belongs to a group, carrying its ends/arrows so
/// the host can fill them in end-by-end, fully offline.
///
/// It is keyed by the participant's session [id] (a ULID), **not** by `user_id`
/// (task 5.2) — that is what lets a guest (`userId == null`) sit on the board
/// next to an owned row. [clientUuid] is the idempotency key the group sync
/// endpoint dedups on. The score figures are derived from [ends] so the board
/// and the local store never disagree.
class BoardParticipant extends Equatable {
  const BoardParticipant({
    required this.id,
    required this.clientUuid,
    this.userId,
    this.guestName,
    this.displayName,
    this.bowClass,
    this.distanceM,
    this.targetFaceCm,
    this.targetButt,
    this.targetLetter,
    this.status = ScoringSessionStatus.inProgress,
    this.isSynced = false,
    this.syncAction,
    this.completedAt,
    this.ends = const [],
  });

  /// Participant scoring_sessions ULID (client-generated for an offline guest).
  final String id;

  /// Idempotency key for the group sync endpoint (resolve-or-create).
  final String clientUuid;

  /// Owner of the row, or `null` for a guest (the binder's guest isolation).
  final int? userId;

  /// Display name of a guest (no account). `null` for an owned/host row.
  final String? guestName;

  /// Server-provided display name (e.g. the host's own name). Optional; the UI
  /// falls back to [guestName] for guests.
  final String? displayName;

  final BowClass? bowClass;
  final int? distanceM;
  final int? targetFaceCm;
  final int? targetButt;
  final String? targetLetter;
  final ScoringSessionStatus status;
  final bool isSynced;

  /// Pending sync action: 'create' | 'update' | null.
  final String? syncAction;
  final DateTime? completedAt;
  final List<ScoringEndEntity> ends;

  /// A guest has no account. Phase 0: an owned row is always the host.
  bool get isGuest => userId == null && guestName != null;

  /// Best label for the board: the guest's name, else a server display name.
  String labelOr(String fallback) => guestName ?? displayName ?? fallback;

  String get targetLabel {
    if (targetButt == null) return '-';
    final letter = targetLetter?.trim();
    return letter == null || letter.isEmpty
        ? '$targetButt'
        : '$targetButt$letter';
  }

  String get distanceLabel {
    final distance = distanceM;
    if (distance == null) return '-';
    final face = targetFaceCm;
    return face == null ? '$distance m' : '$distance m / $face cm';
  }

  Iterable<ArrowScore> get _allArrows => ends.expand((e) => e.arrows);

  int get totalScore => _allArrows.fold(0, (sum, a) => sum + a.scoreValue);

  int get arrowsShot => _allArrows.length;

  int get xCount => _allArrows.where((a) => a.isX).length;

  int get tenCount => _allArrows.where((a) => a.isTen).length;

  /// Arrows recorded for a given end number (empty when not yet scored).
  List<ArrowScore> arrowsForEnd(int endNumber) {
    for (final end in ends) {
      if (end.endNumber == endNumber) return end.arrows;
    }
    return const [];
  }

  BoardParticipant copyWith({
    int? distanceM,
    int? targetFaceCm,
    int? targetButt,
    String? targetLetter,
    ScoringSessionStatus? status,
    bool? isSynced,
    String? syncAction,
    DateTime? completedAt,
    List<ScoringEndEntity>? ends,
  }) {
    return BoardParticipant(
      id: id,
      clientUuid: clientUuid,
      userId: userId,
      guestName: guestName,
      displayName: displayName,
      bowClass: bowClass,
      distanceM: distanceM ?? this.distanceM,
      targetFaceCm: targetFaceCm ?? this.targetFaceCm,
      targetButt: targetButt ?? this.targetButt,
      targetLetter: targetLetter ?? this.targetLetter,
      status: status ?? this.status,
      isSynced: isSynced ?? this.isSynced,
      syncAction: syncAction ?? this.syncAction,
      completedAt: completedAt ?? this.completedAt,
      ends: ends ?? this.ends,
    );
  }

  /// Number of rounds this participant has actually shot (ends with arrows).
  int get endsShot => ends.where((e) => e.arrows.isNotEmpty).length;

  @override
  List<Object?> get props => [
        id,
        clientUuid,
        userId,
        guestName,
        displayName,
        bowClass,
        distanceM,
        targetFaceCm,
        targetButt,
        targetLetter,
        status,
        isSynced,
        syncAction,
        completedAt,
        ends,
      ];
}

/// Whether [endNumber] is a *saved* round across the whole board — i.e. every
/// participant has arrows recorded for it. A saved round is one the host can
/// re-open and correct (Sprint 06, task 6.2); an unsaved one is the live
/// frontier still being filled following the whistle. Returns false for an
/// empty board.
bool boardRoundIsSaved(List<BoardParticipant> participants, int endNumber) {
  if (participants.isEmpty) return false;
  return participants.every((p) => p.arrowsForEnd(endNumber).isNotEmpty);
}
