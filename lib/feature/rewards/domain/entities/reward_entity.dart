import 'package:equatable/equatable.dart';

class RewardEntity extends Equatable {
  final int id;
  final String amount;
  final String notes;
  final String status;
  final TaskEntity task;
  final DistributorEntity distributedBy;
  final UserEntity? user;
  final String createdAt;
  final String? updatedAt;
  final String rewardType;
  final String rewardDescription;

  const RewardEntity({
    required this.id,
    required this.amount,
    required this.notes,
    required this.status,
    required this.task,
    required this.distributedBy,
    required this.createdAt,
    this.updatedAt,
    this.user,
    required this.rewardType,
    required this.rewardDescription,
  });

  @override
  List<Object?> get props => [
        id,
        amount,
        notes,
        status,
        task,
        distributedBy,
        createdAt,
        updatedAt,
        rewardType,
        rewardDescription,
      ];
}

class TaskEntity extends Equatable {
  final int id;
  final String title;

  const TaskEntity({
    required this.id,
    required this.title,
  });

  @override
  List<Object?> get props => [id, title];
}

class UserEntity extends Equatable {
  final int id;
  final String name;
  final String avatarUrl;

  const UserEntity({
    required this.id,
    required this.name,
    required this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, name, avatarUrl];
}

class DistributorEntity extends Equatable {
  final int id;
  final String name;
  final String? avatarUrl;

  const DistributorEntity({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, name, avatarUrl];
}
