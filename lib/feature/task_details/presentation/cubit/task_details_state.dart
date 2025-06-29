import 'package:equatable/equatable.dart';
import 'package:moazez/feature/task_details/domain/entities/task_details_entity.dart';

abstract class TaskDetailsState extends Equatable {
  const TaskDetailsState();

  @override
  List<Object> get props => [];
}

class TaskDetailsInitial extends TaskDetailsState {}

class TaskDetailsLoading extends TaskDetailsState {}

class TaskDetailsLoaded extends TaskDetailsState {
  final TaskDetailsEntity taskDetails;

  const TaskDetailsLoaded(this.taskDetails);

  @override
  List<Object> get props => [taskDetails];
}

class TaskDetailsError extends TaskDetailsState {
  final String message;

  const TaskDetailsError(this.message);

  @override
  List<Object> get props => [message];
}
