import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';

import 'package:moazez/feature/home_supporter/presentation/view/create_team_view.dart';
import 'package:moazez/feature/home_supporter/presentation/widgets/create_team_prompt.dart';
import 'package:moazez/feature/home_supporter/presentation/widgets/home_top_section.dart';
import 'package:moazez/feature/home_supporter/presentation/widgets/invite_participants_section.dart';
import 'package:moazez/feature/home_supporter/presentation/widgets/participants_section.dart';
import 'package:moazez/feature/home_supporter/presentation/widgets/subscription_card.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/subscription_cubit.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/subscription_state.dart';
import 'package:moazez/feature/home_supporter/presentation/widgets/title_with_icon.dart';
import 'package:moazez/feature/home_supporter/presentation/widgets/progress_chart.dart';
import 'package:moazez/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/team_state.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/team_cubit.dart';

class PackagesView extends StatelessWidget {
  final ProfileLoaded profileState;
  final TeamState teamState;

  const PackagesView({
    super.key,
    required this.profileState,
    required this.teamState,
  });

  @override
  Widget build(BuildContext context) {
    // ScrollController for CustomScrollView

    // Determine if user owns a team based on team state
    bool ownsTeam = false;
    if (teamState is TeamLoaded) {
      final loadedState = teamState as TeamLoaded;
      // Use the is_owner field to determine ownership
      ownsTeam = loadedState.team.isOwner;
    } else if (teamState is TeamError) {
      final errorState = teamState as TeamError;
      // If the error message indicates the user does not own a team, explicitly set ownsTeam to false
      if (errorState.message.contains("لا تملك فريقاً")) {
        ownsTeam = false;
      }
    }

    return Column(
      children: [
        const HomeTopSection(),
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
                  builder: (context, subState) {
                    if (subState is SubscriptionLoading) {
                      return const Center(child: CustomProgressIndcator());
                    } else if (subState is SubscriptionLoaded) {
                      return SubscriptionCard(subscription: subState.subscription);
                    } else if (subState is SubscriptionError) {
                      return Center(child: Text(subState.message));
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (ownsTeam &&
                          teamState is TeamLoaded &&
                          (teamState as TeamLoaded).team.membersCount != null &&
                          (teamState as TeamLoaded).team.membersCount! >= 1)
                        Column(
                          children: [
                            TitleWithIcon(
                              title: 'تقدم المشاركين',
                              icon: Icons.bar_chart_rounded,
                            ),
                            const SizedBox(height: 16),
                            ProgressChart(
                              items: const [
                                ParticipantProgress(
                                  percent: 0.8,
                                  avatarPath: 'assets/images/avatar.jpg',
                                ),
                                ParticipantProgress(
                                  percent: 0.6,
                                  avatarPath: 'assets/images/avatar.jpg',
                                ),
                                ParticipantProgress(
                                  percent: 1.0,
                                  avatarPath: 'assets/images/avatar.jpg',
                                ),
                                ParticipantProgress(
                                  percent: 0.4,
                                  avatarPath: 'assets/images/avatar.jpg',
                                ),
                                ParticipantProgress(
                                  percent: 0.9,
                                  avatarPath: 'assets/images/avatar.jpg',
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ParticipantsSection(),
                          ],
                        )
                      else if (ownsTeam)
                        Center(child: const InviteParticipantsSection())
                      else
                        Center(
                          child: CreateTeamPrompt(
                            onPressed: () async {
                              final result = await Navigator.pushNamed(
                                context,
                                CreateTeamView.routeName,
                              );
                              if (result == true) {
                                // Refresh team state after team creation
                                context.read<TeamCubit>().fetchTeamInfo();
                              }
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
