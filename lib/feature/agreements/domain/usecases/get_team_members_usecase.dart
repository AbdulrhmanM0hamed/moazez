import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/core/usecases/usecase.dart';
import 'package:moazez/feature/agreements/domain/entities/team_member.dart';
import 'package:moazez/feature/agreements/domain/repositories/agreements_repository.dart';

class GetTeamMembersUsecase extends UseCase<List<TeamMember>, NoParams> {
  final AgreementsRepository repository;

  GetTeamMembersUsecase(this.repository);

  @override
  Future<Either<Failure, List<TeamMember>>> call(NoParams params) async {
    return await repository.getTeamMembers();
  }
}
