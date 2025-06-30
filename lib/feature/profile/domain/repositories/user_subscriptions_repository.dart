import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import '../entities/user_subscription_entity.dart';

abstract class UserSubscriptionsRepository {
  Future<Either<Failure, List<UserSubscriptionEntity>>> getUserSubscriptions();
}
