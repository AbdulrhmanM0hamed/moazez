import 'package:flutter/material.dart';
import 'package:moazez/feature/home_supporter/presentation/widgets/home_top_section.dart';

class HomeParticipantsViewBody extends StatelessWidget {
  const HomeParticipantsViewBody({super.key});
  static const String routeName = '/home-participants-view-body';

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        HomeTopSection()        // TODO: Add widgets for home participants view body
      ],
    );
  }
}