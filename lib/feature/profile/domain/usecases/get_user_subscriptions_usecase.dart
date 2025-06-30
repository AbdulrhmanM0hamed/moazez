import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/profile/domain/entities/user_subscription_entity.dart';
import 'package:moazez/feature/profile/domain/repositories/user_subscriptions_repository.dart';

class GetUserSubscriptionsUseCase {
  final UserSubscriptionsRepository repository;
  GetUserSubscriptionsUseCase(this.repository);

  Future<Either<Failure, List<UserSubscriptionEntity>>> call() async {
    return repository.getUserSubscriptions();
  }
}
