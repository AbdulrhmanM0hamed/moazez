import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/feature/auth/data/models/auth_model.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/feature/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, AuthModel>> call(LoginParams params) async {
    final result = await repository.login(params.email, params.password);
    result.fold(
      (failure) {},
      (authModel) {
        sl<CacheService>().saveToken(authModel.token);
      },
    );
    return result;
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
