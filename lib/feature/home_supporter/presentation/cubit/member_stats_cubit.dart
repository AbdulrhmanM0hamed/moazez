import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/feature/home_supporter/data/models/member_stats_model.dart';
import 'package:moazez/feature/home_supporter/domain/usecases/get_member_task_stats_usecase.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/member_stats_state.dart';

class MemberStatsCubit extends Cubit<MemberStatsState> {
  final GetMemberTaskStatsUseCase getMemberTaskStatsUseCase;

  MemberStatsCubit({
    required this.getMemberTaskStatsUseCase,
  }) : super(MemberStatsInitial());

  Future<void> fetchMemberTaskStats({int page = 1}) async {
    emit(MemberStatsLoading());
    final result = await getMemberTaskStatsUseCase(page);
    result.fold(
      (failure) => emit(MemberStatsError(message: failure.toString())),
      (response) => emit(MemberStatsLoaded(response: MemberTaskStatsResponseModel.fromEntity(response))),
    );
  }
}
