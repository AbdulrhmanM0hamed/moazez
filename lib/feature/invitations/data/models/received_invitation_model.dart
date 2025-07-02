import 'package:moazez/feature/invitations/domain/entities/received_invitation_entity.dart';

class ReceivedInvitationModel extends ReceivedInvitationEntity {
  const ReceivedInvitationModel({
    required int id,
    required int userId,
    required int teamId,
    required String status,
    required String createdAt,
    required String updatedAt,
    required String type,
    required UserModel user,
    required TeamModel team,
    required String senderName,
  }) : super(
          id: id,
          userId: userId,
          teamId: teamId,
          status: status,
          createdAt: createdAt,
          updatedAt: updatedAt,
          type: type,
          user: user,
          team: team,
          senderName: senderName,
        );

  factory ReceivedInvitationModel.fromJson(Map<String, dynamic> json) {
    return ReceivedInvitationModel(
      id: json['id'],
      userId: json['user_id'],
      teamId: json['team_id'],
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      type: json['type'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
      team: TeamModel.fromJson(json['team'] ?? {}),
      senderName: json['sender_name'] ?? '',
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
      'type': type,
      'user': (user as UserModel).toJson(),
      'team': (team as TeamModel).toJson(),
      'sender_name': senderName,
    };
  }
}

class UserModel extends UserEntity {
  const UserModel({
    required int id,
    required String name,
    required String avatarUrl,
  }) : super(
          id: id,
          name: name,
          avatarUrl: avatarUrl,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
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
  }) : super(
          id: id,
          name: name,
        );

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id'] ?? 0,
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
