import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/core/network/network_info.dart';
import 'package:moazez/feature/packages/data/datasources/package_remote_data_source.dart';
import 'package:moazez/feature/packages/domain/entities/package_entity.dart';
import 'package:moazez/feature/packages/domain/repositories/package_repository.dart';

class PackageRepositoryImpl implements PackageRepository {
  final PackageRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PackageRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<PackageEntity>>> getPackages() async {
    if (await networkInfo.isConnected) {
      try {
        final remotePackages = await remoteDataSource.getPackages();
        return Right(remotePackages);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message ?? 'فشل في تحميل البيانات'));
      }
    } else {
      return Left(NetworkFailure(message: 'لا يوجد اتصال بالانترنت'));
    }
  }
}
