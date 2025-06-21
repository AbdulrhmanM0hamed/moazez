import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/common/custom_button.dart';
import 'package:moazez/core/utils/constant/app_assets.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/auth/presentation/pages/login_view.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({Key? key}) : super(key: key);

  static const String routeName = '/onBoarding';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Expanded(
                child: SvgPicture.asset(
                  AppAssets.onboardingIllustration,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'مرحباً بك في معزّز!\n\nهنا يلتقي الدعم بالإلتزام. قم بإبرام اتفاقياتك، اتبع عاداتك اليومية، واحصل على مكافأتك المستحقة سواءً كانت مادية أو معنوية.\n\nابدأ رحلتك الآن وصمِّم نجاحك بيدك.',
                textAlign: TextAlign.center,
                style: getMediumStyle(fontFamily: 'Cairo', fontSize: 18),
              ),
              const SizedBox(height: 40),
              CustomButton(
                text: 'ابدأ',
                onPressed: () async {
                  await sl<CacheService>().setIsFirstTime(false);
                  if (context.mounted) {
                    Navigator.of(context)
                        .pushReplacementNamed(LoginView.routeName);
                  }
                },
                backgroundColor: AppColors.primary,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
