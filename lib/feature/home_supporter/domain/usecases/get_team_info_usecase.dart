import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/core/usecases/usecase.dart';
import 'package:moazez/feature/home_supporter/domain/entities/team_entity.dart';
import 'package:moazez/feature/home_supporter/domain/repositories/team_repository.dart';

class GetTeamInfoUseCase implements UseCase<TeamEntity, NoParams> {
  final TeamRepository repository;

  GetTeamInfoUseCase({required this.repository});

  @override
  Future<Either<Failure, TeamEntity>> call(NoParams params) async {
    return await repository.getTeamInfo();
  }
}

class CreateTeamUseCase implements UseCase<TeamEntity, String> {
  final TeamRepository repository;

  CreateTeamUseCase({required this.repository});

  @override
  Future<Either<Failure, TeamEntity>> call(String teamName) async {
    return await repository.createTeam(teamName);
  }
}
