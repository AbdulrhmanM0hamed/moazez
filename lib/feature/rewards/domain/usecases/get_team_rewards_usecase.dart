import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/core/usecases/usecase.dart';
import 'package:moazez/feature/rewards/domain/entities/reward_entity.dart';
import 'package:moazez/feature/rewards/domain/repositories/reward_repository.dart';

class GetTeamRewardsUseCase implements UseCase<List<RewardEntity>, NoParams> {
  final RewardRepository repository;

  GetTeamRewardsUseCase(this.repository);

  @override
  Future<Either<Failure, List<RewardEntity>>> call(NoParams params) async {
    return await repository.getTeamRewards();
  }
}
