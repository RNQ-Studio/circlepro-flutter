import '../../domain/entities/{{feature_name.snakeCase()}}_entity.dart';
import '../../domain/repositories/{{feature_name.snakeCase()}}_repository.dart';
import '../datasources/{{feature_name.snakeCase()}}_remote_data_source.dart';

/// Implementasi repository untuk fitur {{feature_name.titleCase()}}
class {{feature_name.pascalCase()}}RepositoryImpl implements {{feature_name.pascalCase()}}Repository {
  const {{feature_name.pascalCase()}}RepositoryImpl(this._remoteDataSource);

  final {{feature_name.pascalCase()}}RemoteDataSource _remoteDataSource;

  @override
  Future<List<{{feature_name.pascalCase()}}Entity>> getAll() =>
      _remoteDataSource.fetchAll();

  @override
  Future<{{feature_name.pascalCase()}}Entity?> getById(String id) =>
      _remoteDataSource.fetchById(id);

  @override
  Future<void> create({{feature_name.pascalCase()}}Entity entity) {
    // TODO: Implement create
    throw UnimplementedError();
  }

  @override
  Future<void> update({{feature_name.pascalCase()}}Entity entity) {
    // TODO: Implement update
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String id) {
    // TODO: Implement delete
    throw UnimplementedError();
  }
}
