import 'package:dartz/dartz.dart' hide Task;
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/agreements/domain/entities/task_details_entity.dart';
import 'package:moazez/feature/agreements/domain/entities/team_member.dart';

import 'package:moazez/feature/agreements/domain/entities/task.dart';

abstract class AgreementsRepository {
  Future<Either<Failure, List<TeamMember>>> getTeamMembers();
  Future<Either<Failure, void>> createTask(Task task);
  Future<Either<Failure, String>> closeTask({required String taskId, required String status});
  Future<Either<Failure, TaskDetailsEntity>> getTaskDetails({required int taskId});
}
