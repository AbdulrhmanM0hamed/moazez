import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/invitations/domain/entities/invitation_entity.dart';

abstract class InvitationRepository {
  Future<Either<Failure, InvitationEntity>> sendInvitation(String email);
  Future<Either<Failure, List<InvitationEntity>>> getSentInvitations();
}
