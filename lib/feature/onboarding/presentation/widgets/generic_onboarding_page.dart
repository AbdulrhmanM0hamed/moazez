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
            'أنجز مهامك، وحقق أهدافك!',
            textAlign: TextAlign.center,
            style: getBoldStyle(
              color: AppColors.black,
              fontSize: FontSize.size22,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'مع "معزز"، يمكنك تحويل أهدافك إلى مهام قابلة للتنفيذ ومتابعة تقدمك بسهولة، مما يجعلك أقرب إلى تحقيق طموحاتك كل يوم.',
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
