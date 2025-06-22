import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/profile/data/models/profile_model.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserProfile>> getProfile();
}
