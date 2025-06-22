import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/profile/data/models/profile_model.dart';
import 'package:moazez/feature/profile/data/models/edit_profile_params.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileResponse>> getProfile();
  Future<Either<Failure, ProfileResponse>> editProfile(EditProfileParams params);
}
