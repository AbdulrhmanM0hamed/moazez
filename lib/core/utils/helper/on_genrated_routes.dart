import 'package:flutter/material.dart';
import 'package:moazez/feature/auth/presentation/pages/complete_profile_view.dart';
import 'package:moazez/feature/auth/presentation/pages/login_view.dart';
import 'package:moazez/feature/auth/presentation/pages/signup_view.dart';
import 'package:moazez/feature/home/presentation/view/home_view.dart';
import 'package:moazez/feature/splash/presentation/splash_view.dart';
import 'package:moazez/feature/onboarding/presentation/onboarding_view.dart';

Route<dynamic> onGenratedRoutes(RouteSettings settings) {
  switch (settings.name) {
    case SplashView.routeName:
      return MaterialPageRoute(builder: (context) => const SplashView());
    case OnboardingView.routeName:
      return MaterialPageRoute(builder: (context) => const OnboardingView());
    case RegisterView.routeName:
      return MaterialPageRoute(builder: (context) => const RegisterView());
    case LoginView.routeName:
      return MaterialPageRoute(builder: (context) => const LoginView());
    case CompleteProfileView.routeName:
      final args = settings.arguments as Map<String, String>;
      return MaterialPageRoute(
        builder: (context) => CompleteProfileView(signupData: args),
      );
    case HomeView.routeName:
      return MaterialPageRoute(builder: (context) => const HomeView());
    default:
      return MaterialPageRoute(builder: (context) => const SplashView());
  }
}
