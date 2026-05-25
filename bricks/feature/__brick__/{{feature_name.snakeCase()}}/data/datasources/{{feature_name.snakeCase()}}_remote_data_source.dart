import '../models/{{feature_name.snakeCase()}}_model.dart';

/// Remote data source untuk fitur {{feature_name.titleCase()}}
class {{feature_name.pascalCase()}}RemoteDataSource {
  // TODO: Inject DioClient via constructor
  // const {{feature_name.pascalCase()}}RemoteDataSource(this._client);
  // final DioClient _client;

  Future<List<{{feature_name.pascalCase()}}Model>> fetchAll() async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  Future<{{feature_name.pascalCase()}}Model?> fetchById(String id) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }
}
