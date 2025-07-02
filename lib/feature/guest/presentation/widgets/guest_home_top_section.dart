import 'package:flutter/material.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/guest/presentation/widgets/guest_home_header.dart';

class GuestHomeTopSection extends StatelessWidget {
  const GuestHomeTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const GuestHomeHeader(),
          Text(
            'ابحث عن اتفاقياتك أو تابع تقدم مشاركيك لتحقيق أهدافهم',
            style: getRegularStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              // Show a message for guest users
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ميزة البحث متاحة للمستخدمين المسجلين فقط')),
              );
            },
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ابحث عن مهمة...',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const Icon(Icons.search, size: 30, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}