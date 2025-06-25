import 'package:moazez/feature/rewards/domain/entities/reward_entity.dart';

class RewardModel extends RewardEntity {
  const RewardModel({
    required int id,
    required String amount,
    required String notes,
    required String status,
    required UserModel user,
    required TaskModel task,
    required UserModel distributedBy,
    required String createdAt,
    String? updatedAt,
    String? rewardType,
    String? expirationDate,
    String priority = "Low",
  }) : super(
          id: id,
          amount: amount,
          notes: notes,
          status: status,
          user: user,
          task: task,
          distributedBy: distributedBy,
          createdAt: createdAt,
          updatedAt: updatedAt,
          rewardType: rewardType,
          expirationDate: expirationDate,
          priority: priority,
        );

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      id: json['id'] ?? 0,
      amount: (json['amount'] != null) ? json['amount'].toString() : '0.0',
      notes: json['notes'] ?? '',
      status: json['status'] ?? '',
      user: json['user'] != null ? UserModel.fromJson(json['user']) : UserModel(id: 0, name: '', avatarUrl: ''),
      task: json['task'] != null ? TaskModel.fromJson(json['task']) : TaskModel(id: 0, title: ''),
      distributedBy: json['distributed_by'] != null ? UserModel.fromJson(json['distributed_by']) : UserModel(id: 0, name: '', avatarUrl: ''),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'],
      rewardType: json['reward_type'],
      expirationDate: json['expiration_date'],
      priority: json['priority'] ?? 'Low',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'notes': notes,
      'status': status,
      'user': (user as UserModel).toJson(),
      'task': (task as TaskModel).toJson(),
      'distributed_by': (distributedBy as UserModel).toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
      'reward_type': rewardType,
      'expiration_date': expirationDate,
      'priority': priority,
    };
  }
}

class UserModel extends UserEntity {
  const UserModel({
    required int id,
    required String name,
    String? avatarUrl,
  }) : super(id: id, name: name, avatarUrl: avatarUrl);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
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

class TaskModel extends TaskEntity {
  const TaskModel({
    required int id,
    required String title,
  }) : super(id: id, title: title);

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}
