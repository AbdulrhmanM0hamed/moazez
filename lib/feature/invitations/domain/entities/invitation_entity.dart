class InvitationEntity {
  final int id;
  final int userId;
  final int teamId;
  final String status;
  final String createdAt;
  final String updatedAt;
  final UserEntity user;
  final TeamEntity team;

  const InvitationEntity({
    required this.id,
    required this.userId,
    required this.teamId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.team,
  });
}

class UserEntity {
  final int id;
  final String name;
  final String avatarUrl;

  const UserEntity({
    required this.id,
    required this.name,
    required this.avatarUrl,
  });
}

class TeamEntity {
  final int id;
  final String name;

  const TeamEntity({
    required this.id,
    required this.name,
  });
}
