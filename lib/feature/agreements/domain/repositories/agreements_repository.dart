import 'package:dartz/dartz.dart' hide Task;
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/agreements/domain/entities/team_member.dart';

import 'package:moazez/feature/agreements/domain/entities/task.dart';

abstract class AgreementsRepository {
  Future<Either<Failure, List<TeamMember>>> getTeamMembers();
  Future<Either<Failure, void>> createTask(Task task);
  Future<Either<Failure, void>> closeTask({required String taskId, required String status});
}
