import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/home/presentation/widgets/fallback_subscribed_content.dart';
import 'package:moazez/feature/home/presentation/widgets/home_top_section.dart';
import 'package:moazez/feature/home/presentation/widgets/non_subscribed_content.dart';
import 'package:moazez/feature/home/presentation/widgets/subscribed_content.dart';
import 'package:moazez/feature/packages/domain/models/package_entity.dart';
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
                  // Fallback to a default view for subscribed users if there's an error
                  bool isSubscribed = profileState.profileResponse?.data?.user?.activeSubscription != null;
                  if (isSubscribed) {
                    return const FallbackSubscribedContent();
                  } else {
                    return ErrorView(message: packagesState.message);
                  }
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
    // Safely check if the user has an active subscription with null checks
    bool isSubscribed = profileState.profileResponse?.data?.user?.activeSubscription != null;
    
    // ScrollController for CustomScrollView
    final ScrollController scrollController = ScrollController();
    
    // Callback to scroll down to trial package section
    void scrollToTrialPackageSection() {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent * 0.5, // Adjust to scroll to an approximate position
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    }
    
    return Column(
      children: [
        const HomeTopSection(),
        const SizedBox(height: 24),
        Expanded(
          child: isSubscribed
              ? SubscribedContent(
                  trialPackage: packagesState.trialPackage,
                  packages: packagesState.packages,
                  scrollController: scrollController,
                )
              : NonSubscribedContent(
                  trialPackage: packagesState.trialPackage,
                  packages: packagesState.packages,
                  onSubscribePressed: scrollToTrialPackageSection,
                  scrollController: scrollController,
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
