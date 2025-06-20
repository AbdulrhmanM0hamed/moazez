import 'package:flutter/material.dart';
import 'package:moazez/feature/home/presentation/widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: HomeViewBody());
  }
}
