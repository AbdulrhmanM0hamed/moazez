import 'package:flutter/material.dart';
import 'package:moazez/feature/home/presentation/widgets/home_top_section.dart';
import 'package:moazez/feature/home/presentation/widgets/invite_participants_section.dart';
import 'package:moazez/feature/home/presentation/widgets/progress_chart.dart';
import 'package:moazez/feature/home/presentation/widgets/participants_section.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const HomeTopSection(),
          const SizedBox(height: 24),
          // dummy data
          const ProgressChart(
            items: [
              ParticipantProgress(
                percent: 1,
                avatarPath: 'assets/images/avatar.jpg',
              ),
              ParticipantProgress(
                percent: 0.6,
                avatarPath: 'assets/images/avatar.jpg',
              ),
              ParticipantProgress(
                percent: 0.4,
                avatarPath: 'assets/images/avatar.jpg',
              ),
              ParticipantProgress(
                percent: 0.8,
                avatarPath: 'assets/images/avatar.jpg',
              ),
              ParticipantProgress(
                percent: 0.7,
                avatarPath: 'assets/images/avatar.jpg',
              ),
              ParticipantProgress(
                percent: 0.2  ,
                avatarPath: 'assets/images/avatar.jpg',
              ),
              ParticipantProgress(
                percent: 0.3,
                avatarPath: 'assets/images/avatar.jpg',
              ),
              ParticipantProgress(
                percent: 1.0,
                avatarPath: 'assets/images/avatar.jpg',
              ),
              ParticipantProgress(
                percent: 0.8,
                avatarPath: 'assets/images/avatar.jpg',
              ),
              ParticipantProgress(
                percent: 0.55,
                avatarPath: 'assets/images/avatar.jpg',
              ),
              ParticipantProgress(
                percent: 0.3,
                avatarPath: 'assets/images/avatar.jpg',
              ),
              ParticipantProgress(
                percent: 1.0,
                avatarPath: 'assets/images/avatar.jpg',
              ),
              ParticipantProgress(
                percent: 0.8,
                avatarPath: 'assets/images/avatar.jpg',
              ),
              ParticipantProgress(
                percent: 0.55,
                avatarPath: 'assets/images/avatar.jpg',
              ),
              ParticipantProgress(
                percent: 0.3,
                avatarPath: 'assets/images/avatar.jpg',
              ),
              ParticipantProgress(
                percent: 1.0,
                avatarPath: 'assets/images/avatar.jpg',
              ),
            ],
          ),
          const SizedBox(height: 24),
          const ParticipantsSection(),
          const SizedBox(height: 8),
          const InviteParticipantsSection(),
        ],
      ),
    );
  }
}
