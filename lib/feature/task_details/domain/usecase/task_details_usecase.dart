import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/task_details/domain/entites/task_details_entity.dart';
import 'package:moazez/feature/task_details/domain/repositories/task_details_repository.dart';

 class TaskDetailsUseCase {
  final TaskDetailsRepository taskDetailsRepository;

  TaskDetailsUseCase(this.taskDetailsRepository);

  Future<Either<Failure, TaskDetailsEntity>> call(int taskId) async {
    return taskDetailsRepository.getTaskDetails(taskId: taskId);
  }
}
