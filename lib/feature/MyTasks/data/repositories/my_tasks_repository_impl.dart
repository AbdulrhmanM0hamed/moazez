import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/MyTasks/data/datasources/my_tasks_remote_data_source.dart';
import 'package:moazez/feature/MyTasks/domain/entities/my_task_entity.dart';
import 'package:moazez/feature/MyTasks/domain/repositories/my_tasks_repository.dart';

class MyTasksRepositoryImpl implements MyTasksRepository {
  final MyTasksRemoteDataSource remoteDataSource;

  MyTasksRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<MyTaskEntity>>> getMyTasks({String? status}) async {
    try {
      final remoteTasks = await remoteDataSource.getMyTasks(status: status);
      return Right(remoteTasks);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Failed to get tasks'));
    }
  }
}
