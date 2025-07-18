import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/core/usecases/usecase.dart';
import 'package:moazez/feature/task_details/domain/entities/stage_completion_entity.dart';
import 'package:moazez/feature/task_details/domain/repositories/stage_completion_repository.dart';

class CompleteStageUseCase implements UseCase<StageCompletionEntity, CompleteStageParams> {
  final StageCompletionRepository repository;

  CompleteStageUseCase({required this.repository});

  @override
  Future<Either<Failure, StageCompletionEntity>> call(CompleteStageParams params) async {
    try {
      final result = await repository.completeStage(
        stageId: params.stageId,
        proofNotes: params.proofNotes,
        proofImage: params.proofImage,
      );
      return result;
    } catch (e) {
    //  print('Error in CompleteStageUseCase: $e');
      return Left(ServerFailure(message: 'فشل في إكمال المرحلة: $e'));
    }
  }
}

class CompleteStageParams {
  final int stageId;
  final String? proofNotes;
  final String? proofImage;

  CompleteStageParams({
    required this.stageId,
    this.proofNotes,
    this.proofImage,
  });
}
