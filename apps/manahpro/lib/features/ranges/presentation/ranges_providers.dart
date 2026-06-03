import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/api/manah_api.dart';
import '../data/ranges_repository.dart';
import '../domain/archery_range_entity.dart';

part 'ranges_providers.g.dart';

@Riverpod(keepAlive: true)
RangesRepository rangesRepository(Ref ref) {
  return RangesRepository(ref.watch(manahDioProvider));
}

@riverpod
Future<List<ArcheryRangeEntity>> rangeDirectory(
  Ref ref, {
  String? search,
  String? facility,
  double? latitude,
  double? longitude,
}) {
  return ref.watch(rangesRepositoryProvider).directory(
        search: search,
        facility: facility,
        latitude: latitude,
        longitude: longitude,
      );
}

@riverpod
Future<ArcheryRangeEntity> rangeDetail(Ref ref, String id) {
  return ref.watch(rangesRepositoryProvider).getRange(id);
}
