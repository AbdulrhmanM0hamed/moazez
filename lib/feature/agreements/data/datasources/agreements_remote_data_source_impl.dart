import 'package:dio/dio.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/utils/constant/api_endpoints.dart';
import 'package:moazez/feature/agreements/data/datasources/agreements_remote_data_source.dart';
import 'package:moazez/feature/agreements/data/models/task_model.dart';
import 'package:moazez/feature/agreements/data/models/team_member_model.dart';

class AgreementsRemoteDataSourceImpl implements AgreementsRemoteDataSource {
  final Dio dio;
  final CacheService cacheService;

  AgreementsRemoteDataSourceImpl({
    required this.dio,
    required this.cacheService,
  });

  @override
  Future<List<TeamMemberModel>> getTeamMembers() async {
    final token = await cacheService.getToken();
    final response = await dio.get(
      ApiEndpoints.teamMembers,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200 && response.data != null) {
      final List<dynamic> membersJson = response.data['data']['members'];
      return membersJson.map((json) => TeamMemberModel.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to get team members');
    }
  }

  @override
  Future<void> createTask(TaskModel task) async {
    final token = await cacheService.getToken();
    try {
      final response = await dio.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.createTask}',
        data: task.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus:
              (status) => status != null && status >= 200 && status < 300,
        ),
      );

      if (response.statusCode != 201) {
        throw ServerException(
          message: 'فشل في إنشاء المهمة. كود الخطأ: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        throw ServerException(
          message:
              e.response!.data['message'] ??
              'فشل في إنشاء المهمة. تفاصيل الخطأ: ${e.response!.data}',
        );
      } else {
        throw ServerException(
          message: 'حدث خطأ أثناء الاتصال بالخادم. تفاصيل الخطأ: ${e.message}',
        );
      }
    } catch (e) {
      throw ServerException(message: 'حدث خطأ غير متوقع: $e');
    }
  }

  @override
  Future<String> closeTask({
    required String taskId,
    required String status,
  }) async {
    final token = await cacheService.getToken();
    try {
      final response = await dio.post(
        ApiEndpoints.closeTask,
        data: {'task_id': taskId, 'status': status},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data['message'] as String? ?? 'تم تحديث حالة المهم بنجاح';
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'فشل تحديث حالة المهمة',
      );
    }
  }
}
