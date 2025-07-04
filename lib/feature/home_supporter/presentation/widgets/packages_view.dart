import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';
import 'package:moazez/feature/home_supporter/presentation/view/create_team_view.dart';
import 'package:moazez/feature/home_supporter/presentation/widgets/create_team_prompt.dart';
import 'package:moazez/feature/home_supporter/presentation/widgets/home_top_section.dart';
import 'package:moazez/feature/home_supporter/presentation/widgets/invite_participants_section.dart';
import 'package:moazez/feature/home_supporter/presentation/widgets/participants_section.dart';
import 'package:moazez/feature/home_supporter/presentation/widgets/title_with_icon.dart';
import 'package:moazez/feature/home_supporter/presentation/widgets/progress_chart.dart';
import 'package:moazez/feature/packages/presentation/cubit/subscription_state.dart';
import 'package:moazez/feature/packages/presentation/widgets/packages_grid.dart';
import 'package:moazez/feature/packages/presentation/cubit/package_cubit.dart';
import 'package:moazez/feature/packages/presentation/cubit/package_state.dart';
import 'package:moazez/feature/packages/presentation/cubit/subscription_cubit.dart';
import 'package:moazez/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/team_state.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/team_cubit.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/member_stats_cubit.dart';
import 'package:moazez/core/services/service_locator.dart';

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
    bool ownsTeam = false;
    if (teamState is TeamLoaded) {
      final loadedState = teamState as TeamLoaded;
      ownsTeam = loadedState.team.isOwner;
    } else if (teamState is TeamError) {
      final errorState = teamState as TeamError;
      if (errorState.message.contains("لا تملك فريقاً")) {
        ownsTeam = false;
      }
    }

    return BlocProvider<MemberStatsCubit>(
      create: (context) => sl<MemberStatsCubit>()..fetchMemberTaskStats(),
      child: Column(
        children: [
          const HomeTopSection(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              children: [
                if (ownsTeam) ...[
                  if (teamState is TeamLoaded &&
                      (teamState as TeamLoaded).team.membersCount != null &&
                      (teamState as TeamLoaded).team.membersCount! >= 1) ...[
                    const SizedBox(height: 20),
                    const TitleWithIcon(
                      title: 'تقدم المشاركين',
                      icon: Icons.bar_chart_rounded,
                    ),
                    const SizedBox(height: 24),
                    const ProgressChart(),
                    const SizedBox(height: 16),
                    const TitleWithIcon(
                      title: 'المشاركين لديك',
                      icon: Icons.group,
                    ),
                    const SizedBox(height: 24),
                    const ParticipantsSection(),
                  ] else ...[
                    const InviteParticipantsSection(),
                  ],
                ] else ...[
                  // Center(
                  //   child: CreateTeamPrompt(
                  //     onPressed: () async {
                  //       final result = await Navigator.pushNamed(
                  //         context,
                  //         CreateTeamView.routeName,
                  //       );
                  //       if (result == true) {
                  //         context.read<TeamCubit>().fetchTeamInfo();
                  //       }
                  //     },
                  //   ),
                  // ),
                ],
                BlocBuilder<SubscriptionCubit, SubscriptionState>(
                  builder: (context, subscriptionState) {
                    bool showPackagesGrid = true;
                    if (subscriptionState is SubscriptionLoaded) {
                      showPackagesGrid = !subscriptionState.subscription.isActive;
                    } else if (subscriptionState is SubscriptionLoading) {
                      showPackagesGrid = false;
                    }

                    if (!showPackagesGrid) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        const TitleWithIcon(
                          title: 'اختر الباقة المناسبة لك',
                          icon: Icons.workspace_premium,
                        ),
                        const SizedBox(height: 16),
                        BlocProvider<PackageCubit>(
                          create: (_) => sl<PackageCubit>()..getPackages(),
                          child: BlocBuilder<PackageCubit, PackageState>(
                            builder: (context, packageState) {
                              if (packageState is PackageLoading) {
                                return const Center(
                                  child: CustomProgressIndcator(),
                                );
                              } else if (packageState is PackageLoaded) {
                                return PackagesGrid(
                                  packages: packageState.packages,
                                  childAspectRatio: 1.0,
                                );
                              } else if (packageState is PackageError) {
                                return Center(
                                  child: Text(packageState.message),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
