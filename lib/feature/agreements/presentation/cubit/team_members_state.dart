import 'package:equatable/equatable.dart';
import 'package:moazez/feature/agreements/domain/entities/team_member.dart';

abstract class TeamMembersState extends Equatable {
  const TeamMembersState();

  @override
  List<Object> get props => [];
}

class TeamMembersInitial extends TeamMembersState {}

class TeamMembersLoading extends TeamMembersState {}

class TeamMembersLoaded extends TeamMembersState {
  final List<TeamMember> members;

  const TeamMembersLoaded(this.members);

  @override
  List<Object> get props => [members];
}

class TeamMembersError extends TeamMembersState {
  final String message;

  const TeamMembersError(this.message);

  @override
  List<Object> get props => [message];
}
