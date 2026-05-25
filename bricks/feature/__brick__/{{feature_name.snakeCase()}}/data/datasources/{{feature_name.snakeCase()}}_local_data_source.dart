import '../models/{{feature_name.snakeCase()}}_model.dart';

/// Local data source untuk fitur {{feature_name.titleCase()}}
class {{feature_name.pascalCase()}}LocalDataSource {
  // TODO: Inject database or storage via constructor

  Future<List<{{feature_name.pascalCase()}}Model>> getCachedAll() async {
    // TODO: Implement local cache read
    return [];
  }

  Future<void> cacheAll(List<{{feature_name.pascalCase()}}Model> items) async {
    // TODO: Implement local cache write
  }
}
