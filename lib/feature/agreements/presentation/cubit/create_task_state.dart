part of 'create_task_cubit.dart';

abstract class CreateTaskState extends Equatable {
  const CreateTaskState();

  @override
  List<Object> get props => [];
}

class CreateTaskInitial extends CreateTaskState {}

class CreateTaskLoading extends CreateTaskState {}

class CreateTaskSuccess extends CreateTaskState {}

class CreateTaskError extends CreateTaskState {
  final String message;

  const CreateTaskError(this.message);

  @override
  List<Object> get props => [message];
}
