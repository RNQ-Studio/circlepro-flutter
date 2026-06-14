import 'package:equatable/equatable.dart';

import 'board_participant_entity.dart';

/// One ranked row of the session leaderboard (Sprint 07, task 7.1) — a
/// [BoardParticipant] paired with its [rank] and its completion status, derived
/// purely from the locally-stored ends so the board and the leaderboard can
/// never disagree.
///
/// The leaderboard is **DNF-friendly** (task 7.4): a real session is often
/// closed while some archers haven't finished (a broken string, someone left to
/// pick up a kid). We never punish that with a shaming 0 — [isComplete] and
/// [hasStarted] let the UI show "—"/"belum selesai" instead.
class GroupLeaderboardEntry extends Equatable {
  const GroupLeaderboardEntry({
    required this.participant,
    required this.rank,
    required this.isComplete,
  });

  /// The underlying board row (carries name, score, x/10 counts, ends).
  final BoardParticipant participant;

  /// Competition rank, 1-based, **shared on ties** (standard "1-2-2-4"
  /// ranking). Honours the whistle: because every archer shoots the same round,
  /// comparing running totals mid-session is fair (K4).
  final int rank;

  /// Whether this archer has shot every planned arrow. When false the card
  /// shows "belum selesai" rather than a misleading total/0 (task 7.4).
  final bool isComplete;

  /// Whether this archer has recorded any arrow at all. A zero-arrow row shows
  /// "—" on the card, never a 0.
  bool get hasStarted => participant.arrowsShot > 0;

  @override
  List<Object?> get props => [participant, rank, isComplete];
}

/// The computed session leaderboard: ranked [entries] plus whistle-aware
/// progress so the screen can show "memimpin sementara · N/M rambahan" while
/// the session is still in flight (task 7.1).
class GroupLeaderboard extends Equatable {
  const GroupLeaderboard({
    required this.entries,
    required this.numEnds,
    required this.roundsShot,
  });

  final List<GroupLeaderboardEntry> entries;

  /// Planned rounds for the session (the group's `num_ends`).
  final int numEnds;

  /// The furthest round any archer has reached — the live frontier. Used for
  /// the "N/M rambahan" progress label.
  final int roundsShot;

  /// Whether **every** archer has finished every planned arrow. While false the
  /// leader is only "memimpin sementara".
  bool get isComplete =>
      entries.isNotEmpty && entries.every((e) => e.isComplete);

  bool get inProgress => !isComplete;

  /// The current leader (rank 1), or null on an empty board.
  GroupLeaderboardEntry? get leader => entries.isEmpty ? null : entries.first;

  @override
  List<Object?> get props => [entries, numEnds, roundsShot];
}

/// Rank the board into a fair leaderboard (task 7.1).
///
/// Ordering is **total → X → 10** descending, with **no time-based tiebreak**
/// (K4: the whistle is honoured, so the board stays honest; a genuine tie stays
/// a tie and shares a rank). Archers who haven't finished are still ranked by
/// their honest running total — they are merely *labelled* DNF, not buried.
GroupLeaderboard buildGroupLeaderboard({
  required List<BoardParticipant> participants,
  required int numEnds,
  required int arrowsPerEnd,
}) {
  final plannedArrows = numEnds * arrowsPerEnd;

  final sorted = [...participants]..sort((a, b) {
      final byTotal = b.totalScore.compareTo(a.totalScore);
      if (byTotal != 0) return byTotal;
      final byX = b.xCount.compareTo(a.xCount);
      if (byX != 0) return byX;
      return b.tenCount.compareTo(a.tenCount);
    });

  final entries = <GroupLeaderboardEntry>[];
  var roundsShot = 0;
  for (var i = 0; i < sorted.length; i++) {
    final p = sorted[i];
    if (p.endsShot > roundsShot) roundsShot = p.endsShot;

    // Standard competition ranking: a tie shares the previous rank; the next
    // distinct score skips ahead by the number tied above it.
    var rank = i + 1;
    if (i > 0 && _tied(sorted[i - 1], p)) {
      rank = entries[i - 1].rank;
    }

    entries.add(
      GroupLeaderboardEntry(
        participant: p,
        rank: rank,
        isComplete: plannedArrows > 0 && p.arrowsShot >= plannedArrows,
      ),
    );
  }

  return GroupLeaderboard(
    entries: entries,
    numEnds: numEnds,
    roundsShot: roundsShot,
  );
}

bool _tied(BoardParticipant a, BoardParticipant b) =>
    a.totalScore == b.totalScore &&
    a.xCount == b.xCount &&
    a.tenCount == b.tenCount;
