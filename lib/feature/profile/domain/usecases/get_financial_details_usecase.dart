import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/core/usecases/usecase.dart';
import 'package:moazez/feature/profile/domain/entities/financial_details_entity.dart';
import 'package:moazez/feature/profile/domain/repositories/financial_details_repository.dart';

class GetFinancialDetailsUseCase extends UseCase<FinancialDetailsEntity, NoParams> {
  final FinancialDetailsRepository repository;

  GetFinancialDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, FinancialDetailsEntity>> call(NoParams params) async {
    return await repository.getFinancialDetails();
  }
}
