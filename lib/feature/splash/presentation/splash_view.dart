import 'package:flutter/material.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/animations/door_open_animation.dart';
import 'package:moazez/feature/onboarding/presentation/onboarding_view.dart';
import 'package:moazez/feature/home_supporter/presentation/view/supporter_nav_bar.dart';
import 'package:moazez/feature/home_participant/presentation/view/participants_nav_bar.dart';
import 'package:moazez/feature/auth/presentation/pages/login_view.dart';
import 'package:moazez/feature/profile/data/datasources/profile_remote_data_source.dart';
import '../../../core/utils/constant/app_assets.dart';

class SplashView extends StatefulWidget {
  static const String routeName = '/splash';
  const SplashView({super.key});

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
      // Check if token is still valid
      try {
        await sl<ProfileRemoteDataSource>().getProfile();
        // If we get here, token is valid
        route =
            (role == null || role == 'Participant')
                ? ParticipantsNavBar.routeName
                : SupporterNavBar.routeName;
      } catch (e) {
        // Token is invalid or expired
        route = LoginView.routeName;
        // Clear all cache since token is invalid
        await cache.clearCache();
      }
    } else if (!isFirstTime) {
      route = OnboardingView.routeName;
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DoorOpenAnimation(
              height: 300, // أو أي ارتفاع تريده
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    AppAssets.splashImage,
                    width: MediaQuery.of(context).size.width * 0.5,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
