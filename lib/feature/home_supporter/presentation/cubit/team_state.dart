import 'package:moazez/feature/agreements/data/models/team_member_model.dart';
import 'package:moazez/feature/home_supporter/domain/entities/team_entity.dart';

abstract class TeamState {}

class TeamInitial extends TeamState {}

class TeamLoading extends TeamState {}

class TeamLoaded extends TeamState {
  final TeamEntity team;
  final List<TeamMemberModel>? members;

  TeamLoaded({
    required this.team,
    this.members,
  });
}

class TeamError extends TeamState {
  final String message;

  TeamError({required this.message});
}

class TeamMembersLoading extends TeamState {}

class TeamMembersLoaded extends TeamState {
  final List<TeamMemberModel> members;

  TeamMembersLoaded({required this.members});
}

class TeamMembersError extends TeamState {
  final String message;

  TeamMembersError({required this.message});
}
