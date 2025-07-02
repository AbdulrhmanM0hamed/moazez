import 'package:flutter/material.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/feature/auth/presentation/pages/login_view.dart';
import 'package:moazez/feature/onboarding/presentation/onboarding_view.dart';
import 'package:moazez/feature/home_supporter/presentation/view/supporter_nav_bar.dart';
import 'package:moazez/feature/home_participant/presentation/view/participants_nav_bar.dart';
import '../../../core/utils/constant/app_assets.dart';
import '../../../core/utils/animations/custom_animations.dart';

class SplashView extends StatefulWidget {
  static const String routeName = '/splash';
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    // Wait for splash animation
    await Future.delayed(const Duration(milliseconds: 1800));

    final cache = sl<CacheService>();
    final bool isFirstTime = await cache.getIsFirstTime();
    final String? token = await cache.getToken();
    final String? role = await cache.getUserRole();

    String route;
    if (!isFirstTime && token != null) {
      // Default to Participant if no role is set for logged-in users
      route =
          (role == null || role == 'Participant')
              ? ParticipantsNavBar.routeName
              : SupporterNavBar.routeName;
    } else if (!isFirstTime) {
      route = LoginView.routeName;
    } else {
      route = OnboardingView.routeName;
    }

    if (mounted) {
      Navigator.of(context).pushReplacementNamed(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: CustomAnimations.doorOpen(
            child: Image.asset(
              AppAssets.splashImage,
              width: MediaQuery.of(context).size.width * 0.5,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
