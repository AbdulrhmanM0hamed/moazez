import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/core/usecases/usecase.dart';
import 'package:moazez/feature/invitations/domain/entities/invitation_entity.dart';
import 'package:moazez/feature/invitations/domain/repositories/invitation_repository.dart';

class GetSentInvitationsUseCase implements UseCase<List<InvitationEntity>, NoParams> {
  final InvitationRepository repository;

  GetSentInvitationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<InvitationEntity>>> call(NoParams params) async {
    return await repository.getSentInvitations();
  }
}
