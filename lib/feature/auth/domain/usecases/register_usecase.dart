import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/feature/auth/domain/entities/auth_entity.dart';
import 'package:moazez/feature/auth/domain/repositories/auth_repository.dart';
import 'package:moazez/core/services/service_locator.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, AuthEntity>> call(RegisterParams params) async {
    final result = await repository.register(params);
    await result.fold((failure) async {}, (authEntity) async {
      sl<CacheService>().saveToken(authEntity.token);
     // await repository.subscribeToTrialPackage(authEntity.token);
    });
    return result;
  }
}

class RegisterParams extends Equatable {
  final String name;
  final String email;
  final String phone;
  final String password;

  const RegisterParams({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, phone, password];
}
