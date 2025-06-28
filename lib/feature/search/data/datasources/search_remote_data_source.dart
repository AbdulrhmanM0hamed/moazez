import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/constant/api_endpoints.dart';
import 'package:moazez/feature/search/data/models/search_result_model.dart';
import 'package:dio/dio.dart';
import 'package:moazez/core/error/dio_exception_handler.dart';
import 'package:moazez/core/error/exceptions.dart';

abstract class SearchRemoteDataSource {
  Future<SearchResultModel> search({
    required String query,
    required String type,
  });
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio dio;

  SearchRemoteDataSourceImpl({required this.dio});

  @override
  Future<SearchResultModel> search({
    required String query,
    required String type,
  }) async {
    try {
      final token = await sl<CacheService>().getToken();
      debugPrint('--- Search Auth Token: $token ---');
      final response = await dio.post(
        ApiEndpoints.search,
        data: {'query': query, 'type': type},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.data['status'] == 'success') {
        return SearchResultModel.fromJson(response.data['data']);
      } else {
        throw ServerException(message: response.data['message'] ?? 'حدث خطأ');
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    }
  }
}
