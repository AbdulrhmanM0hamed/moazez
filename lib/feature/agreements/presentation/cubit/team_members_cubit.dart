import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/usecases/usecase.dart';
import 'package:moazez/feature/agreements/domain/usecases/get_team_members_usecase.dart';
import 'package:moazez/feature/agreements/presentation/cubit/team_members_state.dart';

class TeamMembersCubit extends Cubit<TeamMembersState> {
  final GetTeamMembersUsecase getTeamMembersUsecase;

  TeamMembersCubit({required this.getTeamMembersUsecase}) : super(TeamMembersInitial());

  Future<void> fetchTeamMembers() async {
    emit(TeamMembersLoading());
    final failureOrMembers = await getTeamMembersUsecase(NoParams());
    failureOrMembers.fold(
      (failure) => emit(const TeamMembersError('فشل في جلب بيانات الأعضاء')),
      (members) => emit(TeamMembersLoaded(members)),
    );
  }
}
