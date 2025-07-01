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
    this.childAspectRatio = 1.08, // تعديل النسبة لتناسب التصميم الجديد
  });

  @override
  Widget build(BuildContext context) {
    // عرض كل الباقات بما في ذلك التجريبية والمدفوعة
    final displayedPackages = packages;
    // Debug
    // ignore: avoid_print
    // print("🟢 [PackagesGrid] Packages count: ${displayedPackages.length}");
    return GridView.builder(
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
          //  print("🟢 [PackagesGrid] Paid packages id: ${paidPackages[index].id}");
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
      return 1; // عرض كامل الشاشة على الهواتف الصغيرة
    }
  }
}
