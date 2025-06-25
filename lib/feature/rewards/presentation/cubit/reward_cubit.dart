import 'package:bloc/bloc.dart';
import 'package:moazez/core/usecases/usecase.dart';
import 'package:moazez/feature/rewards/domain/usecases/get_team_rewards_usecase.dart';
import 'package:moazez/feature/rewards/domain/usecases/get_my_rewards_usecase.dart';
import 'package:moazez/feature/rewards/presentation/cubit/reward_state.dart';

class RewardCubit extends Cubit<RewardState> {
  final GetTeamRewardsUseCase getTeamRewardsUseCase;
  final GetMyRewardsUseCase getMyRewardsUseCase;

  RewardCubit({
    required this.getTeamRewardsUseCase,
    required this.getMyRewardsUseCase,
  }) : super(RewardInitial());

  Future<void> getTeamRewards() async {
    emit(RewardLoading());
    final result = await getTeamRewardsUseCase(NoParams());
    result.fold(
      (failure) => emit(RewardError(message: failure.message)),
      (rewards) => emit(RewardLoaded(rewards: rewards)),
    );
  }

  Future<void> getMyRewards() async {
    emit(RewardLoading());
    final result = await getMyRewardsUseCase(NoParams());
    result.fold(
      (failure) => emit(RewardError(message: failure.message)),
      (rewards) => emit(RewardLoaded(rewards: rewards)),
    );
  }
}
