import 'package:equatable/equatable.dart';
import 'package:moazez/feature/packages/domain/entities/package_entity.dart';

abstract class PackageState extends Equatable {
  const PackageState();

  @override
  List<Object?> get props => [];
}

class PackageInitial extends PackageState {}

class PackageLoading extends PackageState {}

class PackageLoaded extends PackageState {
  final List<PackageEntity> packages;

  const PackageLoaded({required this.packages});

  @override
  List<Object?> get props => [packages];
}

class PackageError extends PackageState {
  final String message;

  const PackageError({required this.message});

  @override
  List<Object?> get props => [message];
}
