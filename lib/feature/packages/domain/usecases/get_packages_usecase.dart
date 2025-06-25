import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/packages/domain/entities/package_entity.dart';
import 'package:moazez/feature/packages/domain/repositories/package_repository.dart';

class GetPackagesUseCase {
  final PackageRepository repository;

  GetPackagesUseCase(this.repository);

  Future<Either<Failure, List<PackageEntity>>> call() async {
    return await repository.getPackages();
  }
}
