import 'package:dio/dio.dart';
import 'package:moazez/core/error/dio_exception_handler.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/utils/constant/api_endpoints.dart';
import 'package:moazez/feature/profile/data/models/profile_model.dart';
import 'dart:developer' as dev;

abstract class ProfileRemoteDataSource {
  Future<UserProfile> getProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;
  final CacheService cacheService;

  ProfileRemoteDataSourceImpl({required this.dio, required this.cacheService});

  @override
  Future<UserProfile> getProfile() async {
    try {
      dev.log('Fetching profile...', name: 'ProfileRemoteDataSource');
      final token = await cacheService.getToken();
      dev.log('Token: $token', name: 'ProfileRemoteDataSource');
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.get(ApiEndpoints.profile);
      dev.log('Profile response status: ${response.statusCode}, body: ${response.data}', name: 'ProfileRemoteDataSource');

      final statusValue = response.data['status'];
      final isSuccess = statusValue == true || statusValue == 'success';
      if (response.statusCode == 200 && isSuccess) {
        final profileResponse = ProfileResponse.fromJson(response.data);
        return profileResponse.data.user;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'فشل تحميل الملف الشخصي',
        );
      }
    } on DioException catch (e) {
      dev.log('DioException caught: ${e.message}', error: e, name: 'ProfileRemoteDataSource');
      throw handleDioException(e);
    }
  }
}
