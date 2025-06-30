import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import '../entities/payment_entity.dart';
import '../repositories/payments_repository.dart';

class GetPaymentsUseCase {
  final PaymentsRepository repository;
  GetPaymentsUseCase(this.repository);

  Future<Either<Failure, List<PaymentEntity>>> call() async {
    return repository.getPayments();
  }
}
