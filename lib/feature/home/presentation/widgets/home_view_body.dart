import 'package:flutter/material.dart';
import 'package:moazez/feature/home/presentation/widgets/home_top_section.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: const [HomeTopSection(), SizedBox(height: 24)]);
  }
}
