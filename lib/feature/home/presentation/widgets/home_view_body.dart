import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';
import 'package:moazez/feature/home/presentation/widgets/packages_view.dart';
import 'package:moazez/feature/home/presentation/cubit/subscription_cubit.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:moazez/feature/home/presentation/cubit/team_cubit.dart';
import 'package:moazez/feature/home/presentation/cubit/team_state.dart';

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
                return MultiBlocProvider(
                  providers: [
                    BlocProvider<SubscriptionCubit>(
                      create: (context) => sl<SubscriptionCubit>()..fetchCurrentSubscription(),
                    ),
                  ],
                  child: PackagesView(
                  profileState: profileState,
                  teamState: teamState,
                ),
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
