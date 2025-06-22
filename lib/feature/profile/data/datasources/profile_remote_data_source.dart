import 'package:dio/dio.dart';
import 'package:moazez/core/error/dio_exception_handler.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/utils/constant/api_endpoints.dart';
import 'package:moazez/feature/profile/data/models/profile_model.dart';
import 'package:moazez/feature/profile/data/models/edit_profile_params.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileResponse> getProfile();
  Future<ProfileResponse> editProfile(EditProfileParams params);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;
  final CacheService cacheService;

  ProfileRemoteDataSourceImpl({required this.dio, required this.cacheService});

  @override
  Future<ProfileResponse> getProfile() async {
    try {
      final token = await cacheService.getToken();
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.get(ApiEndpoints.profile);

      final statusValue = response.data['status'];
      final isSuccess = statusValue == true || statusValue == 'success';
      if (response.statusCode == 200 && isSuccess) {
        return ProfileResponse.fromJson(response.data);
      } else {
        throw DioException(
          error: response.data['message'] ?? 'حدث خطأ غير متوقع',
          response: response,
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: ApiEndpoints.profile),
        );
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.profile),
        error: e.toString(),
        type: DioExceptionType.unknown,
      );
    }
  }

  @override
  Future<ProfileResponse> editProfile(EditProfileParams params) async {
    try {
      final token = await cacheService.getToken();
      final formMap = params.toMap();

      if (params.avatarPath != null) {
        formMap['avatar'] = await MultipartFile.fromFile(
          params.avatarPath!,
          filename: params.avatarPath!.split('/').last,
        );
      }

      final response = await dio.post(
        ApiEndpoints.profile,
        data: FormData.fromMap(formMap),
        options: Options(
          headers: {
            'Accept': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      final statusValue = response.data['status'];
      final isSuccess = statusValue == true || statusValue == 'success';
      if (response.statusCode == 200 && isSuccess) {
        return ProfileResponse.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          error: response.data['message'] ?? 'حدث خطأ غير متوقع',
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.profile),
        error: e.toString(),
        type: DioExceptionType.unknown,
      );
    }
  }
}
