import '../entities/{{feature_name.snakeCase()}}_entity.dart';
import '../repositories/{{feature_name.snakeCase()}}_repository.dart';

/// Use case: buat data {{feature_name.titleCase()}} baru
class Create{{feature_name.pascalCase()}}UseCase {
  const Create{{feature_name.pascalCase()}}UseCase(this._repository);

  final {{feature_name.pascalCase()}}Repository _repository;

  Future<void> call({{feature_name.pascalCase()}}Entity entity) =>
      _repository.create(entity);
}
