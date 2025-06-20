import 'package:flutter/material.dart';
import 'package:moazez/feature/splash/presentation/splash_view.dart';
import 'package:moazez/feature/onboarding/presentation/onboarding_view.dart';

Route<dynamic> onGenratedRoutes(RouteSettings settings) {
  switch (settings.name) {
    case SplashView.routeName:
      return MaterialPageRoute(
        builder: (context) => const SplashView(),
      );
    case OnboardingView.routeName:
      return MaterialPageRoute(
        builder: (context) => const OnboardingView(),
      );
    default:
      return MaterialPageRoute(builder: (context) => const SplashView());
  }
}
