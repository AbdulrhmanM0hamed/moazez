import 'package:equatable/equatable.dart';

class ReceivedInvitationEntity extends Equatable {
  final int id;
  final int userId;
  final int teamId;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String type;
  final UserEntity user;
  final TeamEntity team;

  const ReceivedInvitationEntity({
    required this.id,
    required this.userId,
    required this.teamId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
    required this.user,
    required this.team,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        teamId,
        status,
        createdAt,
        updatedAt,
        type,
        user,
        team,
      ];
}

class UserEntity extends Equatable {
  final int id;
  final String name;
  final String avatarUrl;

  const UserEntity({
    required this.id,
    required this.name,
    required this.avatarUrl,
  });

  @override
  List<Object> get props => [id, name, avatarUrl];
}

class TeamEntity extends Equatable {
  final int id;
  final String name;

  const TeamEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [id, name];
}
