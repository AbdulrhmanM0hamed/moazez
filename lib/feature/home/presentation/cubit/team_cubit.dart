import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/core/usecases/usecase.dart';
import 'package:moazez/feature/home/domain/entities/team_entity.dart';
import 'package:moazez/feature/home/domain/usecases/get_team_info_usecase.dart';
import 'package:moazez/feature/home/presentation/cubit/team_state.dart';

class TeamCubit extends Cubit<TeamState> {
  final GetTeamInfoUseCase getTeamInfoUseCase;
  final CreateTeamUseCase createTeamUseCase;

  TeamCubit({
    required this.getTeamInfoUseCase,
    required this.createTeamUseCase,
  }) : super(TeamInitial());

  Future<void> fetchTeamInfo() async {
    emit(TeamLoading());
    final result = await getTeamInfoUseCase(NoParams());
    result.fold(
      (failure) => emit(TeamError(message: failure.message)),
      (team) => emit(TeamLoaded(team: team)),
    );
  }

  Future<void> createTeam(String teamName) async {
    emit(TeamLoading());
    final result = await createTeamUseCase(teamName);
    result.fold(
      (failure) => emit(TeamError(message: failure.message)),
      (team) => emit(TeamLoaded(team: team)),
    );
  }
}
