import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:manahpro/features/identity/data/profile_repository.dart';
import 'package:manahpro/features/identity/presentation/profile_providers.dart';
import 'package:manahpro/shared/api/manah_api.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
  });

  final dummyProfileJson = {
    'id': 1,
    'username': 'atlet_pilihan',
    'full_name': 'Archer Pilihan',
    'email': 'archer@example.com',
    'is_following': false,
    'followers_count': 10,
    'following_count': 5,
    'stats': {
      'total_sessions': 12,
      'total_arrows': 432,
      'total_score': 3890,
      'personal_bests': 2,
    }
  };

  test('ProfileRepository parses public profile and follows status correctly', () async {
    when(() => mockDio.get('v1/users/1/profile')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: 'v1/users/1/profile'),
        data: {'success': true, 'data': dummyProfileJson},
        statusCode: 200,
      ),
    );

    final repo = ProfileRepository(mockDio);
    final profile = await repo.getPublicProfile(1);

    expect(profile.id, 1);
    expect(profile.displayName, 'Archer Pilihan');
    expect(profile.isFollowing, false);
    expect(profile.followersCount, 10);
    expect(profile.followingCount, 5);
  });

  test('ProfileRepository followUser sends POST request', () async {
    when(() => mockDio.post('v1/users/1/follow')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: 'v1/users/1/follow'),
        data: {'success': true},
        statusCode: 200,
      ),
    );

    final repo = ProfileRepository(mockDio);
    await repo.followUser(1);

    verify(() => mockDio.post('v1/users/1/follow')).called(1);
  });

  test('Riverpod publicProfileProvider toggles follow status and increments/decrements followersCount', () async {
    when(() => mockDio.get('v1/users/1/profile')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: 'v1/users/1/profile'),
        data: {'success': true, 'data': dummyProfileJson},
        statusCode: 200,
      ),
    );

    when(() => mockDio.post('v1/users/1/follow')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: 'v1/users/1/follow'),
        data: {'success': true},
        statusCode: 200,
      ),
    );

    when(() => mockDio.post('v1/users/1/unfollow')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: 'v1/users/1/unfollow'),
        data: {'success': true},
        statusCode: 200,
      ),
    );

    final container = ProviderContainer(
      overrides: [
        manahDioProvider.overrideWithValue(mockDio),
      ],
    );

    // Initial state
    final profile = await container.read(publicProfileProvider(1).future);
    expect(profile.isFollowing, false);
    expect(profile.followersCount, 10);

    // Toggle follow -> should be followed (isFollowing = true, followersCount = 11)
    final notifier = container.read(publicProfileProvider(1).notifier);
    await notifier.toggleFollow();

    final profileAfterFollow = container.read(publicProfileProvider(1)).value!;
    expect(profileAfterFollow.isFollowing, true);
    expect(profileAfterFollow.followersCount, 11);

    // Toggle again -> should be unfollowed (isFollowing = false, followersCount = 10)
    await notifier.toggleFollow();
    final profileAfterUnfollow = container.read(publicProfileProvider(1)).value!;
    expect(profileAfterUnfollow.isFollowing, false);
    expect(profileAfterUnfollow.followersCount, 10);
  });
}
