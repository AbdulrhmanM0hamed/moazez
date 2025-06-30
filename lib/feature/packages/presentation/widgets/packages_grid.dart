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
    this.crossAxisSpacing = 1,
    this.mainAxisSpacing = 1,
    this.childAspectRatio = 1.16, // تعديل النسبة لتناسب التصميم الجديد
  });

  @override
  Widget build(BuildContext context) {
    // Filter out trial packages to show only paid packages
    final paidPackages = packages.where((package) => package.isTrial == false).toList();
    // Debug
    // ignore: avoid_print
    print("🟢 [PackagesGrid] Paid packages count: ${paidPackages.length}");
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _calculateCrossAxisCount(context),
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      ),
      itemBuilder: (context, index) {
        return PackageCard(
          package: paidPackages[index],
          onTap: () {
            final paymentCubit = context.read<PaymentCubit>();
            paymentCubit.initiatePayment(paidPackages[index].id);
            print("🟢 [PackagesGrid] Paid packages id: ${paidPackages[index].id}");
          },
        );
      },
      itemCount: paidPackages.length,
    );
  }

  int _calculateCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) {
      return 3;
    } else if (width > 700) {
      return 2;
    } else {
      return 1; // عرض كامل الشاشة على الهواتف الصغيرة
    }
  }
}
