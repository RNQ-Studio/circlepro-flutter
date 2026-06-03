import 'package:dio/dio.dart';

import '../domain/archery_range_entity.dart';

class RangesRepository {
  const RangesRepository(this._dio);

  final Dio _dio;

  Future<List<ArcheryRangeEntity>> directory({
    String? search,
    String? facility,
    double? latitude,
    double? longitude,
  }) async {
    final response = await _dio.get('v1/ranges', queryParameters: {
      if (search != null && search.isNotEmpty) 'filter[search]': search,
      if (facility != null && facility.isNotEmpty) 'filter[facility]': facility,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    });
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => ArcheryRangeEntity.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ArcheryRangeEntity> getRange(String id) async {
    final response = await _dio.get('v1/ranges/$id');
    return ArcheryRangeEntity.fromJson(response.data['data'] as Map<String, dynamic>);
  }
}
