import 'package:flutter/material.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/auth/presentation/pages/login_view.dart';
import 'package:moazez/feature/onboarding/presentation/widgets/generic_onboarding_page.dart';
import 'package:moazez/feature/onboarding/presentation/widgets/participant_onboarding_page.dart';
import 'package:moazez/feature/onboarding/presentation/widgets/supporter_onboarding_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatefulWidget {
  static const String routeName = '/onboarding';

  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _controller = PageController();

  final List<Widget> _pages = const [
    GenericOnboardingPage(),
    SupporterOnboardingPage(),
    ParticipantOnboardingPage(),
  ];

  void _onDone() {
    sl<CacheService>().setIsFirstTime(false);
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(LoginView.routeName);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                reverse: true,
                controller: _controller,
                children: _pages,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return _buildNavigation();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigation() {
    final isLastPage =
        _controller.hasClients &&
        _controller.page != null &&
        _controller.page!.round() == _pages.length - 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left button: "Next" or "Get Started"
        if (isLastPage)
          SizedBox(
            width: 80, // Match the width of the skip button
            child: ElevatedButton(
            onPressed: _onDone,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            ),
            child: Text('ابدأ الآن',
                style: getSemiBoldStyle(
                  color: Colors.white,
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size16,
                )),
          ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                _controller.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),

        // Center: Dots indicator
        Directionality(
          textDirection: TextDirection.ltr,
          child: SmoothPageIndicator(
            textDirection: TextDirection.ltr,
            controller: _controller,
            count: _pages.length,
            effect: ExpandingDotsEffect(
              dotColor: Colors.grey.shade300,
              activeDotColor: AppColors.primary,
              dotHeight: 8,
              dotWidth: 8,
              expansionFactor: 3,
              spacing: 5,
            ),
            onDotClicked: (index) {
              _controller.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            },
          ),
        ),

        // Right button: "Skip" or empty space
        if (isLastPage)
          const SizedBox(width: 80) // Placeholder to balance the row
        else
          SizedBox(
            width: 80,
            child: TextButton(
              onPressed: _onDone,
              child: Text(
                'تخطى',
                style: getRegularStyle(
                  color: AppColors.grey,
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size16,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
