import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/home/domain/entities/team_entity.dart';

abstract class TeamRepository {
  Future<Either<Failure, TeamEntity>> getTeamInfo();
  Future<Either<Failure, TeamEntity>> createTeam(String teamName);
}
