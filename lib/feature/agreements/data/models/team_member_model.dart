import 'package:moazez/feature/agreements/domain/entities/team_member.dart';

class TeamMemberModel extends TeamMember {
  const TeamMemberModel({
    required super.id,
    required super.name,
    required super.email,
    super.avatarUrl,
  });

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    return TeamMemberModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatarUrl: json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar_url': avatarUrl,
    };
  }
}
