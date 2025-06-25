import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/core/network/network_info.dart';
import 'package:moazez/feature/home_supporter/data/datasources/subscription_remote_data_source.dart';
import 'package:moazez/feature/home_supporter/domain/entities/subscription_entity.dart';
import 'package:moazez/feature/home_supporter/domain/repositories/subscription_repository.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SubscriptionRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, SubscriptionEntity>> getCurrentSubscription() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteSubscription = await remoteDataSource.getCurrentSubscription();
        return Right(remoteSubscription);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message ?? 'خطأ غير معروف'));
      }
    } else {
      return Left(ServerFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
  }
}
