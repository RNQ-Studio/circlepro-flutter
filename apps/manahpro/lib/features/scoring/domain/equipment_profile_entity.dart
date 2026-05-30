import 'package:equatable/equatable.dart';

import 'scoring_enums.dart';

/// A user's bow/equipment profile (Module 1, task 1.11). Managed online via the
/// backend; linked to scoring sessions.
class EquipmentProfileEntity extends Equatable {
  const EquipmentProfileEntity({
    required this.id,
    required this.name,
    required this.bowClass,
    this.bowModel,
    this.drawWeightLbs,
    this.arrowSpec,
    this.tuningNotes,
    this.isDefault = false,
  });

  final String id;
  final String name;
  final BowClass bowClass;
  final String? bowModel;
  final double? drawWeightLbs;
  final String? arrowSpec;
  final String? tuningNotes;
  final bool isDefault;

  factory EquipmentProfileEntity.fromJson(Map<String, dynamic> json) {
    return EquipmentProfileEntity(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      bowClass: BowClass.fromValue(json['bow_class'] as String?),
      bowModel: json['bow_model'] as String?,
      drawWeightLbs: (json['draw_weight_lbs'] as num?)?.toDouble(),
      arrowSpec: json['arrow_spec'] as String?,
      tuningNotes: json['tuning_notes'] as String?,
      isDefault: json['is_default'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'bow_class': bowClass.value,
        if (bowModel != null) 'bow_model': bowModel,
        if (drawWeightLbs != null) 'draw_weight_lbs': drawWeightLbs,
        if (arrowSpec != null) 'arrow_spec': arrowSpec,
        if (tuningNotes != null) 'tuning_notes': tuningNotes,
        'is_default': isDefault,
      };

  @override
  List<Object?> get props => [id, name, bowClass, bowModel, drawWeightLbs, arrowSpec, tuningNotes, isDefault];
}
