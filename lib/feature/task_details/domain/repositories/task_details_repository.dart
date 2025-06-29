import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/task_details/domain/entities/task_details_entity.dart';

abstract class TaskDetailsRepository {
  Future<Either<Failure, TaskDetailsEntity>> getTaskDetails({
    required int taskId,
  });
}
