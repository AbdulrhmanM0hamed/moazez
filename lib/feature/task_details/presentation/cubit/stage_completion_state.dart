import 'package:equatable/equatable.dart';
import 'package:moazez/feature/task_details/domain/entities/stage_completion_entity.dart';

abstract class StageCompletionState extends Equatable {
  const StageCompletionState();

  @override
  List<Object?> get props => [];
}

class StageCompletionInitial extends StageCompletionState {
  const StageCompletionInitial();

  @override
  List<Object?> get props => [];
}

class StageCompletionLoading extends StageCompletionState {
  const StageCompletionLoading();

  @override
  List<Object?> get props => [];
}

class StageCompletionSuccess extends StageCompletionState {
  final StageCompletionEntity stage;

  const StageCompletionSuccess({required this.stage});

  @override
  List<Object?> get props => [stage];
}

class StageCompletionError extends StageCompletionState {
  final String message;

  const StageCompletionError({required this.message});

  @override
  List<Object?> get props => [message];
}

class StageCompletionUpdated extends StageCompletionState {
  final String? image;
  final String? notes;

  const StageCompletionUpdated({this.image, this.notes});

  @override
  List<Object?> get props => [image, notes];
}
