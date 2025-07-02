import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moazez/core/utils/constant/api_endpoints.dart';
import 'package:moazez/feature/home_supporter/data/models/team_model.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/error/dio_exception_handler.dart';
import 'package:moazez/feature/home_supporter/domain/entities/member_stats_entity.dart';

abstract class TeamRemoteDataSource {
  Future<TeamModel> getTeamInfo();
  Future<TeamModel> createTeam(String teamName);
  Future<TeamModel> updateTeamName(String newName);
  Future<TeamModel> removeTeamMember(int memberId);
  Future<MemberTaskStatsResponseEntity> getMemberTaskStats(int page);
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
      if (response.data['status'] == 'success' || response.data['status'] == true || (response.data['message'] == 'تم جلب فريقك الذي تملكه بنجاح') || (response.data['message'] == 'تم جلب فريقك بنجاح')) {
        return TeamModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'حدث خطأ غير معروف',
        );
      }
    } on DioException catch (e) {
      debugPrint(e.response?.data.toString());
      debugPrint(e.response?.statusCode.toString());
      debugPrint(e.response?.headers.toString());
      debugPrint(e.response?.requestOptions.toString());
      debugPrint(e.type.toString());
      debugPrint(e.message.toString());
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
      //debugPrint('Create Team Response: ${response.data}');
      if (response.data['status'] == 'success' || response.data['status'] == true || (response.data['message'] != null && response.data['message'].contains('تم إنشاء الفريق بنجاح'))) {
        if (response.data['data'] != null && response.data['data'] is Map<String, dynamic>) {
          return TeamModel.fromJson(response.data['data']);
        } else if (response.data['team'] != null && response.data['team'] is Map<String, dynamic>) {
          return TeamModel.fromJson(response.data['team']);
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
      if (response.data['status'] == 'success' || response.data['status'] == true || (response.data['message'] == 'تم تعديل اسم الفريق بنجاح')) {
     //   debugPrint('Team Name Updated Successfully: ${response.data['data']}');
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
  Future<TeamModel> removeTeamMember(int memberId) async {
    try {
      final response = await dio.post(
        ApiEndpoints.removeTeamMember,
        data: {
          'member_id': memberId,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${await sl<CacheService>().getToken()}',
          },
        ),
      );
      if (response.data['status'] == 'success' || response.data['status'] == true || (response.data['message']?.contains('تم حذف العضو بنجاح') == true) || (response.data['message']?.contains('تم إزالة العضو من فريقك بنجاح') == true)) {
        if (response.data['data'] != null && response.data['data'] is Map<String, dynamic>) {
          return TeamModel.fromJson(response.data['data']);
        } else {
          // Return a placeholder TeamModel to indicate success without data
          return TeamModel(
            id: 0,
            name: '',
            membersCount: 0,
            isOwner: false,
            members: [],
            ownerId: 0,
            owner: {},
            tasksSummary: {},
            createdAt: '',
            updatedAt: ''
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
  Future<MemberTaskStatsResponseEntity> getMemberTaskStats(int page) async {
    try {
      final response = await dio.get(
        '${ApiEndpoints.baseUrl}team/members-task-stats?page=$page',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${await sl<CacheService>().getToken()}',
          },
        ),
      );
     // debugPrint('Get Member Task Stats Response: ${response.data}');
      if (response.data['status'] == 'success' || response.data['status'] == true || (response.data['message'] == 'تم جلب إحصائيات مهام أعضاء الفريق بنجاح')) {
        //debugPrint('Member Task Stats Retrieved Successfully: ${response.data['data']}');
        return MemberTaskStatsResponseEntity.fromJson(response.data['data']);
      } else {
   //     debugPrint('Member Task Stats Retrieval Failed: ${response.data['message']}');
        throw ServerException(
          message: response.data['message'] ?? 'حدث خطأ غير معروف',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw ServerException(
          message: 'ليس لديك الصلاحية للوصول إلى إحصائيات مهام أعضاء الفريق. (خطأ: 403)',
        );
      }
      debugPrint(e.response?.data.toString());
      debugPrint(e.response?.statusCode.toString());
      debugPrint(e.response?.headers.toString());
      debugPrint(e.response?.requestOptions.toString());
      debugPrint(e.type.toString());
      debugPrint(e.message.toString());
      throw handleDioException(e);
    }
  }
}
