import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';

import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';

class SupporterOnboardingPage extends StatelessWidget {
  const SupporterOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          SvgPicture.asset(
            'assets/images/progress_chart.svg',
            height: MediaQuery.of(context).size.height * 0.28,
          ),
          const SizedBox(height: 40),
          Text(
            'كن الداعم الذي يصنع الفارق',
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontSize: FontSize.size22,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'لأنك القائد الملهم خلف كل إنجاز، حدد المهام، تابع التقدم، وكن السبب في تطوير الآخرين.',
            textAlign: TextAlign.center,
            style: getRegularStyle(
              color: AppColors.textSecondary,
              fontSize: FontSize.size16,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 40),
          SvgPicture.asset(
            'assets/images/support.svg',
            height: MediaQuery.of(context).size.height * 0.25,
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
