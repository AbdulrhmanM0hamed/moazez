import 'package:dio/dio.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/utils/constant/api_endpoints.dart';
import 'package:moazez/feature/task_details/data/model/stage_completion_model.dart';
import 'package:moazez/feature/task_details/data/model/task_details_model.dart';
import 'package:moazez/feature/task_details/domain/entities/stage_completion_entity.dart';

abstract class TaskDetailsRemoteDataSource {
  Future<TaskDetailsModel> getTaskDetails({required int taskId});
  Future<StageCompletionModel> completeStage({
    required int stageId,
    String? proofNotes,
    String? proofImage,
  });
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

  @override
  Future<StageCompletionModel> completeStage({
    required int stageId,
    String? proofNotes,
    String? proofImage,
  }) async {
    final token = await cacheService.getToken();
    try {
      final formData = FormData.fromMap({
        'stage_id': stageId,
        if (proofNotes != null) 'proof_notes': proofNotes,
      });

      if (proofImage != null && proofImage.isNotEmpty) {
        formData.files.add(MapEntry(
          'proof_image',
          await MultipartFile.fromFile(
            proofImage,
            filename: proofImage.split('/').last,
          ),
        ));
      }

      print('Sending request to complete stage with data: {stage_id: $stageId, proof_notes: $proofNotes}');
      final response = await dio.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.completeStage}',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      print('Response received with status code: ${response.statusCode}');
      if (response.statusCode == 200 && response.data != null) {
        print('Stage completion successful, parsing response data: ${response.data}');
        return StageCompletionModel.fromJson(response.data['data']);
      } else {
        print('Stage completion failed with status code: ${response.statusCode}');
        throw ServerException(message: 'فشل إكمال المرحلة');
      }
    } on DioException catch (e) {
      print('DioException occurred while completing stage: ${e.message}');
      print('Response data if available: ${e.response?.data}');
      throw ServerException(
        message: e.response?.data['message'] ?? 'فشل إكمال المرحلة بسبب خطأ في الخادم',
      );
    }
  }
}
