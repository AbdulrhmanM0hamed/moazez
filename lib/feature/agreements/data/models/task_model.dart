import '../../domain/entities/task.dart';

class TaskModel extends Task {
  const TaskModel({
    super.id,
    required super.title,
    required super.description,
    required super.startDate,
    required super.durationDays,
    required super.endDate,
    required super.status,
    required super.priority,
    required super.rewardType,
    super.rewardAmount,
    super.rewardDescription,
    required super.isMultiple,
    required super.selectedMembers,
    required super.receiverId,
    required super.totalStages,
  });

  factory TaskModel.fromEntity(Task entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      startDate: entity.startDate,
      durationDays: entity.durationDays,
      endDate: entity.endDate,
      status: entity.status,
      priority: entity.priority,
      rewardType: entity.rewardType,
      rewardAmount: entity.rewardAmount,
      rewardDescription: entity.rewardDescription,
      isMultiple: entity.isMultiple,
      selectedMembers: entity.selectedMembers,
      receiverId: entity.receiverId,
      totalStages: entity.totalStages,
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startDate: json['start_date'],
      durationDays: json['duration_days'],
      endDate: json['end_date'],
      status: json['status'],
      priority: json['priority'],
      rewardType: json['reward_type'],
      rewardAmount: (json['reward_amount'] as num?)?.toDouble(),
      rewardDescription: json['reward_description'],
      isMultiple: json['is_multiple'],
      selectedMembers: List<int>.from(json['selected_members']),
      receiverId: json['receiver_id'],
      totalStages: json['total_stages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'start_date': startDate,
      'duration_days': durationDays,
      'end_date': endDate,
      'status': status,
      'priority': priority,
      'reward_type': rewardType,
      'reward_amount': rewardAmount,
      'reward_description': rewardDescription,
      'is_multiple': isMultiple,
      'selected_members': selectedMembers,
      'receiver_id': receiverId,
      'total_stages': totalStages,
    };
  }
}
