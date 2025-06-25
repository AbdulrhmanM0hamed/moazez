import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/core/network/network_info.dart';
import 'package:moazez/feature/rewards/data/datasources/reward_remote_data_source.dart';
import 'package:moazez/feature/rewards/domain/entities/reward_entity.dart';
import 'package:moazez/feature/rewards/domain/repositories/reward_repository.dart';

class RewardRepositoryImpl implements RewardRepository {
  final RewardRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  RewardRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<RewardEntity>>> getTeamRewards() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteRewards = await remoteDataSource.getTeamRewards();
        return Right(remoteRewards);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message ?? 'خطأ في الخادم'));
      }
    } else {
      return Left(ServerFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, List<RewardEntity>>> getMyRewards() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteRewards = await remoteDataSource.getMyRewards();
        return Right(remoteRewards);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message ?? 'خطأ في الخادم'));
      }
    } else {
      return Left(ServerFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
  }
}
