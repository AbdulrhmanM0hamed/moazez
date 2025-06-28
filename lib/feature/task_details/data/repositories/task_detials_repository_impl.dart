import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/task_details/data/datasources/task_details_remote_datasoure.dart';
import 'package:moazez/feature/task_details/domain/entites/task_details_entity.dart';
import 'package:moazez/feature/task_details/domain/repositories/task_details_repository.dart';

class TaskDetailsRepositoryImpl implements TaskDetailsRepository {
  final TaskDetailsRemoteDataSource remoteDataSource;

  TaskDetailsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, TaskDetailsEntity>> getTaskDetails({
    required int taskId,
  }) async {
    try {
      final remoteTaskDetails = await remoteDataSource.getTaskDetails(
        taskId: taskId,
      );
      return Right(remoteTaskDetails);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'حدث خطأ في جلب تفاصيل المهمة'),
      );
    }
  }
}
