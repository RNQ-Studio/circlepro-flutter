import 'package:equatable/equatable.dart';

import 'scoring_enums.dart';

/// A single arrow's score.
class ArrowScore extends Equatable {
  const ArrowScore({
    required this.id,
    required this.arrowIndex,
    required this.scoreValue,
    this.isX = false,
    this.isMiss = false,
  });

  final String id;
  final int arrowIndex;
  final int scoreValue; // 0-10 (M = 0 + isMiss)
  final bool isX;
  final bool isMiss;

  /// Label shown in arrow slots: 'X', 'M', or the numeric value.
  String get displayValue {
    if (isMiss) return 'M';
    if (isX) return 'X';
    return '$scoreValue';
  }

  bool get isTen => isX || scoreValue == 10;

  @override
  List<Object?> get props => [id, arrowIndex, scoreValue, isX, isMiss];
}

/// One end (rambahan) — a group of arrows shot together.
class ScoringEndEntity extends Equatable {
  const ScoringEndEntity({
    required this.id,
    required this.endNumber,
    this.arrows = const [],
  });

  final String id;
  final int endNumber;
  final List<ArrowScore> arrows;

  int get endTotal => arrows.fold(0, (sum, a) => sum + a.scoreValue);

  ScoringEndEntity copyWith({List<ArrowScore>? arrows}) => ScoringEndEntity(
        id: id,
        endNumber: endNumber,
        arrows: arrows ?? this.arrows,
      );

  @override
  List<Object?> get props => [id, endNumber, arrows];
}

/// A scoring session owned by the current user (offline-first).
class ScoringSessionEntity extends Equatable {
  const ScoringSessionEntity({
    required this.id,
    required this.clientUuid,
    required this.bowClass,
    required this.distanceCategory,
    required this.distanceM,
    required this.numEnds,
    required this.arrowsPerEnd,
    this.equipmentProfileId,
    this.title,
    this.environment = ArcheryEnvironment.outdoor,
    this.targetFaceCm,
    this.targetFaceId,
    this.status = ScoringSessionStatus.inProgress,
    this.notes,
    required this.startedAt,
    this.completedAt,
    this.isPersonalBest = false,
    this.isSynced = false,
    this.syncAction,
    this.ends = const [],
    this.maxPossibleScoreOverride,
  });

  final String id;
  final String clientUuid;
  final String? equipmentProfileId;
  final String? title;
  final BowClass bowClass;
  final DistanceCategory distanceCategory;
  final int distanceM;
  final ArcheryEnvironment environment;
  final int? targetFaceCm;
  final String? targetFaceId;
  final int numEnds;
  final int arrowsPerEnd;
  final ScoringSessionStatus status;
  final String? notes;
  final DateTime startedAt;
  final DateTime? completedAt;
  final bool isPersonalBest;
  final bool isSynced;
  final String? syncAction;
  final List<ScoringEndEntity> ends;
  final int? maxPossibleScoreOverride;

  // ─── Derived aggregates (computed from arrows) ──────────────────
  Iterable<ArrowScore> get _allArrows => ends.expand((e) => e.arrows);

  int get totalScore => _allArrows.fold(0, (sum, a) => sum + a.scoreValue);

  int get arrowsShot => _allArrows.length;

  int get maxPossibleScore => maxPossibleScoreOverride ?? (numEnds * arrowsPerEnd * 10);

  int get xCount => _allArrows.where((a) => a.isX).length;

  int get tenCount => _allArrows.where((a) => a.isTen).length;

  int get missCount => _allArrows.where((a) => a.isMiss).length;

  double? get avgPerArrow => arrowsShot == 0 ? null : totalScore / arrowsShot;

  int get plannedArrows => numEnds * arrowsPerEnd;

  bool get isComplete => arrowsShot >= plannedArrows;

  ScoringSessionEntity copyWith({
    ScoringSessionStatus? status,
    DateTime? completedAt,
    bool? isPersonalBest,
    bool? isSynced,
    String? syncAction,
    String? notes,
    List<ScoringEndEntity>? ends,
  }) {
    return ScoringSessionEntity(
      id: id,
      clientUuid: clientUuid,
      equipmentProfileId: equipmentProfileId,
      title: title,
      bowClass: bowClass,
      distanceCategory: distanceCategory,
      distanceM: distanceM,
      environment: environment,
      targetFaceCm: targetFaceCm,
      numEnds: numEnds,
      arrowsPerEnd: arrowsPerEnd,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      startedAt: startedAt,
      completedAt: completedAt ?? this.completedAt,
      isPersonalBest: isPersonalBest ?? this.isPersonalBest,
      isSynced: isSynced ?? this.isSynced,
      syncAction: syncAction ?? this.syncAction,
      ends: ends ?? this.ends,
    );
  }

  @override
  List<Object?> get props => [
        id,
        clientUuid,
        status,
        isPersonalBest,
        isSynced,
        syncAction,
        notes,
        completedAt,
        ends,
      ];
}

class TargetFaceRule extends Equatable {
  const TargetFaceRule({
    required this.value,
    required this.label,
    required this.colorHex,
    this.isX = false,
    this.isMiss = false,
  });

  final int value;
  final String label;
  final String colorHex;
  final bool isX;
  final bool isMiss;

  factory TargetFaceRule.fromJson(Map<String, dynamic> json) {
    return TargetFaceRule(
      value: json['value'] as int? ?? 0,
      label: json['label'] as String? ?? '',
      colorHex: json['color'] as String? ?? '#000000',
      isX: json['is_x'] as bool? ?? false,
      isMiss: json['is_miss'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'label': label,
      'color': colorHex,
      'is_x': isX,
      'is_miss': isMiss,
    };
  }

  @override
  List<Object?> get props => [value, label, colorHex, isX, isMiss];
}

class TargetFaceEntity extends Equatable {
  const TargetFaceEntity({
    required this.id,
    this.organizationId,
    this.organizationName,
    this.organizationSlug,
    required this.code,
    required this.name,
    this.imagePath,
    this.usedCount = 0,
    required this.scoringRules,
  });

  final String id;
  final String? organizationId;
  final String? organizationName;
  final String? organizationSlug;
  final String code;
  final String name;
  final String? imagePath;
  final int usedCount;
  final List<TargetFaceRule> scoringRules;

  factory TargetFaceEntity.fromJson(Map<String, dynamic> json) {
    final rulesJson = json['scoring_rules'] as List<dynamic>? ?? [];
    final orgJson = json['organization'] as Map<String, dynamic>?;
    return TargetFaceEntity(
      id: json['id'] as String? ?? '',
      organizationId: json['organization_id'] as String?,
      organizationName: orgJson?['name'] as String?,
      organizationSlug: orgJson?['slug'] as String?,
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      imagePath: json['image_path'] as String?,
      usedCount: json['used_count'] as int? ?? json['total_participants'] as int? ?? 0,
      scoringRules: rulesJson.map((r) => TargetFaceRule.fromJson(r as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'organization_name': organizationName,
      'organization_slug': organizationSlug,
      'code': code,
      'name': name,
      'image_path': imagePath,
      'used_count': usedCount,
      'scoring_rules': scoringRules.map((r) => r.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [id, organizationId, organizationName, organizationSlug, code, name, imagePath, usedCount, scoringRules];
}
