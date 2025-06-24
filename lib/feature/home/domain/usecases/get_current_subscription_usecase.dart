import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/core/usecases/usecase.dart';
import 'package:moazez/feature/home/domain/entities/subscription_entity.dart';
import 'package:moazez/feature/home/domain/repositories/subscription_repository.dart';

class GetCurrentSubscriptionUseCase implements UseCase<SubscriptionEntity, NoParams> {
  final SubscriptionRepository repository;

  GetCurrentSubscriptionUseCase(this.repository);

  @override
  Future<Either<Failure, SubscriptionEntity>> call(NoParams params) async {
    return await repository.getCurrentSubscription();
  }
}
