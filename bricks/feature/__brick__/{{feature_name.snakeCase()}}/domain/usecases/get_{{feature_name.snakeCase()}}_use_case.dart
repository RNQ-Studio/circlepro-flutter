import '../entities/{{feature_name.snakeCase()}}_entity.dart';
import '../repositories/{{feature_name.snakeCase()}}_repository.dart';

/// Use case: ambil semua data {{feature_name.titleCase()}}
class Get{{feature_name.pascalCase()}}UseCase {
  const Get{{feature_name.pascalCase()}}UseCase(this._repository);

  final {{feature_name.pascalCase()}}Repository _repository;

  Future<List<{{feature_name.pascalCase()}}Entity>> call() =>
      _repository.getAll();
}
