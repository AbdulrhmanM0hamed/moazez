import 'package:dio/dio.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/utils/constant/api_endpoints.dart';
import 'package:moazez/feature/MyTasks/data/datasources/my_tasks_remote_data_source.dart';
import 'package:moazez/feature/MyTasks/data/models/my_task_model.dart';

class MyTasksRemoteDataSourceImpl implements MyTasksRemoteDataSource {
  final Dio dio;
  final CacheService cacheService;

  MyTasksRemoteDataSourceImpl({required this.dio, required this.cacheService});

  @override
  Future<List<MyTaskModel>> getMyTasks({String? status}) async {
    final token = await cacheService.getToken();
    final Map<String, dynamic> params = status != null ? {'status': status} : {};

    try {
      final response = await dio.get(
        ApiEndpoints.myTasks,
        queryParameters: params,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> tasksJson = response.data['data'];
        return tasksJson.map((json) => MyTaskModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'فشل في الحصول على المهام');
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'فشل في الحصول على المهام',
      );
    }
  }
}
