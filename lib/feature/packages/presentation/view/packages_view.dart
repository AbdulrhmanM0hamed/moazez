import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';
import 'package:moazez/core/utils/common/custom_app_bar.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/packages/presentation/cubit/package_cubit.dart';
import 'package:moazez/feature/packages/presentation/cubit/package_state.dart';
import 'package:moazez/feature/packages/presentation/widgets/packages_grid.dart';

class PackagesView extends StatelessWidget {
  static const String routeName = '/packages';

  const PackagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PackageCubit>()..getPackages(),
      child: Scaffold(
        appBar: CustomAppBar(title: 'الباقات'),
        body: BlocBuilder<PackageCubit, PackageState>(
          builder: (context, state) {
            if (state is PackageLoading) {
              return const Center(child: CustomProgressIndcator());
            } else if (state is PackageLoaded) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: PackagesGrid(packages: state.packages),
              );
            } else if (state is PackageError) {
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
    );
  }
}
