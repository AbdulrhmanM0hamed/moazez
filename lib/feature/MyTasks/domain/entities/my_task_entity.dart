import 'package:equatable/equatable.dart';

class MyTaskEntity extends Equatable {
  final int id;
  final String title;
  final String status;
  final int progress;
  final String? dueDate;
  final String createdAt;
  final int stagesCount;
  final int completedStages;
  final MyTaskCreatorEntity creator;

  const MyTaskEntity({
    required this.id,
    required this.title,
    required this.status,
    required this.progress,
    this.dueDate,
    required this.createdAt,
    required this.stagesCount,
    required this.completedStages,
    required this.creator,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        status,
        progress,
        dueDate,
        createdAt,
        stagesCount,
        completedStages,
        creator,
      ];
}

class MyTaskCreatorEntity extends Equatable {
  final int id;
  final String name;
  final String? avatarUrl;

  const MyTaskCreatorEntity({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, name, avatarUrl];
}
