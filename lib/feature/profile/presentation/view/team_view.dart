import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/common/custom_app_bar.dart';
import 'package:moazez/core/utils/common/unauthenticated_widget.dart';
import 'package:moazez/core/utils/widgets/custom_snackbar.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';
import 'package:moazez/feature/agreements/data/models/team_member_model.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/team_cubit.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/team_state.dart';
import 'package:moazez/feature/home_supporter/domain/entities/team_entity.dart';
import 'package:moazez/feature/profile/presentation/widgets/team_info_card.dart';
import 'package:moazez/feature/profile/presentation/widgets/team_members_card.dart';

class TeamView extends StatelessWidget {
  const TeamView({super.key});

  static const String routeName = '/team';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TeamCubit>()..fetchTeamInfo(),
      child: const _TeamViewBody(),
    );
  }
}

class _TeamViewBody extends StatefulWidget {
  const _TeamViewBody();

  @override
  _TeamViewBodyState createState() => _TeamViewBodyState();
}

class _TeamViewBodyState extends State<_TeamViewBody> {
  bool _isUpdating = false;
  TeamEntity? _currentTeam;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'الفريق'),
      body: BlocConsumer<TeamCubit, TeamState>(
        listener: (context, state) {
          if (state is TeamError) {
            if (!_isUpdating) {
              CustomSnackbar.show(
                context: context,
                message: state.message,
                isError: true,
              );
            }
            setState(() {
              _isUpdating = false;
            });
          } else if (state is TeamLoading) {
            debugPrint('Team Loading...');
          } else if (state is TeamLoaded) {
            final bool wasUpdating = _isUpdating;
            setState(() {
              _currentTeam = state.team;
              _isUpdating = false;
            });

            if (wasUpdating) {
              CustomSnackbar.show(
                context: context,
                message: 'تم تعديل اسم الفريق بنجاح',
                isError: false,
              );
            }
          }
        },
        builder: (context, state) {
          if (state is TeamError) {
            if (state.message.contains('Unauthenticated.')) {
              return const UnauthenticatedWidget();
            }
          }
          if (state is TeamLoading || _isUpdating) {
            return const Center(child: CustomProgressIndcator());
          } else if (state is TeamLoaded) {
            _currentTeam = state.team;
            if (state.team.isOwner) {
              return _buildTeamContent(
                context,
                state.team.name ?? 'فريق غير مسمى',
                state.team.membersCount ?? 0,
                state.team.isOwner,
                state.members ?? [],
              );
            } else {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 180.0,
                  ),
                  child: SizedBox.shrink(),
                ),
              );
            }
          } else if (_currentTeam != null) {
            if (_currentTeam!.isOwner) {
              return _buildTeamContent(
                context,
                _currentTeam!.name ?? 'فريق غير مسمى',
                _currentTeam!.membersCount ?? 0,
                _currentTeam!.isOwner,
                [], // Empty list since we don't have members in this state
              );
            } else {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 180.0,
                  ),
                  child: SizedBox.shrink(),
                ),
              );
            }
          }
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 180.0,
              ),
              child: SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTeamContent(
    BuildContext context,
    String teamName,
    int membersCount,
    bool isOwner,
    List<TeamMemberModel> members,
  ) {
    final TextEditingController teamNameController = TextEditingController(
      text: teamName,
    );
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TeamInfoCard(
            teamName: teamName,
            membersCount: membersCount,
            isOwner: isOwner,
            teamNameController: teamNameController,
            onUpdatingStateChange: (isUpdating) {
              setState(() {
                _isUpdating = isUpdating;
              });
            },
          ),
          const SizedBox(height: 24),
          TeamMembersCard(team: _currentTeam, members: members),
        ],
      ),
    );
  }
}
