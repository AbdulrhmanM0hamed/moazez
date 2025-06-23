import 'package:dio/dio.dart';
import 'package:moazez/core/utils/constant/api_endpoints.dart';
import 'package:moazez/feature/home/data/models/team_model.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/error/dio_exception_handler.dart';

abstract class TeamRemoteDataSource {
  Future<TeamModel> getTeamInfo();
  Future<TeamModel> createTeam(String teamName);
}

class TeamRemoteDataSourceImpl implements TeamRemoteDataSource {
  final Dio dio;

  TeamRemoteDataSourceImpl({required this.dio});

  @override
  Future<TeamModel> getTeamInfo() async {
    try {
      final response = await dio.get(
        ApiEndpoints.myTeam,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${await sl<CacheService>().getToken()}',
          },
        ),
      );
      if (response.data['status'] == 'success' || response.data['status'] == true) {
        return TeamModel.fromJson(response.data['data']);
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
  Future<TeamModel> createTeam(String teamName) async {
    try {
      final response = await dio.post(
        '${ApiEndpoints.baseUrl}team/create',
        data: {
          'name': teamName,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${await sl<CacheService>().getToken()}',
          },
        ),
      );
      if (response.data['status'] == 'success' || response.data['status'] == true) {
        return TeamModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'حدث خطأ غير معروف',
        );
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    }
  }
}
