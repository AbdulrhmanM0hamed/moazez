import 'package:flutter/material.dart';
import 'package:moazez/core/utils/common/custom_text_field.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'home_header.dart';

class HomeTopSection extends StatelessWidget {
  const HomeTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
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
          const HomeHeader(),
          Text(
            'ابحث عن اتفاقياتك أو تابع تقدم مشاركيك لتحقيق أهدافهم',
            style: getRegularStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          // Search field
          SizedBox(
            height: 50, // Reduce the height of the text field
            child: CustomTextField(
              hint: 'ابحث...',
              prefix: const Icon(Icons.search, size: 35, color: AppColors.textSecondary),
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              keyboardType: TextInputType.text,
              onSubmitted: (v) {},
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ),
    );
  }
}
