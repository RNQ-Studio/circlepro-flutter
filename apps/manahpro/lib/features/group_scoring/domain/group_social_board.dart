import '../../scoring/domain/scoring_enums.dart';

/// Pure helpers for the **social leaderboard** (Sprint 12): one single board
/// where recurve, compound and horsebow sit together — with a per-row class
/// badge, an optional chip filter, and a ★ "tertinggi di kelasmu" marker.
///
/// These live in the domain layer (no Flutter import) so the "who is top of
/// their class?" and "which classes are on the board?" rules can be unit-tested
/// without pumping a widget. The screen feeds them the minimal shape it needs.

/// The minimal view of a board row these helpers reason about: a row's stable
/// id, its bow class (may be unknown), and whether it has shot any arrow. A row
/// that has not started never wins a class star.
typedef SocialBoardRow = ({String sessionId, BowClass? bowClass, bool started});

/// The bow classes actually present on the board, in the canonical
/// [BowClass.values] order (so the filter chips never jump around between
/// polls). Rows with an unknown class contribute nothing.
///
/// This is the **extensible seam** for Fase 3: the chip strip is built from a
/// list of facets; today the only facet is bow class, tomorrow distance and
/// bantalan join the same pattern without reworking the row rendering.
List<BowClass> bowClassesOnBoard(Iterable<SocialBoardRow> rows) {
  final present = <BowClass>{
    for (final r in rows)
      if (r.bowClass != null) r.bowClass!,
  };
  return [
    for (final c in BowClass.values)
      if (present.contains(c)) c,
  ];
}

/// The session ids that are **top of their bow class** — but only for classes
/// holding ≥2 *started* archers. This is the anti-"juara dari 1" rule (task
/// 12.3): a lone compound shooter gets a class badge but never a ★, because
/// being "best of one" is meaningless and feels like a bug.
///
/// [rows] must already be in rank order (best first), exactly as the leaderboard
/// renders them; the first started row of each qualifying class wins its star.
Set<String> classLeaderSessionIds(Iterable<SocialBoardRow> rows) {
  final byClass = <BowClass, List<SocialBoardRow>>{};
  for (final r in rows) {
    if (r.bowClass == null || !r.started) continue;
    (byClass[r.bowClass!] ??= []).add(r);
  }
  return {
    for (final entry in byClass.entries)
      if (entry.value.length >= 2) entry.value.first.sessionId,
  };
}

/// Keeps only the rows of [filter] when a class chip is active; returns [rows]
/// unchanged when no filter is selected. Order is preserved.
List<T> filterRowsByClass<T>(
  List<T> rows,
  BowClass? filter,
  BowClass? Function(T) classOf,
) {
  if (filter == null) return rows;
  return [
    for (final r in rows)
      if (classOf(r) == filter) r,
  ];
}
