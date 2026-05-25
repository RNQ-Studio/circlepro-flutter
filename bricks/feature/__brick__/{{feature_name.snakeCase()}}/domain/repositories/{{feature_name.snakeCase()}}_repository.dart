import '../entities/{{feature_name.snakeCase()}}_entity.dart';

/// Kontrak repository untuk fitur {{feature_name.titleCase()}}
abstract class {{feature_name.pascalCase()}}Repository {
  Future<List<{{feature_name.pascalCase()}}Entity>> getAll();
  Future<{{feature_name.pascalCase()}}Entity?> getById(String id);
  Future<void> create({{feature_name.pascalCase()}}Entity entity);
  Future<void> update({{feature_name.pascalCase()}}Entity entity);
  Future<void> delete(String id);
}
