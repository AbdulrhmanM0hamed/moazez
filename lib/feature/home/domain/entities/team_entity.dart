
class TeamEntity {
  final bool isOwner;
  final int? id;
  final String? name;
  final int? ownerId;
  final Map<String, dynamic>? owner;
  final int? membersCount;
  final List<TeamMemberEntity>? members;
  final Map<String, dynamic>? tasksSummary;
  final String? createdAt;
  final String? updatedAt;

  const TeamEntity({
    required this.isOwner,
    this.id,
    this.name,
    this.ownerId,
    this.owner,
    this.membersCount,
    this.members,
    this.tasksSummary,
    this.createdAt,
    this.updatedAt,
  });
}

class TeamMemberEntity {
  final int id;
  final String? name;
  final String? email;
  final String? avatarUrl;

  TeamMemberEntity({
    required this.id,
    this.name,
    this.email,
    this.avatarUrl,
  });

  factory TeamMemberEntity.fromJson(Map<String, dynamic> json) {
    return TeamMemberEntity(
      id: json['id'] as int,
      name: json['name'] as String?,
      email: json['email'] as String?,
      avatarUrl: json['avatar_url'] as String?,
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
