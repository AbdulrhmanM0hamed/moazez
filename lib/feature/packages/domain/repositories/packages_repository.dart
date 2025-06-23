import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/packages/domain/models/package_entity.dart';

abstract class PackagesRepository {
  Future<Either<Failure, List<PackageEntity>>> getPackages();
  Future<Either<Failure, PackageEntity>> getTrialPackage();
}
