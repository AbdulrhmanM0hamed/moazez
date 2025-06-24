import 'package:equatable/equatable.dart';
import 'package:moazez/feature/invitations/domain/entities/invitation_entity.dart';
import 'package:moazez/feature/invitations/domain/entities/received_invitation_entity.dart';

abstract class InvitationState extends Equatable {
  const InvitationState();

  @override
  List<Object> get props => [];
}

class InvitationInitial extends InvitationState {}

class InvitationLoading extends InvitationState {}

class InvitationSent extends InvitationState {
  final InvitationEntity invitation;

  const InvitationSent({required this.invitation});

  @override
  List<Object> get props => [invitation];
}

class InvitationsLoaded extends InvitationState {
  final List<InvitationEntity> invitations;

  const InvitationsLoaded({required this.invitations});

  @override
  List<Object> get props => [invitations];
}

class InvitationError extends InvitationState {
  final String message;

  const InvitationError({required this.message});

  @override
  List<Object> get props => [message];
}

class SentInvitationsLoaded extends InvitationState {
  final List<InvitationEntity> invitations;

  SentInvitationsLoaded({required this.invitations});

  @override
  List<Object> get props => [invitations];
}

class ReceivedInvitationsLoaded extends InvitationState {
  final List<ReceivedInvitationEntity> invitations;

  ReceivedInvitationsLoaded({required this.invitations});
}

class InvitationResponded extends InvitationState {
  final String action;

  InvitationResponded({required this.action});

  @override
  List<Object> get props => [action];
}
