import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/agreements/domain/entities/task_details_entity.dart';
import 'package:moazez/feature/agreements/domain/repositories/agreements_repository.dart';

class GetTaskDetailsUseCase {
  final AgreementsRepository repository;

  GetTaskDetailsUseCase(this.repository);

  Future<Either<Failure, TaskDetailsEntity>> call({required int taskId}) async {
    return await repository.getTaskDetails(taskId: taskId);
  }
}
