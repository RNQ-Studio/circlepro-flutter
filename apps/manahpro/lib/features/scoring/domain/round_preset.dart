import 'package:equatable/equatable.dart';

import 'scoring_enums.dart';

enum RoundPresetCategory {
  worldArchery('World Archery'),
  latihanNasional('Latihan Nasional'),
  tradisional('Tradisional');

  const RoundPresetCategory(this.label);

  final String label;
}

class RoundPreset extends Equatable {
  const RoundPreset({
    required this.key,
    required this.label,
    required this.category,
    required this.distanceCategory,
    required this.distanceM,
    required this.environment,
    required this.numEnds,
    required this.arrowsPerEnd,
    required this.targetFaceCm,
    required this.sighterEndCount,
    this.description,
  });

  final String key;
  final String label;
  final String? description;
  final RoundPresetCategory category;
  final DistanceCategory distanceCategory;
  final int distanceM;
  final ArcheryEnvironment environment;
  final int numEnds;
  final int arrowsPerEnd;
  final int? targetFaceCm;
  final int sighterEndCount;

  int get countedEndCount => numEnds - sighterEndCount;

  int get countedArrows => countedEndCount * arrowsPerEnd;

  static const List<RoundPreset> values = [
    RoundPreset(
      key: 'wa_70m_720',
      label: 'WA 70m / 720',
      description: '70m, 12x6, target 122cm',
      category: RoundPresetCategory.worldArchery,
      distanceCategory: DistanceCategory.d70m,
      distanceM: 70,
      environment: ArcheryEnvironment.outdoor,
      numEnds: 12,
      arrowsPerEnd: 6,
      targetFaceCm: 122,
      sighterEndCount: 2,
    ),
    RoundPreset(
      key: 'wa_50m_compound_720',
      label: 'WA 50m Compound',
      description: '50m, 12x6, target 80cm',
      category: RoundPresetCategory.worldArchery,
      distanceCategory: DistanceCategory.d50m,
      distanceM: 50,
      environment: ArcheryEnvironment.outdoor,
      numEnds: 12,
      arrowsPerEnd: 6,
      targetFaceCm: 80,
      sighterEndCount: 2,
    ),
    RoundPreset(
      key: 'wa_18m_indoor',
      label: 'WA 18m Indoor',
      description: '18m, 20x3, target 40cm',
      category: RoundPresetCategory.worldArchery,
      distanceCategory: DistanceCategory.d20m,
      distanceM: 18,
      environment: ArcheryEnvironment.indoor,
      numEnds: 20,
      arrowsPerEnd: 3,
      targetFaceCm: 40,
      sighterEndCount: 2,
    ),
    RoundPreset(
      key: 'latihan_50m_36',
      label: 'Latihan 50m',
      description: '50m, 6x6, target 122cm',
      category: RoundPresetCategory.latihanNasional,
      distanceCategory: DistanceCategory.d50m,
      distanceM: 50,
      environment: ArcheryEnvironment.outdoor,
      numEnds: 6,
      arrowsPerEnd: 6,
      targetFaceCm: 122,
      sighterEndCount: 1,
    ),
    RoundPreset(
      key: 'latihan_30m_36',
      label: 'Latihan 30m',
      description: '30m, 6x6, target 80cm',
      category: RoundPresetCategory.latihanNasional,
      distanceCategory: DistanceCategory.d30m,
      distanceM: 30,
      environment: ArcheryEnvironment.outdoor,
      numEnds: 6,
      arrowsPerEnd: 6,
      targetFaceCm: 80,
      sighterEndCount: 1,
    ),
    RoundPreset(
      key: 'jemparingan_30m_30',
      label: 'Jemparingan 30m',
      description: '30m, 10x3, latihan tradisional',
      category: RoundPresetCategory.tradisional,
      distanceCategory: DistanceCategory.d30m,
      distanceM: 30,
      environment: ArcheryEnvironment.outdoor,
      numEnds: 10,
      arrowsPerEnd: 3,
      targetFaceCm: null,
      sighterEndCount: 1,
    ),
  ];

  static RoundPreset? byKey(String key) {
    for (final preset in values) {
      if (preset.key == key) return preset;
    }
    return null;
  }

  static List<RoundPreset> byCategory(RoundPresetCategory category) =>
      values.where((preset) => preset.category == category).toList();

  @override
  List<Object?> get props => [
        key,
        label,
        description,
        category,
        distanceCategory,
        distanceM,
        environment,
        numEnds,
        arrowsPerEnd,
        targetFaceCm,
        sighterEndCount,
      ];
}
