import '../../domain/entities/{{feature_name.snakeCase()}}_entity.dart';

/// Model DTO untuk fitur {{feature_name.titleCase()}}
class {{feature_name.pascalCase()}}Model extends {{feature_name.pascalCase()}}Entity {
  const {{feature_name.pascalCase()}}Model({
    required super.id,
  });

  factory {{feature_name.pascalCase()}}Model.fromJson(Map<String, dynamic> json) {
    return {{feature_name.pascalCase()}}Model(
      id: json['id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}
