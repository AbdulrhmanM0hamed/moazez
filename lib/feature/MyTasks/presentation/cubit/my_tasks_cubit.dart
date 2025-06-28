import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/feature/MyTasks/domain/usecases/get_my_tasks_usecase.dart';
import 'package:moazez/feature/MyTasks/presentation/cubit/my_tasks_state.dart';

class MyTasksCubit extends Cubit<MyTasksState> {
  final GetMyTasksUseCase getMyTasksUseCase;

  MyTasksCubit({required this.getMyTasksUseCase}) : super(MyTasksInitial());

  Future<void> getMyTasks({String? status}) async {
    emit(MyTasksLoading());
    final result = await getMyTasksUseCase(GetMyTasksParams(status: status));
    result.fold(
      (failure) => emit(MyTasksError(failure.message)),
      (tasks) => emit(MyTasksLoaded(tasks)),
    );
  }
}
