import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/home_supporter/domain/entities/member_stats_entity.dart';
import 'package:moazez/feature/home_supporter/domain/entities/team_entity.dart';

abstract class TeamRepository {
  Future<Either<Failure, TeamEntity>> getTeamInfo();
  Future<Either<Failure, TeamEntity>> createTeam(String teamName);
  Future<Either<Failure, TeamEntity>> updateTeamName(String newName);
  Future<Either<Failure, TeamEntity>> removeTeamMember(int memberId);
  Future<Either<Exception, MemberTaskStatsResponseEntity>> getMemberTaskStats(int page);
}
