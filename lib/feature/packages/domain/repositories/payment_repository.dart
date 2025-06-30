import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';

abstract class PaymentRepository {
  Future<Either<Failure, Map<String, dynamic>>> initiatePayment(int packageId);
}
