import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';
import 'package:moazez/feature/home/presentation/widgets/packages_view.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/home/presentation/cubit/subscription_cubit.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:moazez/feature/home/presentation/cubit/team_cubit.dart';
import 'package:moazez/feature/home/presentation/cubit/team_state.dart';
import 'package:moazez/feature/invitations/presentation/send_invitations_view.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        context.read<ProfileCubit>().fetchProfile();
        context.read<TeamCubit>().fetchTeamInfo();
        await Future.delayed(const Duration(milliseconds: 1500));
      },
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, profileState) {
          if (profileState is ProfileLoading) {
            
            return const Center(child: CustomProgressIndcator());
          }
          if (profileState is ProfileError) {
            return Center(
              child: Text(
                profileState.message,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }
          if (profileState is ProfileLoaded) {
            return BlocBuilder<TeamCubit, TeamState>(
              builder: (context, teamState) {
                if (teamState is TeamLoading) {
                  return const Center(child: CustomProgressIndcator());
                }

                bool ownsTeam = false;
                if (teamState is TeamLoaded) {
                  ownsTeam = teamState.team.isOwner;
                } else if (teamState is TeamError) {
                  if (teamState.message.contains("لا تملك فريقاً")) {
                    ownsTeam = false;
                  }
                }

                return Stack(
                  children: [
                    MultiBlocProvider(
                      providers: [
                        BlocProvider<SubscriptionCubit>(
                          create: (context) =>
                              sl<SubscriptionCubit>()..fetchCurrentSubscription(),
                        ),
                      ],
                      child: PackagesView(
                        profileState: profileState,
                        teamState: teamState,
                      ),
                    ),
                    if (ownsTeam)
                      Positioned(
                        bottom: 1,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: AppColors.primary,
                              child: IconButton(
                                icon: const Icon(Icons.add,
                                    color: Colors.white, size: 32),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SendInvitationsView(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          } else if (profileState is ProfileError) {
            return Center(
              child: Text(
                profileState.message,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          } else {
            return const Center(child: CustomProgressIndcator());
          }
        },
      ),
    );
  }
}

// return BlocBuilder<ProfileCubit, ProfileState>(
//   builder: (context, profileState) {
//     if (profileState is ProfileLoading) {
//       return const Center(child: CustomProgressIndcator());
//     }
//     if (profileState is ProfileLoaded) {
//       return BlocBuilder<TeamCubit, TeamState>(
