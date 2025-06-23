import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/common/custom_app_bar.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/core/utils/widgets/custom_snackbar.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';
import 'package:moazez/feature/home/presentation/cubit/team_cubit.dart';
import 'package:moazez/feature/home/presentation/cubit/team_state.dart';
import 'package:moazez/feature/home/domain/entities/team_entity.dart';
import 'package:moazez/feature/home/presentation/view/create_team_view.dart';
import 'package:moazez/feature/home/presentation/widgets/create_team_prompt.dart';
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
      backgroundColor: AppColors.scaffoldBackground,
      appBar: CustomAppBar(title: 'الفريق'),
      body: BlocConsumer<TeamCubit, TeamState>(
        listener: (context, state) {
          if (state is TeamError) {
            // Only show error if not in the middle of an update process
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
            setState(() {
              _currentTeam = state.team;
              _isUpdating = false;
            });
            // Show success message if team info is fetched successfully after update
            CustomSnackbar.show(
              context: context,
              message: 'تم تعديل اسم الفريق بنجاح',
              isError: false,
            );
          } else {}
        },
        builder: (context, state) {
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
              );
            } else {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 180.0,
                  ),
                  child: CreateTeamPrompt(
                    onPressed: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        CreateTeamView.routeName,
                      );
                      if (result == true) {
                        context.read<TeamCubit>().fetchTeamInfo();
                      }
                    },
                  ),
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
              );
            } else {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 180.0,
                  ),
                  child: CreateTeamPrompt(
                    onPressed: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        CreateTeamView.routeName,
                      );
                      if (result == true) {
                        context.read<TeamCubit>().fetchTeamInfo();
                      }
                    },
                  ),
                ),
              );
            }
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 180.0,
              ),
              child: CreateTeamPrompt(
                onPressed: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    CreateTeamView.routeName,
                  );
                  if (result == true) {
                    context.read<TeamCubit>().fetchTeamInfo();
                  }
                },
              ),
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
          TeamMembersCard(team: _currentTeam),
        ],
      ),
    );
  }
}
