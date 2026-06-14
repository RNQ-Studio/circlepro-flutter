import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/api/manah_api.dart';
import '../../scoring/domain/scoring_entities.dart';
import '../../scoring/presentation/scoring_providers.dart';
import '../data/group_scoring_repository_impl.dart';
import '../data/local/group_scoring_local_data_source.dart';
import '../data/remote/group_scoring_remote_data_source.dart';
import '../domain/board_participant_entity.dart';
import '../domain/group_entities.dart';
import '../domain/group_scoring_repository.dart';

part 'group_scoring_providers.g.dart';

@Riverpod(keepAlive: true)
GroupScoringRemoteDataSource _groupRemoteDataSource(Ref ref) {
  return GroupScoringRemoteDataSource(ref.watch(manahDioProvider));
}

@Riverpod(keepAlive: true)
GroupScoringLocalDataSource _groupLocalDataSource(Ref ref) {
  // Reuse the shared scoring Drift DB (Sprint 04 decision, task 4.2).
  return GroupScoringLocalDataSource(ref.watch(scoringDatabaseProvider));
}

@Riverpod(keepAlive: true)
GroupScoringRepository groupScoringRepository(Ref ref) {
  return GroupScoringRepositoryImpl(
    ref.watch(_groupRemoteDataSourceProvider),
    ref.watch(_groupLocalDataSourceProvider),
  );
}

/// Groups the user hosts or participates in (local-first, refreshed online).
@riverpod
Future<List<ScoringGroupEntity>> groupsList(Ref ref) {
  return ref.watch(groupScoringRepositoryProvider).getGroups();
}

/// A single group with its roster (local-first, refreshed online).
@riverpod
Future<ScoringGroupEntity?> groupDetail(Ref ref, String groupId) {
  return ref.watch(groupScoringRepositoryProvider).getGroup(groupId);
}

/// Immutable state of the host board: the group (round format) plus its
/// participants with locally-stored ends.
class HostBoardState extends Equatable {
  const HostBoardState({required this.group, required this.participants});

  final ScoringGroupEntity group;
  final List<BoardParticipant> participants;

  /// Participants whose latest local write hasn't reached the server yet.
  int get pendingSyncCount => participants.where((p) => !p.isSynced).length;

  HostBoardState copyWith({List<BoardParticipant>? participants}) {
    return HostBoardState(
      group: group,
      participants: participants ?? this.participants,
    );
  }

  @override
  List<Object?> get props => [group, participants];
}

/// Drives the host board (Sprint 05): loads the group + participants, adds
/// guests, and saves each round offline-first (the repository persists locally
/// then syncs in the background). The screen only ever talks to this notifier.
@riverpod
class HostBoardController extends _$HostBoardController {
  @override
  Future<HostBoardState> build(String groupId) async {
    final repo = ref.watch(groupScoringRepositoryProvider);
    final group = await repo.getGroup(groupId);
    if (group == null) {
      throw StateError('Sesi tidak ditemukan');
    }
    final participants = await repo.loadBoard(group);
    return HostBoardState(group: group, participants: participants);
  }

  /// Add a guest by name (minimal add — Sprint 05).
  Future<void> addGuest(String name) async {
    final current = state.value;
    if (current == null) return;
    final repo = ref.read(groupScoringRepositoryProvider);
    final participants = await repo.addGuest(current.group, name);
    state = AsyncData(current.copyWith(participants: participants));
  }

  /// Quick-add several guests at once (Sprint 06, task 6.1) — one batch, one
  /// background sync. Blank names are ignored downstream.
  Future<void> addGuests(List<String> names) async {
    final current = state.value;
    if (current == null) return;
    final repo = ref.read(groupScoringRepositoryProvider);
    final participants = await repo.addGuests(current.group, names);
    state = AsyncData(current.copyWith(participants: participants));
  }

  /// Persist one round across the given participants (keyed by session id),
  /// offline-first. Never throws on a dead network — the save lands locally.
  Future<void> saveEnd(
    int endNumber,
    Map<String, List<ArrowScore>> arrowsByParticipantId,
  ) async {
    final current = state.value;
    if (current == null) return;
    final repo = ref.read(groupScoringRepositoryProvider);
    final participants = await repo.saveEnd(
      group: current.group,
      endNumber: endNumber,
      arrowsByParticipantId: arrowsByParticipantId,
    );
    state = AsyncData(current.copyWith(participants: participants));
  }

  /// Manually retry syncing unsynced rows (e.g. when signal returns), then
  /// refresh the board from local storage.
  Future<void> syncNow() async {
    final current = state.value;
    if (current == null) return;
    final repo = ref.read(groupScoringRepositoryProvider);
    await repo.syncBoard(current.group);
    final participants = await repo.loadBoard(current.group);
    state = AsyncData(current.copyWith(participants: participants));
  }
}
