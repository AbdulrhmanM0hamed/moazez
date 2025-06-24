import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/invitations/domain/entities/invitation_entity.dart';
import 'package:moazez/feature/invitations/domain/entities/received_invitation_entity.dart';

abstract class InvitationRepository {
  Future<Either<Failure, InvitationEntity>> sendInvitation(String email);
  Future<Either<Failure, List<InvitationEntity>>> getSentInvitations();
  Future<Either<Failure, List<ReceivedInvitationEntity>>> getReceivedInvitations();
  Future<Either<Failure, bool>> respondToInvitation(String invitationId, String action);
}
