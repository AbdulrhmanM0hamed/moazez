import 'package:equatable/equatable.dart';

class RewardEntity extends Equatable {
  final int id;
  final String amount;
  final String notes;
  final String status;
  final UserEntity user;
  final TaskEntity task;
  final UserEntity distributedBy;
  final String createdAt;
  final String? updatedAt;
  final String? rewardType; // New field
  final String? expirationDate; // New field
  final String priority; // New field

  const RewardEntity({
    required this.id,
    required this.amount,
    required this.notes,
    required this.status,
    required this.user,
    required this.task,
    required this.distributedBy,
    required this.createdAt,
    this.updatedAt,
    this.rewardType,
    this.expirationDate,
    this.priority = "Low",
  });

  @override
  List<Object?> get props => [
        id,
        amount,
        notes,
        status,
        user,
        task,
        distributedBy,
        createdAt,
        updatedAt,
        rewardType,
        expirationDate,
        priority,
      ];
}

class UserEntity extends Equatable {
  final int id;
  final String name;
  final String? avatarUrl;

  const UserEntity({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, name, avatarUrl];
}

class TaskEntity extends Equatable {
  final int id;
  final String title;

  const TaskEntity({
    required this.id,
    required this.title,
  });

  @override
  List<Object> get props => [id, title];
}
