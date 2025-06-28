import 'package:equatable/equatable.dart';
import 'package:moazez/feature/MyTasks/domain/entities/my_task_entity.dart';

abstract class MyTasksState extends Equatable {
  const MyTasksState();

  @override
  List<Object> get props => [];
}

class MyTasksInitial extends MyTasksState {}

class MyTasksLoading extends MyTasksState {}

class MyTasksLoaded extends MyTasksState {
  final List<MyTaskEntity> tasks;

  const MyTasksLoaded(this.tasks);

  @override
  List<Object> get props => [tasks];
}

class MyTasksError extends MyTasksState {
  final String message;

  const MyTasksError(this.message);

  @override
  List<Object> get props => [message];
}
