import 'package:moazez/feature/rewards/domain/entities/reward_entity.dart';

class RewardModel extends RewardEntity {
  const RewardModel({
    required int id,
    required String amount,
    required String notes,
    required String status,
    required TaskEntity task,
    required DistributorEntity distributedBy,
    required String createdAt,
    String? updatedAt,
    UserEntity? user,
    required String rewardType,
    required String rewardDescription,
  }) : super(
          id: id,
          amount: amount,
          notes: notes,
          status: status,
          task: task,
          distributedBy: distributedBy,
          createdAt: createdAt,
          updatedAt: updatedAt,
          user: user,
          rewardType: rewardType,
          rewardDescription: rewardDescription,
        );

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      user: json['user'] != null
          ? UserEntity(
              id: json['user']['id'] ?? 0,
              name: json['user']['name'] ?? '',
              avatarUrl: json['user']['avatar_url'] ?? '',
            )
          : null,
      id: json['id'] ?? 0,
      amount: json['amount'] ?? '0.00',
      notes: json['notes'] ?? '',
      status: json['status'] ?? 'pending',
      task: TaskModel.fromJson(json['task'] ?? {}),
      distributedBy: DistributorModel.fromJson(json['distributed_by'] ?? {}),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'],
      rewardType: json['reward_type'] ?? 'cash',
      rewardDescription: json['reward_description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'notes': notes,
      'status': status,
      'task': (task as TaskModel).toJson(),
      'distributed_by': (distributedBy as DistributorModel).toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class TaskModel extends TaskEntity {
  const TaskModel({
    required int id,
    required String title,
  }) : super(id: id, title: title);

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}

class DistributorModel extends DistributorEntity {
  const DistributorModel({
    required int id,
    required String name,
    String? avatarUrl,
  }) : super(id: id, name: name, avatarUrl: avatarUrl);

  factory DistributorModel.fromJson(Map<String, dynamic> json) {
    return DistributorModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      avatarUrl: json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar_url': avatarUrl,
    };
  }
}
