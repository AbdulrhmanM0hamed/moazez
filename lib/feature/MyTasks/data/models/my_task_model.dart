import 'package:moazez/feature/MyTasks/domain/entities/my_task_entity.dart';

class MyTaskModel extends MyTaskEntity {
  const MyTaskModel({
    required super.id,
    required super.title,
    required super.status,
    required super.progress,
    super.dueDate,
    required super.createdAt,
    required super.stagesCount,
    required super.completedStages,
    required super.creator,
  });

  factory MyTaskModel.fromJson(Map<String, dynamic> json) {
    final stages = json['stages'] as List<dynamic>? ?? [];
    final completedStagesCount = stages.where((stage) => stage['status'] == 'completed').length;

    return MyTaskModel(
      id: json['id'],
      title: json['title'],
      status: json['status'],
      progress: json['progress'] ?? 0,
      dueDate: json['due_date'],
      createdAt: json['created_at'],
      stagesCount: stages.length,
      completedStages: completedStagesCount,
      creator: MyTaskCreatorModel.fromJson(json['creator']),
    );
  }
}

class MyTaskCreatorModel extends MyTaskCreatorEntity {
  const MyTaskCreatorModel({
    required super.id,
    required super.name,
    super.avatarUrl,
  });

  factory MyTaskCreatorModel.fromJson(Map<String, dynamic> json) {
    return MyTaskCreatorModel(
      id: json['id'],
      name: json['name'],
      avatarUrl: json['avatar_url'],
    );
  }
}
