import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:features_shared/features_shared.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'manah_api.g.dart';

/// Shared authenticated Dio for the online ManahPro features (profile, clubs,
/// feed). Reuses the same token interceptor as the rest of the app.
@Riverpod(keepAlive: true)
Dio manahDio(Ref ref) {
  return DioClient(ref.watch(storageServiceProvider)).dio;
}
