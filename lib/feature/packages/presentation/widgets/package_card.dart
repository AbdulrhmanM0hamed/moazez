import 'package:flutter/material.dart';
import 'package:moazez/core/utils/common/custom_button.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/packages/domain/entities/package_entity.dart';

class PackageCard extends StatelessWidget {
  final PackageEntity package;
  final VoidCallback? onTap;

  const PackageCard({super.key, required this.package, this.onTap});

  Color get _primaryColor {
    if (package.name.contains('الأساسية'))
      return const Color(0xFF2196F3); // Blue for Basic
    if (package.name.contains('المتقدمة'))
      return const Color(0xFFFF9800); // Orange for Advanced
    if (package.name.contains('الاحترافية'))
      return const Color(0xFF9C27B0); // Purple for Professional
    return AppColors.primary;
  }

  Color get _secondaryColor {
    if (package.name.contains('الأساسية'))
      return const Color(0xFF1976D2); // Darker Blue
    if (package.name.contains('المتقدمة'))
      return const Color(0xFFF57C00); // Darker Orange
    if (package.name.contains('الاحترافية'))
      return const Color(0xFF7C4DFF); // Darker Purple
    return AppColors.secondary;
  }

  Color get _backgroundColor => Colors.white;

  Icon _getIcon(String type) {
    switch (type) {
      case 'price':
        return Icon(Icons.attach_money, color: _primaryColor, size: 24);
      case 'tasks':
        return Icon(Icons.task_alt, color: _primaryColor, size: 24);
      case 'members':
        return Icon(Icons.group, color: _primaryColor, size: 24);
      case 'stages':
        return Icon(Icons.layers, color: _primaryColor, size: 24);
      default:
        return Icon(Icons.check, color: _primaryColor, size: 20);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      elevation: 8,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: _primaryColor.withValues(alpha: 0.25),
          width: 1.3,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // Header with gradient
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryColor, _secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  package.name,
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // Price, Tasks, Members section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              color: _backgroundColor,
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildInfoItem('price', 'السعر', package.priceFormatted),
                      _verticalDivider(),
                      _buildInfoItem(
                        'tasks',
                        'المهام',
                        package.maxTasks.toString(),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      _buildInfoItem('members', 'الأعضاء', "غير محدود"),
                      _verticalDivider(),
                      _buildInfoItem(
                        'stages',
                        'المراحل لكل مهمة',
                        package.maxStagesPerTask != null
                            ? package.maxStagesPerTask.toString()
                            : 'غير محدد',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Features

            // Button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: CustomButton(
                  onPressed: onTap ?? () {},
                  text: 'اشترك الآن',
                  backgroundColor: _primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String type, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          _getIcon(type),
          const SizedBox(height: 2),
          Text(label, style: getSemiBoldStyle(fontFamily: FontConstant.cairo)),
          const SizedBox(height: 6),
          Text(
            value,
            style: getSemiBoldStyle(
              fontSize: 14,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() => Container(
    height: 60,
    width: 1,
    color: Colors.grey.withValues(alpha: 0.3),
    margin: const EdgeInsets.symmetric(horizontal: 6),
  );
}
