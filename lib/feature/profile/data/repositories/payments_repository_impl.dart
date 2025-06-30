import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/error/failures.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/payments_repository.dart';
import '../datasources/payments_remote_data_source.dart';

class PaymentsRepositoryImpl implements PaymentsRepository {
  final PaymentsRemoteDataSource remoteDataSource;
  PaymentsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PaymentEntity>>> getPayments() async {
    try {
      final payments = await remoteDataSource.fetchPayments();
      return Right(payments);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'حدث خطأ'));
    }
  }
}
