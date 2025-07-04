import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/packages/domain/entities/subscription_entity.dart';

abstract class SubscriptionRepository {
  Future<Either<Failure, SubscriptionEntity>> getCurrentSubscription();
}
