import 'package:flutter/material.dart';
import 'package:moazez/feature/packages/domain/models/package_entity.dart';
import 'package:moazez/feature/packages/presentation/widgets/package_card.dart';

class PackagesGrid extends StatelessWidget {
  final List<PackageEntity> packages;
  final EdgeInsets padding;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;

  const PackagesGrid({
    super.key,
    required this.packages,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
    this.crossAxisSpacing = 1,
    this.mainAxisSpacing = 1,
    this.childAspectRatio = 1.5, // تعديل النسبة لتناسب التصميم الجديد
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding,
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _calculateCrossAxisCount(context),
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            // Check if this is a trial package
            final bool isTrial = packages[index].isTrial;
            
            return PackageCard(
              package: packages[index],
              isTrial: isTrial,
            );
          },
          childCount: packages.length,
        ),
      ),
    );
  }

  int _calculateCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 3;
    if (width > 700) return 2;
    return 1; // عرض كامل الشاشة على الهواتف الصغيرة
  }
}
