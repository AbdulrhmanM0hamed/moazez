import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/usecases/usecase.dart';
import 'package:moazez/feature/agreements/data/models/team_member_model.dart';
import 'package:moazez/feature/agreements/domain/usecases/get_team_members_usecase.dart';
import 'package:moazez/feature/home_supporter/domain/repositories/team_repository.dart';
import 'package:moazez/feature/home_supporter/domain/usecases/get_team_info_usecase.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/team_state.dart';

class TeamCubit extends Cubit<TeamState> {
  final GetTeamInfoUseCase getTeamInfoUseCase;
  final GetTeamMembersUsecase getTeamMembersUsecase;
  final TeamRepository teamRepository;

  TeamCubit({
    required this.getTeamInfoUseCase,
    required this.getTeamMembersUsecase,
    required this.teamRepository,
  }) : super(TeamInitial());

  Future<void> fetchTeamInfo() async {
    emit(TeamLoading());
    final result = await getTeamInfoUseCase(NoParams());
    if (isClosed) return;

    result.fold(
      (failure) => emit(TeamError(message: failure.message)),
      (team) async {
        // After getting team info, fetch members
        final membersResult = await getTeamMembersUsecase(NoParams());
        if (isClosed) return;

        membersResult.fold(
          (failure) => emit(TeamLoaded(team: team)), // Load team without members on failure
          (members) => emit(TeamLoaded(team: team, members: members as List<TeamMemberModel>)),
        );
      },
    );
  }

  Future<void> fetchTeamMembers() async {
    emit(TeamMembersLoading());
    final result = await getTeamMembersUsecase(NoParams());
    if (isClosed) return;

    result.fold(
      (failure) => emit(TeamMembersError(message: 'فشل في جلب بيانات الأعضاء')),
      (members) => emit(TeamMembersLoaded(members: members as List<TeamMemberModel>)),
    );
  }

  Future<void> createTeam(String teamName) async {
    emit(TeamLoading());
    final result = await teamRepository.createTeam(teamName);
    if (isClosed) return;

    result.fold(
      (failure) => emit(TeamError(message: failure.message)),
      (team) => emit(TeamLoaded(team: team)),
    );
  }

  Future<void> updateTeamName(String newName) async {
    emit(TeamLoading());
    final result = await teamRepository.updateTeamName(newName);
    if (isClosed) return;

    result.fold(
      (failure) => emit(TeamError(message: failure.message)),
      (team) => emit(TeamLoaded(team: team)),
    );
  }

  Future<void> removeTeamMember(int memberId) async {
    emit(TeamLoading());
    final result = await teamRepository.removeTeamMember(memberId);
    if (isClosed) return;

    result.fold(
      (failure) => emit(TeamError(message: failure.message)),
      (team) async {
        emit(TeamLoaded(team: team));
        await fetchTeamInfo(); // Refresh both team and members info
      },
    );
  }
}
