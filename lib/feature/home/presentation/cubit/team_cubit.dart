import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/usecases/usecase.dart';
import 'package:moazez/feature/home/domain/repositories/team_repository.dart';
import 'package:moazez/feature/home/domain/usecases/get_team_info_usecase.dart';
import 'package:moazez/feature/home/presentation/cubit/team_state.dart';

class TeamCubit extends Cubit<TeamState> {
  final GetTeamInfoUseCase getTeamInfoUseCase;
  final TeamRepository teamRepository;
  
  TeamCubit({
    required this.getTeamInfoUseCase,
    required this.teamRepository,
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
    final result = await teamRepository.createTeam(teamName);
    result.fold(
      (failure) => emit(TeamError(message: failure.message)),
      (team) => emit(TeamLoaded(team: team)),
    );
  }

  Future<void> updateTeamName(String newName) async {
    emit(TeamLoading());
    final result = await teamRepository.updateTeamName(newName);
    result.fold(
      (failure) => emit(TeamError(message: failure.message)),
      (team) => emit(TeamLoaded(team: team)),
    );
  }

  Future<void> removeTeamMember(int memberId) async {
    emit(TeamLoading());
    final result = await teamRepository.removeTeamMember(memberId);
    result.fold(
      (failure) => emit(TeamError(message: failure.message)),
      (team) async {
        // Emit a TeamLoaded state immediately to trigger Snackbar
        emit(TeamLoaded(team: team));
        // Then fetch updated team info
        await fetchTeamInfo();
      },
    );
  }
}
