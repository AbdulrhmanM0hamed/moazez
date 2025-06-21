import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/auth/data/models/auth_model.dart';
import 'package:moazez/feature/auth/domain/usecases/register_usecase.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthModel>> login(String email, String password);
  Future<Either<Failure, AuthModel>> register(RegisterParams params);
  Future<Either<Failure, void>> logout();
}
