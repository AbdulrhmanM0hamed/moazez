import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/MyTasks/domain/entities/my_task_entity.dart';

abstract class MyTasksRepository {
  Future<Either<Failure, List<MyTaskEntity>>> getMyTasks({String? status});
}
