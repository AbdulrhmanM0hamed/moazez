import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/auth/domain/repositories/auth_repository.dart';
import 'package:moazez/feature/profile/data/models/profile_model.dart';

class CompleteProfileUseCase {
  final AuthRepository repository;
  CompleteProfileUseCase(this.repository);

  Future<Either<Failure, UserProfile>> call(CompleteProfileParams params) {
    return repository.completeProfile(params);
  }
}

class CompleteProfileParams extends Equatable {
  final int areaId;
  final int cityId;
  final String gender;
  final DateTime birthdate;
  final String? avatarPath;
  // avatar upload not yet supported

  const CompleteProfileParams({
    required this.areaId,
    required this.cityId,
    required this.gender,
    required this.birthdate,
    this.avatarPath,
  });

  @override
  @override
  List<Object?> get props => [areaId, cityId, gender, birthdate, avatarPath];
}
