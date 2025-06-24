import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/core/usecases/usecase.dart';
import 'package:moazez/feature/invitations/domain/entities/received_invitation_entity.dart';
import 'package:moazez/feature/invitations/domain/repositories/invitation_repository.dart';

class GetReceivedInvitationsUseCase implements UseCase<List<ReceivedInvitationEntity>, NoParams> {
  final InvitationRepository repository;

  GetReceivedInvitationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ReceivedInvitationEntity>>> call(NoParams params) async {
    return await repository.getReceivedInvitations();
  }
}
