import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/core/usecases/usecase.dart';
import 'package:moazez/feature/invitations/domain/entities/invitation_entity.dart';
import 'package:moazez/feature/invitations/domain/repositories/invitation_repository.dart';

class SendInvitationUseCase implements UseCase<InvitationEntity, String> {
  final InvitationRepository repository;

  SendInvitationUseCase(this.repository);

  @override
  Future<Either<Failure, InvitationEntity>> call(String email) async {
    return await repository.sendInvitation(email);
  }
}
