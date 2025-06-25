import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/rewards/domain/entities/reward_entity.dart';

abstract class RewardRepository {
  Future<Either<Failure, List<RewardEntity>>> getTeamRewards();
  Future<Either<Failure, List<RewardEntity>>> getMyRewards();
}
