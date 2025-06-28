import 'package:dio/dio.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/utils/constant/api_endpoints.dart';
import 'package:moazez/feature/task_details/data/model/task_details_model.dart';

abstract class TaskDetailsRemoteDataSource {
  Future<TaskDetailsModel> getTaskDetails({required int taskId});
}

class TaskDetailsRemoteDataSourceImpl implements TaskDetailsRemoteDataSource {
  final Dio dio;
  final CacheService cacheService;

  TaskDetailsRemoteDataSourceImpl({
    required this.dio,
    required this.cacheService,
  });

  @override
  Future<TaskDetailsModel> getTaskDetails({required int taskId}) async {
    final token = await cacheService.getToken();
    try {
      final response = await dio.post(
        ApiEndpoints.taskDetails,
        data: {'task_id': taskId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200 && response.data != null) {
        return TaskDetailsModel.fromJson(response.data['data']);
      } else {
        throw ServerException(message: 'فشل جلب تفاصيل المهمة');
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'فشل جلب تفاصيل المهمة',
      );
    }
  }
}
