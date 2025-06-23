import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:moazez/feature/home/presentation/view/create_team_view.dart';
import 'package:moazez/feature/home/presentation/widgets/create_team_prompt.dart';
import 'package:moazez/feature/home/presentation/widgets/home_top_section.dart';
import 'package:moazez/feature/home/presentation/widgets/invite_participants_section.dart';
import 'package:moazez/feature/home/presentation/widgets/trial_package_status.dart';
import 'package:moazez/feature/home/presentation/widgets/progress_chart.dart';
import 'package:moazez/feature/packages/presentation/cubit/packages_state.dart';
import 'package:moazez/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:moazez/feature/home/presentation/cubit/team_state.dart';
import 'package:moazez/feature/home/presentation/cubit/team_cubit.dart';

class PackagesView extends StatelessWidget {
  final ProfileLoaded profileState;
  final PackagesLoaded packagesState;
  final TeamState teamState;

  const PackagesView({
    super.key,
    required this.profileState,
    required this.packagesState,
    required this.teamState,
  });

  @override
  Widget build(BuildContext context) {
    // ScrollController for CustomScrollView
    final ScrollController scrollController = ScrollController();

    // Check if the active subscription package name is "الباقة التجريبية"
    bool showTrialPackageStatus =
        profileState
            .profileResponse
            ?.data
            ?.user
            ?.activeSubscription
            ?.packageName ==
        "الباقة التجريبية";

    // Determine if user owns a team based on team state
    bool ownsTeam = false;
    if (teamState is TeamLoaded) {
      final loadedState = teamState as TeamLoaded;
      ownsTeam = loadedState.team.isOwner ?? false;
    } else if (teamState is TeamError) {
      final errorState = teamState as TeamError;
      ownsTeam =
          errorState.message.contains("تم جلب فريقك الذي تملكه بنجاح") ||
          errorState.message.contains("تم إنشاء الفريق بنجاح");
    }

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        const SliverToBoxAdapter(child: HomeTopSection()),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        if (showTrialPackageStatus)
          const SliverToBoxAdapter(child: TrialPackageStatus()),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                if (ownsTeam &&
                    teamState is TeamLoaded &&
                    (teamState as TeamLoaded).team.membersCount != null &&
                    (teamState as TeamLoaded).team.membersCount! > 0)
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
                  )
                else if (ownsTeam)
                  Center(child: const InviteParticipantsSection())
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
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
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
