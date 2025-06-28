import 'package:dartz/dartz.dart' hide Task;
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/agreements/data/datasources/agreements_remote_data_source.dart';
import 'package:moazez/feature/agreements/domain/entities/team_member.dart';
import 'package:moazez/feature/agreements/domain/repositories/agreements_repository.dart';
import 'package:moazez/feature/agreements/data/models/task_model.dart';
import 'package:moazez/feature/agreements/domain/entities/task.dart';

class AgreementsRepositoryImpl implements AgreementsRepository {
  final AgreementsRemoteDataSource remoteDataSource;

  AgreementsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<TeamMember>>> getTeamMembers() async {
    try {
      final remoteMembers = await remoteDataSource.getTeamMembers();
      return Right(remoteMembers);
    } on ServerException {
      return Left(ServerFailure(message: 'حدث خطأ'));
    }
  }

  @override
  Future<Either<Failure, void>> createTask(Task task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      await remoteDataSource.createTask(taskModel);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, String>> closeTask({required String taskId, required String status}) async {
    try {
      final message = await remoteDataSource.closeTask(taskId: taskId, status: status);
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'حدث خطأ'));
    }
  }
}
