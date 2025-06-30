import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import '../entities/payment_entity.dart';

abstract class PaymentsRepository {
  Future<Either<Failure, List<PaymentEntity>>> getPayments();
}
