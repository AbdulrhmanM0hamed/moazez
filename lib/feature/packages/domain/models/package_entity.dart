class PackageEntity {
  final int id;
  final String name;
  final String? description;
  final String price;
  final String priceFormatted;
  final int? durationDays;
  final String durationText;
  final int maxTasks;
  final String maxTasksText;
  final int? maxTeamMembers;
  final String maxTeamMembersText;
  final List<String> features;
  final bool isTrial;
  final bool isPopular;
  final String? badge;

  PackageEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.priceFormatted,
    required this.durationDays,
    required this.durationText,
    required this.maxTasks,
    required this.maxTasksText,
    required this.maxTeamMembers,
    required this.maxTeamMembersText,
    required this.features,
    required this.isTrial,
    required this.isPopular,
    required this.badge,
  });

  factory PackageEntity.fromJson(Map<String, dynamic> json) {
    return PackageEntity(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      priceFormatted: json['price_formatted'],
      durationDays: json['duration_days'],
      durationText: json['duration_text'],
      maxTasks: json['max_tasks'],
      maxTasksText: json['max_tasks_text'],
      maxTeamMembers: json['max_team_members'],
      maxTeamMembersText: json['max_team_members_text'],
      features: List<String>.from(json['features'] ?? []),
      isTrial: json['is_trial'] == 1,
      isPopular: json['is_popular'] ?? false,
      badge: json['badge'],
    );
  }
}
