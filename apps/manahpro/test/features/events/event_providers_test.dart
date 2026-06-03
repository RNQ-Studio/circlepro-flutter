import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:manahpro/features/events/data/events_repository.dart';
import 'package:manahpro/features/events/domain/event_entity.dart';
import 'package:manahpro/features/events/domain/event_enums.dart';
import 'package:manahpro/features/events/domain/event_registration_entity.dart';
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
    'registration_opens_at': '2026-06-01T08:00:00Z',
    'registration_closes_at': '2026-06-14T17:00:00Z',
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

  test('EventsRepository parses list of events correctly from JSON response', () async {
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
        requestOptions: RequestOptions(path: 'v1/events/01F8MECH3PG9MMEX6GMECH3PG9'),
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

  test('EventsRepository parses list of tickets correctly from JSON response', () async {
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
}
