import 'package:equatable/equatable.dart';

class TaskDetailsEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final String status;
  final int progress;
  final String priority;
  final String? startDate;
  final String? dueDate;
  final String? completedAt;
  final String createdAt;
  final TaskUserEntity creator;
  final TaskUserEntity receiver;
  final TeamEntity team;
  final List<StageEntity> stages;
  final String? rewardAmount;
  final String? rewardDescription;
  final String? rewardType;
  final bool rewardDistributed;

  const TaskDetailsEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.progress,
    required this.priority,
    this.startDate,
    this.dueDate,
    this.completedAt,
    required this.createdAt,
    required this.creator,
    required this.receiver,
    required this.team,
    required this.stages,
    this.rewardAmount,
    this.rewardDescription,
    this.rewardType,
    required this.rewardDistributed,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        status,
        progress,
        priority,
        startDate,
        dueDate,
        completedAt,
        createdAt,
        creator,
        receiver,
        team,
        stages,
        rewardAmount,
        rewardDescription,
        rewardType,
        rewardDistributed,
      ];
}

class TaskUserEntity {
  final int id;
  final String name;

  TaskUserEntity({required this.id, required this.name});
}

class TeamEntity {
  final int id;
  final String name;

  TeamEntity({required this.id, required this.name});
}

class StageEntity {
  final int id;
  final int taskId;
  final String title;
  final String description;
  final String status;
  final int stageNumber;
  final String? completedAt;
  final String? proofNotes;
  final dynamic proofFiles;

  StageEntity({
    required this.id,
    required this.taskId,
    required this.title,
    required this.description,
    required this.status,
    required this.stageNumber,
    this.completedAt,
    this.proofNotes,
    this.proofFiles,
  });
}
