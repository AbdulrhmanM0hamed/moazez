import 'package:flutter/material.dart';
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
    // After the animation ends, you can navigate to the next screen.
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
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
