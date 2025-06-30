import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';
import 'package:moazez/core/utils/common/custom_app_bar.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/packages/presentation/cubit/subscription_cubit.dart';
import 'package:moazez/feature/packages/presentation/cubit/subscription_state.dart';
import 'package:moazez/feature/packages/presentation/widgets/subscription_card.dart';
import 'package:moazez/feature/packages/presentation/cubit/package_cubit.dart';
import 'package:moazez/feature/packages/presentation/cubit/package_state.dart';
import 'package:moazez/feature/packages/presentation/widgets/packages_grid.dart';

class PackagesView extends StatelessWidget {
  static const String routeName = '/packages';

  const PackagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PackageCubit>(
      create: (context) => sl<PackageCubit>()..getPackages(),
      child: BlocProvider<SubscriptionCubit>(
        create: (context) => sl<SubscriptionCubit>()..fetchCurrentSubscription(),
        child: Scaffold(
          appBar: CustomAppBar(title: 'الباقات'),
          body: BlocBuilder<PackageCubit, PackageState>(
            builder: (context, state) {
              return Column(
                children: [
                  // Adding SubscriptionCard at the top of the page
                  BlocBuilder<SubscriptionCubit, SubscriptionState>(
                    builder: (context, subState) {
                      if (subState is SubscriptionLoading) {
                        return const Center(child: CustomProgressIndcator());
                      } else if (subState is SubscriptionLoaded) {
                        return SubscriptionCard(subscription: subState.subscription);
                      } else if (subState is SubscriptionError) {
                        print(subState.message);
                        return Center(child: Text(subState.message));
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  Expanded(
                    child: BlocBuilder<PackageCubit, PackageState>(
                      builder: (context, state) {
                        if (state is PackageLoading) {
                          return const Center(child: CustomProgressIndcator());
                        } else if (state is PackageLoaded) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: PackagesGrid(packages: state.packages),
                          );
                        } else if (state is PackageError) {
                          print(state.message);
                          return Center(
                            child: Text(
                              state.message,
                              style: const TextStyle(color: AppColors.error),
                            ),
                          );
                        } else {
                          return const Center(child: Text('ابدأ بجلب الباقات'));
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
