import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/core/network/network_info.dart';
import 'package:moazez/feature/packages/data/datasources/payment_remote_data_source.dart';
import 'package:moazez/feature/packages/domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PaymentRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Map<String, dynamic>>> initiatePayment(int packageId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.initiatePayment(packageId);
        return Right(response);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message ?? 'خطأ غير معروف من الخادم'));
      }
    } else {
      return Left(ServerFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
  }
}
