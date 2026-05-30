/// Domain enums mirroring the backend (Module 1 — TRACK). Each carries its
/// wire `value` (the string the API expects) plus a human label.
library;

enum BowClass {
  recurve('recurve', 'Recurve'),
  compound('compound', 'Compound'),
  barebowStandard('barebow_standard', 'Barebow Standard'),
  barebowTradisional('barebow_tradisional', 'Barebow Tradisional'),
  horsebow('horsebow', 'Horsebow'),
  jemparingan('jemparingan', 'Jemparingan');

  const BowClass(this.value, this.label);

  final String value;
  final String label;

  static BowClass fromValue(String? value) =>
      BowClass.values.firstWhere((e) => e.value == value, orElse: () => BowClass.recurve);
}

enum DistanceCategory {
  d5m('5m', 5),
  d10m('10m', 10),
  d15m('15m', 15),
  d20m('20m', 20),
  d25m('25m', 25),
  d30m('30m', 30),
  d40m('40m', 40),
  d50m('50m', 50),
  d70m('70m', 70),
  d90m('90m', 90);

  const DistanceCategory(this.value, this.meters);

  final String value;
  final int meters;

  String get label => value;

  static DistanceCategory fromValue(String? value) =>
      DistanceCategory.values.firstWhere((e) => e.value == value, orElse: () => DistanceCategory.d70m);

  /// Nearest category for an arbitrary distance in metres.
  static DistanceCategory fromMeters(int meters) {
    return DistanceCategory.values.reduce(
      (a, b) => (a.meters - meters).abs() <= (b.meters - meters).abs() ? a : b,
    );
  }
}

enum ArcheryEnvironment {
  indoor('indoor', 'Indoor'),
  outdoor('outdoor', 'Outdoor');

  const ArcheryEnvironment(this.value, this.label);

  final String value;
  final String label;

  static ArcheryEnvironment fromValue(String? value) =>
      ArcheryEnvironment.values.firstWhere((e) => e.value == value, orElse: () => ArcheryEnvironment.outdoor);
}

enum ScoringSessionStatus {
  inProgress('in_progress'),
  completed('completed'),
  abandoned('abandoned');

  const ScoringSessionStatus(this.value);

  final String value;

  static ScoringSessionStatus fromValue(String? value) =>
      ScoringSessionStatus.values.firstWhere((e) => e.value == value, orElse: () => ScoringSessionStatus.inProgress);
}
