class TeamEntity {
  final bool isOwner;
  final int? id;
  final String? name;
  final int? ownerId;
  final Map<String, dynamic>? owner;
  final int? membersCount;
  final List<dynamic>? members;
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
    this.createdAt,
    this.updatedAt,
  });
}
