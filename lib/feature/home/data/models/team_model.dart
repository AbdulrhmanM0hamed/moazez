import 'package:moazez/feature/home/domain/entities/team_entity.dart';

class TeamModel extends TeamEntity {
  const TeamModel({
    required bool isOwner,
    required int? id,
    required String? name,
    required int? ownerId,
    required Map<String, dynamic>? owner,
    required int? membersCount,
    required List<TeamMemberEntity>? members,
    required Map<String, dynamic>? tasksSummary,
    required String? createdAt,
    required String? updatedAt,
  }) : super(
         isOwner: isOwner,
         id: id,
         name: name,
         ownerId: ownerId,
         owner: owner,
         membersCount: membersCount,
         members: members,
         tasksSummary: tasksSummary,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    final membersList = json['members'] as List<dynamic>?;
    final members =
        membersList
            ?.map(
              (member) =>
                  TeamMemberEntity.fromJson(member as Map<String, dynamic>),
            )
            .toList();

    return TeamModel(
      isOwner: json['is_owner'] ?? false,
      id: json['id'],
      name: json['name'],
      ownerId: json['owner_id'],
      owner: json['owner'],
      membersCount: json['members_count'],
      members: members,
      tasksSummary: json['tasks_summary'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_owner': isOwner,
      'id': id,
      'name': name,
      'owner_id': ownerId,
      'owner': owner,
      'members_count': membersCount,
      'members': members?.map((member) => member.toJson()).toList(),
      'tasks_summary': tasksSummary,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
