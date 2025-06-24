import 'package:moazez/feature/invitations/domain/entities/invitation_entity.dart';

class InvitationModel extends InvitationEntity {
  const InvitationModel({
    required int id,
    required int userId,
    required int teamId,
    required String status,
    required String createdAt,
    required String updatedAt,
    required UserEntity user,
    required TeamEntity team,
  }) : super(
          id: id,
          userId: userId,
          teamId: teamId,
          status: status,
          createdAt: createdAt,
          updatedAt: updatedAt,
          user: user,
          team: team,
        );

  factory InvitationModel.fromJson(Map<String, dynamic> json) {
    return InvitationModel(
      id: json['id'],
      userId: json['user_id'],
      teamId: json['team_id'],
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {'id': 0, 'name': ''}),
      team: TeamModel.fromJson(json['team'] ?? {'id': 0, 'name': ''}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'team_id': teamId,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': (user as UserModel).toJson(),
      'team': (team as TeamModel).toJson(),
    };
  }
}

class UserModel extends UserEntity {
  const UserModel({
    required int id,
    required String name,
    required String avatarUrl,
  }) : super(id: id, name: name, avatarUrl: avatarUrl);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar_url': avatarUrl,
    };
  }
}

class TeamModel extends TeamEntity {
  const TeamModel({
    required int id,
    required String name,
  }) : super(id: id, name: name);

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
