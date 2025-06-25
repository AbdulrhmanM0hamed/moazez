import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/packages/domain/entities/package_entity.dart';

abstract class PackageRepository {
  Future<Either<Failure, List<PackageEntity>>> getPackages();
}
