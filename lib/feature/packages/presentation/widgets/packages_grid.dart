import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/feature/packages/domain/entities/package_entity.dart';
import 'package:moazez/feature/packages/presentation/widgets/package_card.dart';
import 'package:moazez/feature/packages/presentation/cubit/payment_cubit.dart';

class PackagesGrid extends StatelessWidget {
  final List<PackageEntity> packages;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;

  const PackagesGrid({
    super.key,
    required this.packages,
    this.crossAxisSpacing = 12,
    this.mainAxisSpacing = 2,
    this.childAspectRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final displayedPackages = packages;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // منع السكرول الداخلي
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _calculateCrossAxisCount(context),
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      ),
      itemBuilder: (context, index) {
        return PackageCard(
          package: displayedPackages[index],
          onTap: () {
            final paymentCubit = context.read<PaymentCubit>();
            paymentCubit.initiatePayment(displayedPackages[index].id);
          },
        );
      },
      itemCount: displayedPackages.length,
    );
  }

  int _calculateCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) {
      return 3;
    } else if (width > 700) {
      return 2;
    } else {
      return 1;
    }
  }
}
