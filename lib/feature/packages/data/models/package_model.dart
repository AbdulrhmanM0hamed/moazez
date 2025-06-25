import 'package:moazez/feature/packages/domain/entities/package_entity.dart';

class PackageModel extends PackageEntity {
  const PackageModel({
    required int id,
    required String name,
    String? description,
    required String price,
    required String priceFormatted,
    int? durationDays,
    required String durationText,
    required int maxTasks,
    required String maxTasksText,
    int? maxTeamMembers,
    required String maxTeamMembersText,
    required List<dynamic> features,
    required int isTrial,
    required bool isPopular,
    String? badge,
  }) : super(
          id: id,
          name: name,
          description: description,
          price: price,
          priceFormatted: priceFormatted,
          durationDays: durationDays,
          durationText: durationText,
          maxTasks: maxTasks,
          maxTasksText: maxTasksText,
          maxTeamMembers: maxTeamMembers,
          maxTeamMembersText: maxTeamMembersText,
          features: features,
          isTrial: isTrial,
          isPopular: isPopular,
          badge: badge,
        );

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      price: json['price'] ?? '0.0',
      priceFormatted: json['price_formatted'] ?? '0.0 ريال',
      durationDays: json['duration_days'],
      durationText: json['duration_text'] ?? ' يوم',
      maxTasks: json['max_tasks'] ?? 0,
      maxTasksText: json['max_tasks_text'] ?? '0 مهمة',
      maxTeamMembers: json['max_team_members'],
      maxTeamMembersText: json['max_team_members_text'] ?? 'غير محدود',
      features: json['features'] ?? [],
      isTrial: json['is_trial'] ?? 0,
      isPopular: json['is_popular'] ?? false,
      badge: json['badge'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'price_formatted': priceFormatted,
      'duration_days': durationDays,
      'duration_text': durationText,
      'max_tasks': maxTasks,
      'max_tasks_text': maxTasksText,
      'max_team_members': maxTeamMembers,
      'max_team_members_text': maxTeamMembersText,
      'features': features,
      'is_trial': isTrial,
      'is_popular': isPopular,
      'badge': badge,
    };
  }
}
