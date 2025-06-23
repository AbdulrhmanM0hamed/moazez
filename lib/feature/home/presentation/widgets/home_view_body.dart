import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/home/presentation/widgets/home_top_section.dart';
import 'package:moazez/feature/home/presentation/widgets/trial_package_status.dart';
import 'package:moazez/feature/home/presentation/widgets/progress_chart.dart';
import 'package:moazez/feature/home/presentation/widgets/participants_section.dart';
import 'package:moazez/feature/packages/presentation/cubit/packages_cubit.dart';
import 'package:moazez/feature/packages/presentation/cubit/packages_state.dart';
import 'package:moazez/feature/profile/presentation/cubit/profile_cubit.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, profileState) {
        if (profileState is ProfileLoading) {
          return const LoadingView();
        }
        if (profileState is ProfileError) {
          return ErrorView(message: profileState.message);
        }
        if (profileState is ProfileLoaded) {
          return BlocBuilder<PackagesCubit, PackagesState>(
            builder: (context, packagesState) {
              if (packagesState is PackagesLoading) {
                return const LoadingView();
              }
                if (packagesState is PackagesError) {
                  return ErrorView(message: "خطأ في تحميل الباقات: ${packagesState.message}");
                }
              if (packagesState is PackagesLoaded) {
                return _buildPackagesView(
                  context,
                  profileState,
                  packagesState,
                );
              }
              return const SizedBox();
            },
          );
        }
        return const LoadingView();
      },
    );
  }

  Widget _buildPackagesView(
    BuildContext context,
    ProfileLoaded profileState,
    PackagesLoaded packagesState,
  ) {
    // ScrollController for CustomScrollView
    final ScrollController scrollController = ScrollController();
    
    // Check if the active subscription package name is "الباقة التجريبية"
    bool showTrialPackageStatus = profileState.profileResponse?.data?.user?.activeSubscription?.packageName == "الباقة التجريبية";
    
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        const SliverToBoxAdapter(
          child: HomeTopSection(),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 16),
        ),
        if (showTrialPackageStatus)
          const SliverToBoxAdapter(
            child: TrialPackageStatus(),
          ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.bar_chart_rounded, size: 24, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text(
                      'تقدم المشاركين',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ProgressChart(
                  items: const [
                    ParticipantProgress(percent: 0.8, avatarPath: 'assets/images/avatar.jpg'),
                    ParticipantProgress(percent: 0.6, avatarPath: 'assets/images/avatar.jpg'),
                    ParticipantProgress(percent: 1.0, avatarPath: 'assets/images/avatar.jpg'),
                    ParticipantProgress(percent: 0.4, avatarPath: 'assets/images/avatar.jpg'),
                    ParticipantProgress(percent: 0.9, avatarPath: 'assets/images/avatar.jpg'),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(Icons.group_rounded, size: 24, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'المشاركون',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                ParticipantsSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CustomProgressIndcator(
        size: 40,
        color: AppColors.primary,
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  final String message;

  const ErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    // Format the error message to avoid displaying raw failure objects
    String displayMessage = message;
    if (message.contains('ValidationFailure') || message.contains('Failure') || message.contains('instance of') || message.isEmpty) {
      displayMessage = 'حدث خطأ أثناء تحميل البيانات. يرجى المحاولة لاحقًا.';
    }
    return Center(
      child: Text(
        displayMessage,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
