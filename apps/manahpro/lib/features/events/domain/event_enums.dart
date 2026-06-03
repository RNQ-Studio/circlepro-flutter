/// Domain enums mirroring the backend (Module 2 — COMPETE).
library;

enum Gender {
  male('male', 'Putra'),
  female('female', 'Putri'),
  mixed('mixed', 'Campuran');

  const Gender(this.value, this.label);

  final String value;
  final String label;

  static Gender fromValue(String? value) =>
      Gender.values.firstWhere((e) => e.value == value, orElse: () => Gender.male);
}

enum AgeGroup {
  tk('tk', 'TK (<6 Tahun)'),
  sd123('sd_123', 'SD Pemula (6-9 Tahun)'),
  sd456('sd_456', 'SD Prestasi (9-12 Tahun)'),
  smp('smp', 'SMP (12-15 Tahun)'),
  sma('sma', 'SMA (15-18 Tahun)'),
  dewasa('dewasa', 'Umum/Dewasa (>18 Tahun)');

  const AgeGroup(this.value, this.label);

  final String value;
  final String label;

  static AgeGroup fromValue(String? value) =>
      AgeGroup.values.firstWhere((e) => e.value == value, orElse: () => AgeGroup.dewasa);
}

enum EventFormat {
  rankingRound('ranking_round', 'Ranking Round'),
  matchPlay('match_play', 'Match Play'),
  elimination('elimination', 'Elimination Round'),
  field('field', 'Field'),
  indoorRound('indoor_round', 'Indoor Round');

  const EventFormat(this.value, this.label);

  final String value;
  final String label;

  static EventFormat fromValue(String? value) =>
      EventFormat.values.firstWhere((e) => e.value == value, orElse: () => EventFormat.rankingRound);
}

enum EventTier {
  s('S', 'Nasional (PON/Nasional)'),
  a('A', 'Regional (Kejurda)'),
  b('B', 'Club Open (Kota)'),
  c('C', 'Latih Tanding (Sparring)'),
  d('D', 'Internal Klub');

  const EventTier(this.value, this.label);

  final String value;
  final String label;

  static EventTier fromValue(String? value) =>
      EventTier.values.firstWhere((e) => e.value == value, orElse: () => EventTier.b);
}

enum EventStatus {
  draft('draft', 'Draft'),
  published('published', 'Diumumkan'),
  registrationOpen('registration_open', 'Pendaftaran Dibuka'),
  registrationClosed('registration_closed', 'Pendaftaran Ditutup'),
  live('live', 'Berjalan Langsung'),
  completed('completed', 'Selesai'),
  rated('rated', 'Terhitung Rating'),
  cancelled('cancelled', 'Dibatalkan');

  const EventStatus(this.value, this.label);

  final String value;
  final String label;

  static EventStatus fromValue(String? value) =>
      EventStatus.values.firstWhere((e) => e.value == value, orElse: () => EventStatus.draft);
}

enum RegistrationStatus {
  pending('pending', 'Menunggu'),
  waitlisted('waitlisted', 'Daftar Tunggu'),
  confirmed('confirmed', 'Dikonfirmasi'),
  checkedIn('checked_in', 'Hadir'),
  cancelled('cancelled', 'Dibatalkan'),
  noShow('no_show', 'Tidak Hadir');

  const RegistrationStatus(this.value, this.label);

  final String value;
  final String label;

  static RegistrationStatus fromValue(String? value) =>
      RegistrationStatus.values.firstWhere((e) => e.value == value, orElse: () => RegistrationStatus.pending);
}
