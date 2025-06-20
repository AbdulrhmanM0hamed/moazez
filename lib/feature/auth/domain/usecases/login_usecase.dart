import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/auth/domain/entities/auth_entity.dart';
import 'package:moazez/feature/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, AuthEntity>> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
