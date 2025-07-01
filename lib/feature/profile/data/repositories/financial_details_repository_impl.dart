import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/profile/data/datasources/financial_details_remote_data_source.dart';
import 'package:moazez/feature/profile/domain/entities/financial_details_entity.dart';
import 'package:moazez/feature/profile/domain/repositories/financial_details_repository.dart';

class FinancialDetailsRepositoryImpl implements FinancialDetailsRepository {
  final FinancialDetailsRemoteDataSource remoteDataSource;

  FinancialDetailsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, FinancialDetailsEntity>> getFinancialDetails() async {
    try {
      final remoteFinancialDetails = await remoteDataSource.getFinancialDetails();
      return Right(remoteFinancialDetails);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'حدث خطأ غير متوقع'));
    }
  }
}
