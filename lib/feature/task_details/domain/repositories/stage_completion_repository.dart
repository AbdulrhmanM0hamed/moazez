import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/task_details/domain/entities/stage_completion_entity.dart';

abstract class StageCompletionRepository {
  Future<Either<Failure, StageCompletionEntity>> completeStage({
    required int stageId,
    String? proofNotes,
    String? proofImage,
  });
}
