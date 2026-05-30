import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/api/manah_api.dart';
import '../data/clubs_repository.dart';
import '../domain/club_entity.dart';

part 'clubs_providers.g.dart';

@Riverpod(keepAlive: true)
ClubsRepository clubsRepository(Ref ref) {
  return ClubsRepository(ref.watch(manahDioProvider));
}

/// Club directory (optionally filtered by [search]).
@riverpod
Future<List<ClubEntity>> clubDirectory(Ref ref, {String? search}) {
  return ref.watch(clubsRepositoryProvider).directory(search: search);
}

/// Clubs the user belongs to.
@riverpod
Future<List<ClubEntity>> myClubs(Ref ref) {
  return ref.watch(clubsRepositoryProvider).myClubs();
}

/// A single club's detail.
@riverpod
Future<ClubEntity> clubDetail(Ref ref, String clubId) {
  return ref.watch(clubsRepositoryProvider).getClub(clubId);
}

/// A club's member list.
@riverpod
Future<List<ClubMemberEntity>> clubMembers(Ref ref, String clubId) {
  return ref.watch(clubsRepositoryProvider).members(clubId);
}
