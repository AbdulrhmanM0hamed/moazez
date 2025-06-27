import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moazez/feature/agreements/domain/entities/task.dart';
import 'package:moazez/feature/agreements/domain/usecases/create_task_usecase.dart';

part 'create_task_state.dart';

class CreateTaskCubit extends Cubit<CreateTaskState> {
  final CreateTaskUsecase createTaskUsecase;

  CreateTaskCubit({required this.createTaskUsecase}) : super(CreateTaskInitial());

  Future<void> createTask(Task task) async {
    emit(CreateTaskLoading());
    final result = await createTaskUsecase(task);
    result.fold(
      (failure) => emit(CreateTaskError(failure.message)),
      (_) => emit(CreateTaskSuccess()),
    );
  }
}
