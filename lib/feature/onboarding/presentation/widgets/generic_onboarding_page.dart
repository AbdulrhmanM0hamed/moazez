import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';

class GenericOnboardingPage extends StatelessWidget {
  const GenericOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          SvgPicture.asset(
            'assets/images/on_boarding.svg',
            height: MediaQuery.of(context).size.height * 0.35,
          ),
          const SizedBox(height: 40),
          Text(
            '"معزز" منصة تدعم بناء العادات الإيجابية من خلال الاتفاق السلوكي والدعم المتبادل.',
            textAlign: TextAlign.center,
            style: getBoldStyle(
        
              fontSize: FontSize.size22,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'حدد هدفك، اتفق مع شخص تثق فيه، وتابع التزام الطرف الآخر بخطوات واضحة نحو التغيير',
            textAlign: TextAlign.center,
            style: getRegularStyle(
              color: AppColors.textSecondary,
              fontSize: FontSize.size16,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
