import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/entities/{{feature_name.snakeCase()}}_entity.dart';
import '../domain/usecases/get_{{feature_name.snakeCase()}}_use_case.dart';

part '{{feature_name.snakeCase()}}_notifier.g.dart';

// TODO: Tambahkan provider untuk repository dan use case
// @riverpod
// {{feature_name.pascalCase()}}Repository {{feature_name.camelCase()}}Repository(Ref ref) {
//   return {{feature_name.pascalCase()}}RepositoryImpl(...);
// }

@riverpod
class {{feature_name.pascalCase()}}Notifier extends _${{feature_name.pascalCase()}}Notifier {
  @override
  Future<List<{{feature_name.pascalCase()}}Entity>> build() async {
    // TODO: Wire up use case
    // final repo = ref.watch({{feature_name.camelCase()}}RepositoryProvider);
    // final useCase = Get{{feature_name.pascalCase()}}UseCase(repo);
    // return useCase();
    return [];
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}
