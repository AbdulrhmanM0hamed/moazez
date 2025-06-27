import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/feature/agreements/domain/usecases/close_task_usecase.dart';
import 'package:moazez/feature/agreements/presentation/cubit/close_task_state.dart';

class CloseTaskCubit extends Cubit<CloseTaskState> {
  final CloseTaskUseCase closeTaskUseCase;

  CloseTaskCubit(this.closeTaskUseCase) : super(CloseTaskInitial());

  Future<void> closeTask({required String taskId, required String status}) async {
    emit(CloseTaskLoading());
    final result = await closeTaskUseCase(CloseTaskParams(taskId: taskId, status: status));
    result.fold(
      (failure) => emit(CloseTaskFailure(failure.message)),
      (_) => emit(CloseTaskSuccess()),
    );
  }
}
