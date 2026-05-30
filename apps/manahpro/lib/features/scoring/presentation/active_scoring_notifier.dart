import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/scoring_entities.dart';
import '../domain/scoring_repository.dart';
import '../utils/ulid.dart';
import 'scoring_providers.dart';

part 'active_scoring_notifier.g.dart';

/// View state for the Score Input screen: the session plus the end currently
/// being edited.
class ActiveScoringState {
  const ActiveScoringState({required this.session, required this.currentEndIndex});

  final ScoringSessionEntity session;
  final int currentEndIndex;

  ScoringEndEntity get currentEnd => session.ends[currentEndIndex];

  bool get isCurrentEndFull => currentEnd.arrows.length >= session.arrowsPerEnd;

  bool get hasNextEnd => currentEndIndex < session.ends.length - 1;

  bool get hasPreviousEnd => currentEndIndex > 0;

  ActiveScoringState copyWith({ScoringSessionEntity? session, int? currentEndIndex}) {
    return ActiveScoringState(
      session: session ?? this.session,
      currentEndIndex: currentEndIndex ?? this.currentEndIndex,
    );
  }
}

/// Manages an in-progress scoring session. Every arrow tap persists to local
/// Drift immediately (offline-first), so progress survives a crash/restart.
@riverpod
class ActiveScoring extends _$ActiveScoring {
  @override
  Future<ActiveScoringState> build(String sessionId) async {
    final session = await ref.watch(scoringRepositoryProvider).getSession(sessionId);
    if (session == null) {
      throw StateError('Scoring session $sessionId not found');
    }
    return ActiveScoringState(
      session: session,
      currentEndIndex: _firstIncompleteEnd(session),
    );
  }

  ScoringRepository get _repo => ref.read(scoringRepositoryProvider);

  /// Record an arrow for the current end (M / 1-10 / X). No-op when the end is
  /// already full.
  Future<void> enterScore({required int value, bool isX = false, bool isMiss = false}) async {
    final current = state.value;
    if (current == null || current.isCurrentEndFull) return;

    final end = current.currentEnd;
    final arrow = ArrowScore(
      id: Ids.ulid(),
      arrowIndex: end.arrows.length,
      scoreValue: isMiss ? 0 : value,
      isX: isX,
      isMiss: isMiss,
    );

    final updated = await _repo.saveEnd(
      sessionId: current.session.id,
      endNumber: end.endNumber,
      arrows: [...end.arrows, arrow],
    );

    state = AsyncData(current.copyWith(session: updated));

    // Auto-advance to the next end once the current end is filled.
    final next = state.value;
    if (next != null && next.isCurrentEndFull && next.hasNextEnd) {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      nextEnd();
    }
  }

  /// Remove the last arrow of the current end.
  Future<void> undo() async {
    final current = state.value;
    if (current == null || current.currentEnd.arrows.isEmpty) return;

    final arrows = current.currentEnd.arrows;
    final updated = await _repo.saveEnd(
      sessionId: current.session.id,
      endNumber: current.currentEnd.endNumber,
      arrows: arrows.sublist(0, arrows.length - 1),
    );

    state = AsyncData(current.copyWith(session: updated));
  }

  void goToEnd(int index) {
    final current = state.value;
    if (current == null || index < 0 || index >= current.session.ends.length) return;
    state = AsyncData(current.copyWith(currentEndIndex: index));
  }

  void nextEnd() {
    final current = state.value;
    if (current != null && current.hasNextEnd) goToEnd(current.currentEndIndex + 1);
  }

  void previousEnd() {
    final current = state.value;
    if (current != null && current.hasPreviousEnd) goToEnd(current.currentEndIndex - 1);
  }

  /// Finalize the session; returns the completed entity (with PB flag).
  Future<ScoringSessionEntity?> finish() async {
    final current = state.value;
    if (current == null) return null;

    final finished = await _repo.finishSession(current.session.id);
    state = AsyncData(current.copyWith(session: finished));
    ref.invalidate(sessionsListProvider);
    return finished;
  }

  static int _firstIncompleteEnd(ScoringSessionEntity session) {
    final index = session.ends.indexWhere((e) => e.arrows.length < session.arrowsPerEnd);
    return index == -1 ? session.ends.length - 1 : index;
  }
}
