import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/task_details/data/datasources/task_details_remote_datasoure.dart';
import 'package:moazez/feature/task_details/domain/entities/stage_completion_entity.dart';
import 'package:moazez/feature/task_details/domain/repositories/stage_completion_repository.dart';

class StageCompletionRepositoryImpl implements StageCompletionRepository {
  final TaskDetailsRemoteDataSource remoteDataSource;

  StageCompletionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, StageCompletionEntity>> completeStage({
    required int stageId,
    String? proofNotes,
    String? proofImage,
  }) async {
    try {
      print('Repository: Attempting to complete stage with ID: $stageId');
      final remoteStageCompletion = await remoteDataSource.completeStage(
        stageId: stageId,
        proofNotes: proofNotes,
        proofImage: proofImage,
      );
      print('Repository: Stage completion successful for ID: $stageId');
      return Right(remoteStageCompletion);
    } on ServerException catch (e) {
      print('Repository: ServerException occurred while completing stage: ${e.message}');
      return Left(
        ServerFailure(message: e.message ?? 'حدث خطأ في إكمال المرحلة'),
      );
    } catch (e) {
      print('Repository: Unexpected error occurred while completing stage: $e');
      return Left(
        ServerFailure(message: 'حدث خطأ غير متوقع في إكمال المرحلة'),
      );
    }
  }
}
