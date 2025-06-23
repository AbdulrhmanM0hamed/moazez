import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';
import 'package:moazez/feature/home/presentation/widgets/packages_view.dart';
import 'package:moazez/feature/packages/presentation/cubit/packages_cubit.dart';
import 'package:moazez/feature/packages/presentation/cubit/packages_state.dart';
import 'package:moazez/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:moazez/feature/home/presentation/cubit/team_cubit.dart';
import 'package:moazez/feature/home/presentation/cubit/team_state.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        context.read<ProfileCubit>().fetchProfile();
        context.read<PackagesCubit>().fetchPackages();
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
            return BlocBuilder<PackagesCubit, PackagesState>(
              builder: (context, packagesState) {
                if (packagesState is PackagesLoading) {
                  return const Center(child: CustomProgressIndcator());
                }
                if (packagesState is PackagesError) {
                  return Center(
                    child: Text(
                      "خطأ في تحميل الباقات: ${packagesState.message}",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                }
                if (packagesState is PackagesLoaded) {
                  return BlocBuilder<TeamCubit, TeamState>(
                    builder: (context, teamState) {
                      if (teamState is TeamLoading) {
                        return const Center(child: CustomProgressIndcator());
                      }
                      return PackagesView(
                        profileState: profileState,
                        packagesState: packagesState,
                        teamState: teamState,
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            );
          }
          return const Center(child: CustomProgressIndcator());
        },
      ),
    );
  }
}
