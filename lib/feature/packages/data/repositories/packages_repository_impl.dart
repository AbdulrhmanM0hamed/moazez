import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:moazez/core/error/dio_exception_handler.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/core/network/network_info.dart';
import 'package:moazez/feature/packages/data/datasources/packages_remote_data_source.dart';
import 'package:moazez/feature/packages/domain/models/package_entity.dart';
import 'package:moazez/feature/packages/domain/repositories/packages_repository.dart';

class PackagesRepositoryImpl implements PackagesRepository {
  final PackagesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PackagesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<PackageEntity>>> getPackages() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'لا يوجد اتصال بالانترنت او حدث خطأ في الشبكة!'));
    }

    try {
      final packages = await remoteDataSource.getPackages();
      return Right(packages);
    } on DioException catch (e) {
      return Left(handleDioException(e));
    } catch (e) {
      return Left(ServerFailure(message: "خطأ غير متوقع: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, PackageEntity>> getTrialPackage() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'لا يوجد اتصال بالانترنت او حدث خطأ في الشبكة!'));
    }

    try {
      final trialPackage = await remoteDataSource.getTrialPackage();
      return Right(trialPackage);
    } on DioException catch (e) {
      return Left(handleDioException(e));
    } catch (e) {
      return Left(ServerFailure(message: "خطأ غير متوقع في جلب الباقة التجريبية: ${e.toString()}"));
    }
  }
}
