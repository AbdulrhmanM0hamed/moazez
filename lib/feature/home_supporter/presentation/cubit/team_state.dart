import 'package:moazez/feature/home_supporter/domain/entities/team_entity.dart';

abstract class TeamState {}

class TeamInitial extends TeamState {}

class TeamLoading extends TeamState {}

class TeamLoaded extends TeamState {
  final TeamEntity team;

  TeamLoaded({required this.team});
}

class TeamError extends TeamState {
  final String message;

  TeamError({required this.message});
}
