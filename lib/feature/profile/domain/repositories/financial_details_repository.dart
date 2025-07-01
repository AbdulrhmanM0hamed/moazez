import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/profile/domain/entities/financial_details_entity.dart';

abstract class FinancialDetailsRepository {
  Future<Either<Failure, FinancialDetailsEntity>> getFinancialDetails();
}
