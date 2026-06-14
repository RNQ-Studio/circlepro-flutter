import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:manahpro/features/events/data/events_repository.dart';
import 'package:manahpro/features/events/domain/event_entity.dart';
import 'package:manahpro/features/events/domain/event_enums.dart';
import 'package:manahpro/features/events/domain/event_registration_entity.dart';
import 'package:manahpro/features/events/domain/target_scorecard_item.dart';
import 'package:manahpro/features/events/domain/event_leaderboard_entry.dart';
import 'package:manahpro/features/events/domain/user_rating_entity.dart';
import 'package:manahpro/features/events/domain/rating_history_entry.dart';
import 'package:manahpro/features/events/presentation/events_providers.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late EventsRepository repository;

  setUp(() {
    mockDio = MockDio();
    repository = EventsRepository(mockDio);
  });

  final dummyEventJson = {
    'id': '01F8MECH3PG9MMEX6GMECH3PG9',
    'organization_id': '01F8MECH3PG9MMEX6GMECH3PG0',
    'organization_name': 'Klub Panahan Sleman',
    'organization_logo': null,
    'created_by': 1,
    'title': 'Sleman Archery Cup 2026',
    'slug': 'sleman-archery-cup-2026',
    'description': 'Latihan tanding bersama klub regional.',
    'banner_url': null,
    'tier': 'B',
    'format': 'ranking_round',
    'status': 'registration_open',
    'province': 'D.I. Yogyakarta',
    'city': 'Sleman',
    'venue_name': 'Lapangan Panahan Sleman',
    'address': 'Jl. Magelang KM 10',
    'latitude': -7.7123,
    'longitude': 110.3541,
    'starts_at': '2026-06-15T08:00:00Z',
    'ends_at': '2026-06-16T17:00:00Z',
    // Relative to now so `isRegistrationOpen` (which compares against
    // DateTime.now()) stays deterministic as the calendar moves — a fixed past
    // date here is a time-bomb that closes the window and fails the test.
    'registration_opens_at': DateTime.now()
        .subtract(const Duration(days: 7))
        .toUtc()
        .toIso8601String(),
    'registration_closes_at':
        DateTime.now().add(const Duration(days: 7)).toUtc().toIso8601String(),
    'capacity': 100,
    'schedule': [
      {'time': '08:00 - 09:00', 'title': 'Registrasi Ulang'},
      {'time': '09:00 - 12:00', 'title': 'Kualifikasi Sesi 1'}
    ],
    'rules': 'Standard FITA rules apply.',
    'is_external': false,
    'published_at': '2026-06-01T08:00:00Z',
    'divisions': [
      {
        'id': '01F8MECH3PG9MMEX6GMECH3PG1',
        'event_id': '01F8MECH3PG9MMEX6GMECH3PG9',
        'bow_class': 'recurve',
        'gender': 'male',
        'age_group': 'dewasa',
        'distance_category': '70m',
        'distance_m': 70,
        'num_arrows': 36,
        'max_score': 360,
        'entry_fee': 150000,
        'capacity': 32,
        'num_participants': 5,
        'sof_avg_rating': 45.5,
        'rating_status': 'unrated',
        'rated_at': null
      }
    ]
  };

  final dummyRegistrationJson = {
    'id': '01F8MECH3PG9MMEX6GMECH3PGB',
    'event_division_id': '01F8MECH3PG9MMEX6GMECH3PG1',
    'user_id': 2,
    'user_name': 'Ahmad Atlet',
    'user_avatar_url': null,
    'status': 'confirmed',
    'payment_id': null,
    'bib_number': 'REC-DEW-001',
    'qr_code': 'REG-ABCD-1234',
    'checked_in_at': null,
    'created_at': '2026-06-04T08:00:00Z',
    'updated_at': '2026-06-04T08:00:00Z',
    'division': {
      'id': '01F8MECH3PG9MMEX6GMECH3PG1',
      'event_id': '01F8MECH3PG9MMEX6GMECH3PG9',
      'bow_class': 'recurve',
      'gender': 'male',
      'age_group': 'dewasa',
      'distance_category': '70m',
      'distance_m': 70,
      'num_arrows': 36,
      'max_score': 360,
      'entry_fee': 150000,
      'capacity': 32,
      'num_participants': 5,
      'sof_avg_rating': 45.5,
      'rating_status': 'unrated',
      'rated_at': null
    },
    'event': dummyEventJson
  };

  final dummyScorecardJson = {
    'registration_id': '01F8MECH3PG9MMEX6GMECH3PGB',
    'bib_number': 'REC-DEW-001',
    'target_butt': 5,
    'target_letter': 'A',
    'user': {
      'id': 2,
      'name': 'Ahmad Atlet',
      'avatar_url': null,
    },
    'scoring_session': {
      'id': '01F8MECH3PG9MMEX6GMECH3PGC',
      'client_uuid': '01F8MECH3PG9MMEX6GMECH3PGD',
      'bow_class': 'recurve',
      'distance_category': '70m',
      'distance_m': 70,
      'num_ends': 12,
      'arrows_per_end': 6,
      'status': 'in_progress',
      'started_at': '2026-06-04T08:00:00Z',
      'ends': <dynamic>[]
    }
  };

  final dummyLeaderboardJson = {
    'session_id': '01F8MECH3PG9MMEX6GMECH3PGC',
    'user_id': 2,
    'user_name': 'Ahmad Atlet',
    'bib_number': 'REC-DEW-001',
    'target_butt': 5,
    'target_letter': 'A',
    'total_score': 330,
    'x_count': 5,
    'ten_count': 10,
    'miss_count': 0,
    'arrows_shot': 36,
    'avg_per_arrow': 9.17
  };

  test('EventsRepository parses list of events correctly from JSON response',
      () async {
    when(() => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: 'v1/events'),
        statusCode: 200,
        data: {
          'data': [dummyEventJson]
        },
      ),
    );

    final result = await repository.getEvents(search: 'Sleman');

    expect(result, isA<List<EventEntity>>());
    expect(result.length, 1);
    expect(result.first.title, 'Sleman Archery Cup 2026');
    expect(result.first.divisions.length, 1);
    expect(result.first.divisions.first.distanceM, 70);
  });

  test('EventsRepository parses single event detail correctly', () async {
    when(() => mockDio.get('v1/events/01F8MECH3PG9MMEX6GMECH3PG9')).thenAnswer(
      (_) async => Response(
        requestOptions:
            RequestOptions(path: 'v1/events/01F8MECH3PG9MMEX6GMECH3PG9'),
        statusCode: 200,
        data: {'data': dummyEventJson},
      ),
    );

    final result = await repository.getEvent('01F8MECH3PG9MMEX6GMECH3PG9');

    expect(result.title, 'Sleman Archery Cup 2026');
    expect(result.capacity, 100);
    expect(result.isRegistrationOpen, true);
  });

  test('Riverpod eventsListProvider returns list from repository', () async {
    final container = ProviderContainer(
      overrides: [
        eventsRepositoryProvider.overrideWithValue(repository),
      ],
    );

    when(() => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: 'v1/events'),
        statusCode: 200,
        data: {
          'data': [dummyEventJson]
        },
      ),
    );

    final asyncValue = await container.read(eventsListProvider.future);

    expect(asyncValue.length, 1);
    expect(asyncValue.first.title, 'Sleman Archery Cup 2026');
  });

  test('EventsRepository parses list of tickets correctly from JSON response',
      () async {
    when(() => mockDio.get('v1/my-tickets')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: 'v1/my-tickets'),
        statusCode: 200,
        data: {
          'data': [dummyRegistrationJson]
        },
      ),
    );

    final result = await repository.getMyTickets();

    expect(result, isA<List<EventRegistrationEntity>>());
    expect(result.length, 1);
    expect(result.first.bibNumber, 'REC-DEW-001');
    expect(result.first.status, RegistrationStatus.confirmed);
    expect(result.first.event?.title, 'Sleman Archery Cup 2026');
  });

  test('Riverpod myTicketsProvider returns tickets from repository', () async {
    final container = ProviderContainer(
      overrides: [
        eventsRepositoryProvider.overrideWithValue(repository),
      ],
    );

    when(() => mockDio.get('v1/my-tickets')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: 'v1/my-tickets'),
        statusCode: 200,
        data: {
          'data': [dummyRegistrationJson]
        },
      ),
    );

    final tickets = await container.read(myTicketsProvider.future);

    expect(tickets.length, 1);
    expect(tickets.first.bibNumber, 'REC-DEW-001');
    expect(tickets.first.status, RegistrationStatus.confirmed);
  });

  test('EventsRepository parses scorecard items correctly', () async {
    when(() => mockDio.get(
        'v1/events/eventId/divisions/divId/targets/5/scorecard')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(
            path: 'v1/events/eventId/divisions/divId/targets/5/scorecard'),
        statusCode: 200,
        data: {
          'data': [dummyScorecardJson]
        },
      ),
    );

    final result = await repository.getTargetScorecard('eventId', 'divId', 5);

    expect(result, isA<List<TargetScorecardItem>>());
    expect(result.length, 1);
    expect(result.first.targetLetter, 'A');
    expect(result.first.scoringSession.numEnds, 12);
  });

  test('Riverpod targetScorecardProvider returns scorecard items', () async {
    final container = ProviderContainer(
      overrides: [
        eventsRepositoryProvider.overrideWithValue(repository),
      ],
    );

    when(() => mockDio.get(
        'v1/events/eventId/divisions/divId/targets/5/scorecard')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(
            path: 'v1/events/eventId/divisions/divId/targets/5/scorecard'),
        statusCode: 200,
        data: {
          'data': [dummyScorecardJson]
        },
      ),
    );

    final result = await container.read(targetScorecardProvider(
      eventId: 'eventId',
      divisionId: 'divId',
      targetButt: 5,
    ).future);

    expect(result.length, 1);
    expect(result.first.targetLetter, 'A');
  });

  test('EventsRepository parses leaderboard entries correctly', () async {
    when(() => mockDio.get('v1/events/eventId/divisions/divId/leaderboard'))
        .thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(
            path: 'v1/events/eventId/divisions/divId/leaderboard'),
        statusCode: 200,
        data: {
          'data': [dummyLeaderboardJson]
        },
      ),
    );

    final result = await repository.getEventLeaderboard('eventId', 'divId');

    expect(result, isA<List<EventLeaderboardEntry>>());
    expect(result.length, 1);
    expect(result.first.totalScore, 330);
    expect(result.first.avgPerArrow, 9.17);
  });

  test('Riverpod eventLeaderboardProvider returns leaderboard', () async {
    final container = ProviderContainer(
      overrides: [
        eventsRepositoryProvider.overrideWithValue(repository),
      ],
    );

    when(() => mockDio.get('v1/events/eventId/divisions/divId/leaderboard'))
        .thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(
            path: 'v1/events/eventId/divisions/divId/leaderboard'),
        statusCode: 200,
        data: {
          'data': [dummyLeaderboardJson]
        },
      ),
    );

    final result = await container.read(eventLeaderboardProvider(
      eventId: 'eventId',
      divisionId: 'divId',
    ).future);

    expect(result.length, 1);
    expect(result.first.totalScore, 330);
  });

  final dummyRatingJson = {
    'id': '01F8MECH3PG9MMEX6GMECH3PGR',
    'organization_id': '01F8MECH3PG9MMEX6GMECH3PG0',
    'user_id': 2,
    'user_name': 'Ahmad Atlet',
    'username': 'ahmad_atlet',
    'avatar_url': null,
    'bow_class': 'recurve',
    'gender': 'male',
    'age_group': 'dewasa',
    'distance_category': '70m',
    'mu': 1600.0,
    'phi': 100.0,
    'sigma': 0.06,
    'display_rating': 1400.0,
    'status': 'ranked',
    'events_count': 5,
    'peak_display_rating': 1450.0,
    'last_event_date': '2026-06-04',
    'title': 'Expert Archer',
    'badge': 'Expert',
    'color': 'gold',
  };

  final dummyHistoryJson = {
    'id': '01F8MECH3PG9MMEX6GMECH3PGH',
    'rating_id': '01F8MECH3PG9MMEX6GMECH3PGR',
    'user_id': 2,
    'mu_before': 1550.0,
    'mu_after': 1600.0,
    'phi_before': 110.0,
    'phi_after': 100.0,
    'sigma_before': 0.06,
    'sigma_after': 0.06,
    'display_before': 1330.0,
    'display_after': 1400.0,
    'display_change': 70.0,
    'score_achieved': 330,
    'nps': 917.0,
    'placement': 1,
    'num_participants': 5,
    'event_tier': 'B',
    'k_effective': 32.0,
    'is_manual_override': false,
    'event_id': '01F8MECH3PG9MMEX6GMECH3PG9',
    'event_name': 'Sleman Archery Cup 2026',
    'division_name': 'Recurve Dewasa 70m',
    'computed_at': '2026-06-04T08:00:00Z',
  };

  test('EventsRepository parses national leaderboard ratings correctly',
      () async {
    when(() => mockDio.get(
          'v1/leaderboard',
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: 'v1/leaderboard'),
        statusCode: 200,
        data: {
          'data': [dummyRatingJson]
        },
      ),
    );

    final result = await repository.getNationalLeaderboard(
      bowClass: 'recurve',
      gender: 'male',
      ageGroup: 'dewasa',
      distanceCategory: '70m',
    );

    expect(result, isA<List<UserRatingEntity>>());
    expect(result.length, 1);
    expect(result.first.displayRating, 1400.0);
    expect(result.first.title, 'Expert Archer');
  });

  test('Riverpod nationalLeaderboardProvider returns leaderboard data',
      () async {
    final container = ProviderContainer(
      overrides: [
        eventsRepositoryProvider.overrideWithValue(repository),
      ],
    );

    when(() => mockDio.get(
          'v1/leaderboard',
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: 'v1/leaderboard'),
        statusCode: 200,
        data: {
          'data': [dummyRatingJson]
        },
      ),
    );

    final result = await container.read(nationalLeaderboardProvider.future);

    expect(result.length, 1);
    expect(result.first.displayRating, 1400.0);
  });

  test('EventsRepository parses user rating list correctly', () async {
    when(() => mockDio.get('v1/users/2/ratings')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: 'v1/users/2/ratings'),
        statusCode: 200,
        data: {
          'data': [dummyRatingJson]
        },
      ),
    );

    final result = await repository.getUserRatings('2');

    expect(result.length, 1);
    expect(result.first.userId, 2);
  });

  test('EventsRepository parses rating history log correctly', () async {
    when(() => mockDio.get('v1/users/2/ratings/ratingId/history')).thenAnswer(
      (_) async => Response(
        requestOptions:
            RequestOptions(path: 'v1/users/2/ratings/ratingId/history'),
        statusCode: 200,
        data: {
          'data': [dummyHistoryJson]
        },
      ),
    );

    final result = await repository.getRatingHistory('2', 'ratingId');

    expect(result, isA<List<RatingHistoryEntry>>());
    expect(result.length, 1);
    expect(result.first.displayChange, 70.0);
  });
}
