import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/feature/task_details/domain/usecase/task_details_usecase.dart';
import 'package:moazez/feature/task_details/presentation/cubit/task_details_state.dart';

class TaskDetailsCubit extends Cubit<TaskDetailsState> {
  final TaskDetailsUseCase getTaskDetailsUseCase;

  TaskDetailsCubit(this.getTaskDetailsUseCase) : super(TaskDetailsInitial());

  Future<void> fetchTaskDetails(int taskId) async {
    emit(TaskDetailsLoading());
    final failureOrTaskDetails = await getTaskDetailsUseCase(taskId);
    failureOrTaskDetails.fold(
      (failure) => emit(TaskDetailsError(failure.message)),
      (taskDetails) => emit(TaskDetailsLoaded(taskDetails)),
    );
  }
}
