import 'package:moazez/feature/packages/domain/entities/package_entity.dart';

class PackageModel extends PackageEntity {
  const PackageModel({
    required int id,
    required String name,
    required String priceFormatted,
    required int maxTasks,
    int? maxTeamMembers,
    int? maxStagesPerTask,
    required bool isTrial,
  }) : super(
          id: id,
          name: name,
          priceFormatted: priceFormatted,
          maxTasks: maxTasks,
          maxTeamMembers: maxTeamMembers,
          maxStagesPerTask: maxStagesPerTask,
          isTrial: isTrial,
        );

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      priceFormatted: json['price_formatted'] ?? '0.0 ريال',
      maxTasks: json['max_tasks'] ?? 0,
      maxTeamMembers: json['max_team_members'],
      maxStagesPerTask: json['max_stages_per_task'],
      isTrial: json['is_trial'] == true || json['is_trial'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price_formatted': priceFormatted,
      'max_tasks': maxTasks,
      'max_team_members': maxTeamMembers,
      'max_stages_per_task': maxStagesPerTask,
      'is_trial': isTrial,
    };
  }
}
