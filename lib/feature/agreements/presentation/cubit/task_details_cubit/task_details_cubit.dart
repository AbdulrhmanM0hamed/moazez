import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/feature/agreements/domain/usecases/get_task_details_usecase.dart';
import 'package:moazez/feature/agreements/presentation/cubit/task_details_cubit/task_details_state.dart';

class TaskDetailsCubit extends Cubit<TaskDetailsState> {
  final GetTaskDetailsUseCase getTaskDetailsUseCase;

  TaskDetailsCubit(this.getTaskDetailsUseCase) : super(TaskDetailsInitial());

  Future<void> fetchTaskDetails(int taskId) async {
    emit(TaskDetailsLoading());
    final failureOrTaskDetails = await getTaskDetailsUseCase(taskId: taskId);
    failureOrTaskDetails.fold(
      (failure) => emit(TaskDetailsError(failure.message)),
      (taskDetails) => emit(TaskDetailsLoaded(taskDetails)),
    );
  }
}
