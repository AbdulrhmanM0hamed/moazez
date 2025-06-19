import 'package:flutter/material.dart';
import 'package:moazez/core/utils/theme/app_theme.dart';
import 'feature/splash/presentation/splash_view.dart';
import 'core/utils/helper/on_genrated_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: SplashView.routeName,
      onGenerateRoute: onGenratedRoutes,
    );
  }
}
