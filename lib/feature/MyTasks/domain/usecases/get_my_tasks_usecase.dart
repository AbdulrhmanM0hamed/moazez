import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/core/usecases/usecase.dart';
import 'package:moazez/feature/MyTasks/domain/entities/my_task_entity.dart';
import 'package:moazez/feature/MyTasks/domain/repositories/my_tasks_repository.dart';

class GetMyTasksUseCase extends UseCase<List<MyTaskEntity>, GetMyTasksParams> {
  final MyTasksRepository repository;

  GetMyTasksUseCase(this.repository);

  @override
  Future<Either<Failure, List<MyTaskEntity>>> call(GetMyTasksParams params) async {
    return await repository.getMyTasks(status: params.status);
  }
}

class GetMyTasksParams {
  final String? status;

  GetMyTasksParams({this.status});
}
