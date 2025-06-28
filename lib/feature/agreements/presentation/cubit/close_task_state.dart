import 'package:equatable/equatable.dart';

abstract class CloseTaskState extends Equatable {
  const CloseTaskState();

  @override
  List<Object> get props => [];
}

class CloseTaskInitial extends CloseTaskState {}

class CloseTaskLoading extends CloseTaskState {}

class CloseTaskSuccess extends CloseTaskState {
  final String message;

  const CloseTaskSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class CloseTaskFailure extends CloseTaskState {
  final String message;

  const CloseTaskFailure(this.message);

  @override
  List<Object> get props => [message];
}
