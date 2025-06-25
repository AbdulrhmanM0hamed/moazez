import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/auth/domain/repositories/auth_repository.dart';

class SendPasswordResetLinkUseCase {
  final AuthRepository repository;

  SendPasswordResetLinkUseCase(this.repository);

  Future<Either<Failure, String>> call(String email) async {
    return await repository.sendPasswordResetLink(email);
  }
}
