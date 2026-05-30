import 'package:dio/dio.dart';

import '../../domain/equipment_profile_entity.dart';

/// Remote CRUD for equipment profiles. `/v1/scoring/equipment-profiles`.
class EquipmentRemoteDataSource {
  const EquipmentRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<EquipmentProfileEntity>> fetchAll() async {
    final response = await _dio.get('v1/scoring/equipment-profiles');
    final data = response.data['data'] as List<dynamic>;
    return data
        .map((e) => EquipmentProfileEntity.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<EquipmentProfileEntity> create(EquipmentProfileEntity profile) async {
    final response = await _dio.post('v1/scoring/equipment-profiles', data: profile.toJson());
    return EquipmentProfileEntity.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<EquipmentProfileEntity> update(EquipmentProfileEntity profile) async {
    final response = await _dio.put(
      'v1/scoring/equipment-profiles/${profile.id}',
      data: profile.toJson(),
    );
    return EquipmentProfileEntity.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> delete(String id) async {
    await _dio.delete('v1/scoring/equipment-profiles/$id');
  }
}
