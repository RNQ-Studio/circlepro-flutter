import 'package:dio/dio.dart';

import '../models/quote_model.dart';

/// Remote data source for Quotes API operations.
///
/// Communicates with the Laravel Starter backend via Dio.
/// All endpoints are relative to the base URL configured in [DioClient].
class QuotesRemoteDataSource {
  const QuotesRemoteDataSource(this._dio);

  final Dio _dio;

  /// Fetches all quotes from the server.
  ///
  /// `GET /v1/quotes`
  /// Returns a list of [QuoteModel] parsed from `response.data['data']`.
  Future<List<QuoteModel>> fetchAll() async {
    final response = await _dio.get('v1/quotes');
    final data = response.data['data'] as List<dynamic>;
    return data
        .map((json) => QuoteModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }


  /// Checks whether the server is reachable.
  ///
  /// `GET /v1/health`
  /// Returns `true` if the server responds successfully, `false` otherwise.
  Future<bool> checkHealth() async {
    try {
      final response = await _dio.get('v1/health');
      return response.data['success'] == true;
    } on DioException {
      return false;
    } catch (_) {
      return false;
    }
  }
}
