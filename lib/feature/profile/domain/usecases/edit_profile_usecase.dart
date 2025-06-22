import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/profile/data/models/profile_model.dart';
import 'package:moazez/feature/profile/domain/repositories/profile_repository.dart';
import 'package:moazez/feature/profile/data/models/edit_profile_params.dart';

class EditProfileUseCase {
  final ProfileRepository repository;

  EditProfileUseCase({required this.repository});

  Future<Either<Failure, ProfileResponse>> call(EditProfileParams params) async {
    return await repository.editProfile(params);
  }
}
