import 'package:flutter/material.dart';
import 'package:moazez/feature/splash/presentation/splash_view.dart';

Route<dynamic> onGenratedRoutes(RouteSettings settings) {
  switch (settings.name) {
    case SplashView.routeName:
      return MaterialPageRoute(builder: (context) => const SplashView());

    default:
      return MaterialPageRoute(builder: (context) => const SplashView());
  }
}
