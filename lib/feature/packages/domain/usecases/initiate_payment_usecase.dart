import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/core/usecases/usecase.dart';
import 'package:moazez/feature/packages/domain/repositories/payment_repository.dart';

class InitiatePaymentUseCase implements UseCase<Map<String, dynamic>, int> {
  final PaymentRepository repository;

  InitiatePaymentUseCase({required this.repository});

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(int packageId) async {
    return await repository.initiatePayment(packageId);
  }
}
