import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/profile/data/datasources/user_subscriptions_remote_data_source.dart';
import 'package:moazez/feature/profile/domain/entities/user_subscription_entity.dart';
import 'package:moazez/feature/profile/domain/repositories/user_subscriptions_repository.dart';

class UserSubscriptionsRepositoryImpl implements UserSubscriptionsRepository {
  final UserSubscriptionsRemoteDataSource remoteDataSource;
  UserSubscriptionsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<UserSubscriptionEntity>>> getUserSubscriptions() async {
    try {
      final subs = await remoteDataSource.getUserSubscriptions();
      return Right(subs);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
