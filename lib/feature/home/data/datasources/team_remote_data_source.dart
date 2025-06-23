import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moazez/core/utils/constant/api_endpoints.dart';
import 'package:moazez/feature/home/data/models/team_model.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/error/dio_exception_handler.dart';

abstract class TeamRemoteDataSource {
  Future<TeamModel> getTeamInfo();
  Future<TeamModel> createTeam(String teamName);
  Future<TeamModel> updateTeamName(String newName);
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
      debugPrint('Get Team Info Response: ${response.data}');
      if (response.data['status'] == 'success' || response.data['status'] == true || (response.data['message'] == 'تم جلب فريقك الذي تملكه بنجاح')) {
        debugPrint('Team Data Retrieved Successfully: ${response.data['data']}');
        if (response.data['data'] != null && response.data['data'] is Map<String, dynamic>) {
          return TeamModel.fromJson(response.data['data']);
        } else {
          throw ServerException(
            message: 'البيانات المسترجعة غير صحيحة أو فارغة',
          );
        }
      } else {
        debugPrint('Team Data Retrieval Failed: ${response.data['message']}');
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
        if (response.data['data'] != null && response.data['data'] is Map<String, dynamic>) {
          return TeamModel.fromJson(response.data['data']);
        } else {
          throw ServerException(
            message: 'البيانات المسترجعة غير صحيحة أو فارغة',
          );
        }
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
  Future<TeamModel> updateTeamName(String newName) async {
    try {
      final response = await dio.post(
        '${ApiEndpoints.baseUrl}team/update-name',
        data: {
          'name': newName,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${await sl<CacheService>().getToken()}',
          },
        ),
      );
      debugPrint('Update Team Name Response: ${response.data}');
      if (response.data['status'] == 'success' || response.data['status'] == true || (response.data['message'] == 'تم تعديل اسم الفريق بنجاح')) {
        debugPrint('Team Name Updated Successfully: ${response.data['team']}');
        if (response.data['team'] != null && response.data['team'] is Map<String, dynamic>) {
          return TeamModel.fromJson(response.data['team']);
        } else {
          throw ServerException(
            message: 'البيانات المسترجعة غير صحيحة أو فارغة',
          );
        }
      } else {
        debugPrint('Team Name Update Failed: ${response.data['message']}');
        throw ServerException(
          message: response.data['message'] ?? 'حدث خطأ غير معروف',
        );
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    }
  }
}
