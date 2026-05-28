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

  /// Creates a new quote on the server.
  ///
  /// `POST /v1/quotes`
  /// Returns the created [QuoteModel] from `response.data['data']`.
  Future<QuoteModel> create({
    required String text,
    required String author,
    String? source,
    bool isActive = true,
  }) async {
    final response = await _dio.post(
      'v1/quotes',
      data: {
        'text': text,
        'author': author,
        if (source != null) 'source': source,
        'is_active': isActive,
      },
    );
    return QuoteModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  /// Updates an existing quote on the server.
  ///
  /// `PUT /v1/quotes/{id}`
  /// Returns the updated [QuoteModel] from `response.data['data']`.
  Future<QuoteModel> update({
    required int id,
    String? text,
    String? author,
    String? source,
    bool? isActive,
  }) async {
    final body = <String, dynamic>{};
    if (text != null) body['text'] = text;
    if (author != null) body['author'] = author;
    if (source != null) body['source'] = source;
    if (isActive != null) body['is_active'] = isActive;

    final response = await _dio.put('v1/quotes/$id', data: body);
    return QuoteModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  /// Deletes a quote on the server.
  ///
  /// `DELETE /v1/quotes/{id}`
  Future<void> delete(int id) async {
    await _dio.delete('v1/quotes/$id');
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
