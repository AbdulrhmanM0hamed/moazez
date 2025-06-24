import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/core/usecases/usecase.dart';
import 'package:moazez/feature/invitations/domain/repositories/invitation_repository.dart';

class RespondToInvitationUseCase implements UseCase<bool, RespondToInvitationParams> {
  final InvitationRepository repository;

  RespondToInvitationUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(RespondToInvitationParams params) async {
    return await repository.respondToInvitation(params.invitationId, params.action);
  }
}

class RespondToInvitationParams {
  final String invitationId;
  final String action;

  RespondToInvitationParams({required this.invitationId, required this.action});
}
