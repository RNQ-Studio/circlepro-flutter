import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:manahpro/features/group_scoring/data/group_scoring_repository_impl.dart';
import 'package:manahpro/features/group_scoring/data/local/group_scoring_local_data_source.dart';
import 'package:manahpro/features/group_scoring/data/remote/group_scoring_remote_data_source.dart';
import 'package:manahpro/features/group_scoring/domain/group_claim.dart';
import 'package:manahpro/features/scoring/domain/scoring_enums.dart';

class _MockRemote extends Mock implements GroupScoringRemoteDataSource {}

class _MockLocal extends Mock implements GroupScoringLocalDataSource {}

/// Sprint 14 — claim ("Ini Saya") domain parsing + the repository wiring that
/// feeds the deep-link landing, the badge and the host inbox. These are the
/// bug-prone seams: a `my_claim_status` that drives the badge, the rich slot
/// block on a host claim, and the approve/reject action verb mapping.
void main() {
  group('ClaimStatus.fromValue', () {
    test('maps known values and null', () {
      expect(ClaimStatus.fromValue('pending'), ClaimStatus.pending);
      expect(ClaimStatus.fromValue('approved'), ClaimStatus.approved);
      expect(ClaimStatus.fromValue('rejected'), ClaimStatus.rejected);
      expect(ClaimStatus.fromValue('cancelled'), ClaimStatus.cancelled);
      expect(ClaimStatus.fromValue(null), isNull);
      expect(ClaimStatus.fromValue('nonsense'), isNull);
    });
  });

  group('ClaimableSlot.fromJson', () {
    test('parses score context + my own pending claim (drives the badge)', () {
      final slot = ClaimableSlot.fromJson({
        'session_id': 'sessB',
        'display_name': 'Pak Budi',
        'started_at': '2026-06-27T09:00:00+07:00',
        'distance_category': '15m',
        'distance_m': 15,
        'total_score': 27,
        'arrows_shot': 3,
        'x_count': 0,
        'ten_count': 1,
        'my_claim_status': 'pending',
        'my_claim_id': 'clm9',
      });

      expect(slot.sessionId, 'sessB');
      expect(slot.labelOr('x'), 'Pak Budi');
      expect(slot.distanceCategory, DistanceCategory.d15m);
      expect(slot.totalScore, 27);
      expect(slot.hasStarted, isTrue);
      expect(slot.myClaimStatus, ClaimStatus.pending);
      expect(slot.isPendingMine, isTrue);
      expect(slot.myClaimId, 'clm9');
    });

    test('an unclaimed slot has no badge and shows "—" when it has no arrows',
        () {
      final slot = ClaimableSlot.fromJson({
        'session_id': 'sessC',
        'display_name': 'Tamu',
        'total_score': 0,
        'arrows_shot': 0,
      });
      expect(slot.myClaimStatus, isNull);
      expect(slot.isPendingMine, isFalse);
      expect(slot.hasStarted, isFalse);
    });
  });

  group('HostClaim.fromJson', () {
    test('parses claimant, message + the rich slot block (13.2)', () {
      final claim = HostClaim.fromJson({
        'id': 'clm1',
        'group_id': 'grp1',
        'session_id': 'sessB',
        'status': 'pending',
        'status_label': 'Menunggu',
        'message': 'Aku yang di bantalan 3',
        'claimant': {'id': 7, 'name': 'Budi'},
        'created_at': '2026-06-27T09:05:00+07:00',
        'slot': {
          'session_id': 'sessB',
          'display_name': 'Pak Budi',
          'distance_m': 15,
          'total_score': 27,
          'arrows_shot': 3,
          'x_count': 0,
          'ten_count': 1,
          'is_personal_best': true,
        },
      });

      expect(claim.isPending, isTrue);
      expect(claim.claimantName, 'Budi');
      expect(claim.message, 'Aku yang di bantalan 3');
      expect(claim.slot, isNotNull);
      expect(claim.slot!.totalScore, 27);
      expect(claim.slot!.isPersonalBest, isTrue);
    });

    test('a claim without an eager slot block parses with slot == null', () {
      final claim = HostClaim.fromJson({
        'id': 'clm2',
        'group_id': 'grp1',
        'session_id': 'sessB',
        'status': 'approved',
        'claimant': {'id': 7, 'name': 'Budi'},
      });
      expect(claim.slot, isNull);
      expect(claim.status, ClaimStatus.approved);
      expect(claim.isPending, isFalse);
    });
  });

  group('repository wiring', () {
    late _MockRemote remote;
    late _MockLocal local;
    late GroupScoringRepositoryImpl repo;

    setUp(() {
      remote = _MockRemote();
      local = _MockLocal();
      repo = GroupScoringRepositoryImpl(remote, local);
    });

    test('claimableSlots maps the remote slot list to entities', () async {
      when(() => remote.getClaimableSlots('grp1')).thenAnswer((_) async => [
            {
              'session_id': 'sessB',
              'display_name': 'Pak Budi',
              'total_score': 27,
              'arrows_shot': 3,
              'my_claim_status': null,
            },
          ]);

      final slots = await repo.claimableSlots('grp1');
      expect(slots, hasLength(1));
      expect(slots.first.sessionId, 'sessB');
      expect(slots.first.isPendingMine, isFalse);
    });

    test('submitClaim forwards the optional message', () async {
      when(() => remote.submitClaim('grp1', 'sessB', message: 'halo'))
          .thenAnswer((_) async => {'id': 'clm1'});

      await repo.submitClaim('grp1', 'sessB', message: 'halo');
      verify(() => remote.submitClaim('grp1', 'sessB', message: 'halo'))
          .called(1);
    });

    test('resolveClaim maps approve/reject to the action verb', () async {
      when(() => remote.resolveClaim('clm1', any()))
          .thenAnswer((_) async => {'id': 'clm1'});

      await repo.resolveClaim('clm1', approve: true);
      verify(() => remote.resolveClaim('clm1', 'approve')).called(1);

      await repo.resolveClaim('clm1', approve: false);
      verify(() => remote.resolveClaim('clm1', 'reject')).called(1);
    });

    test('hostClaims passes the status filter value through', () async {
      when(() => remote.getHostClaims('grp1', status: 'pending'))
          .thenAnswer((_) async => const []);

      await repo.hostClaims('grp1', status: ClaimStatus.pending);
      verify(() => remote.getHostClaims('grp1', status: 'pending')).called(1);
    });
  });
}
