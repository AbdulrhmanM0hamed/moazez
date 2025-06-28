import 'package:moazez/feature/agreements/domain/entities/task_details_entity.dart';

class TaskDetailsModel extends TaskDetailsEntity {
  TaskDetailsModel({
    required super.id,
    required super.title,
    required super.description,
    required super.status,
    required super.progress,
    required super.priority,
    super.startDate,
    super.dueDate,
    super.completedAt,
    required super.createdAt,
    required super.creator,
    required super.receiver,
    required super.team,
    required super.stages,
    super.rewardAmount,
    super.rewardDescription,
    super.rewardType,
    required super.rewardDistributed,
  });

  factory TaskDetailsModel.fromJson(Map<String, dynamic> json) {
    return TaskDetailsModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      progress: json['progress'],
      priority: json['priority'],
      startDate: json['start_date'],
      dueDate: json['due_date'],
      completedAt: json['completed_at'],
      createdAt: json['created_at'],
      creator: TaskUserModel.fromJson(json['creator']),
      receiver: TaskUserModel.fromJson(json['receiver']),
      team: json['team'] != null
          ? TeamModel.fromJson(json['team'])
          : TeamModel(id: 0, name: 'غير محدد'),
      stages: (json['stages'] as List)
          .map((stage) => StageModel.fromJson(stage))
          .toList(),
      rewardAmount: json['reward_amount'],
      rewardDescription: json['reward_description'],
      rewardType: json['reward_type'],
      rewardDistributed: json['reward_distributed'],
    );
  }
}

class TaskUserModel extends TaskUserEntity {
  TaskUserModel({required super.id, required super.name});

  factory TaskUserModel.fromJson(Map<String, dynamic> json) {
    return TaskUserModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

class TeamModel extends TeamEntity {
  TeamModel({required super.id, required super.name});

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

class StageModel extends StageEntity {
  StageModel({
    required super.id,
    required super.taskId,
    required super.title,
    required super.description,
    required super.status,
    required super.stageNumber,
    super.completedAt,
    super.proofNotes,
    super.proofFiles,
  });

  factory StageModel.fromJson(Map<String, dynamic> json) {
    return StageModel(
      id: json['id'],
      taskId: json['task_id'],
      title: json['title'],
      description: json['description'] ?? '',
      status: json['status'],
      stageNumber: json['stage_number'],
      completedAt: json['completed_at'],
      proofNotes: json['proof_notes'],
      proofFiles: json['proof_files'],
    );
  }
}
