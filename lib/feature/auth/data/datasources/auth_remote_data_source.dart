import 'package:dio/dio.dart';
import 'package:moazez/core/error/dio_exception_handler.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/utils/constant/api_endpoints.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/feature/auth/data/models/auth_model.dart';
import 'package:moazez/feature/profile/data/models/profile_model.dart';
import 'package:moazez/feature/auth/domain/usecases/complete_profile_usecase.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login(String email, String password);
  Future<AuthModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  });
  Future<void> logout();
  Future<UserProfile> completeProfile(CompleteProfileParams params);
  Future<void> subscribeToTrialPackage(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthModel> login(String email, String password) async {
    try {
      final response = await dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
      if (response.data['status'] == 'success') {
        return AuthModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'حدث خطأ غير معروف',
        );
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    }
  }

  @override
  Future<AuthModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiEndpoints.register,
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
      if (response.data['status'] == 'success') {
        return AuthModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'حدث خطأ غير معروف',
        );
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    }
  }

  @override
  Future<UserProfile> completeProfile(CompleteProfileParams params) async {
    try {
      final token = await sl<CacheService>().getToken();
      final formMap = {
        'area_id': params.areaId,
        'city_id': params.cityId,
        'gender': params.gender,
        'birthdate': params.birthdate.toIso8601String(),
      };
      if (params.avatarPath != null) {
        formMap['avatar'] = await MultipartFile.fromFile(
          params.avatarPath!,
          filename: params.avatarPath!.split('/').last,
        );
      }

      final response = await dio.post(
        ApiEndpoints.profile,
        data: FormData.fromMap(formMap),
        options: Options(headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        }),
      );
      if (response.data['status'] == 'success' || response.data['status'] == true) {
        return UserProfile.fromJson(response.data['data']['user']);
      } else {
        throw ServerException(message: response.data['message']);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      final token = await sl<CacheService>().getToken();
      await dio.post(
        ApiEndpoints.logout,
        options: Options(
          headers: {
            'Accept': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );
    } on DioException catch (e) {
      throw handleDioException(e);
    }
  }

  @override
  Future<void> subscribeToTrialPackage(String token) async {
    try {
      await dio.post(
        ApiEndpoints.subscribe,
        data: {'package_id': 1},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } on DioException catch (e) {
      throw handleDioException(e);
    }
  }
}
