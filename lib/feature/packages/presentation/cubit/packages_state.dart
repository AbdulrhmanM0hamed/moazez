import 'package:moazez/feature/packages/domain/models/package_entity.dart';

sealed class PackagesState {}

class PackagesLoading extends PackagesState {}

class PackagesLoaded extends PackagesState {
  final PackageEntity? trialPackage;
  final List<PackageEntity> packages;

  PackagesLoaded({
    this.trialPackage,
    required this.packages,
  });
}

class PackagesError extends PackagesState {
  final String message;

  PackagesError(this.message);
}
