import 'package:flutter/material.dart';
import 'package:moazez/feature/guest/presentation/widgets/guest_home_top_section.dart';
import 'package:moazez/feature/guest/presentation/widgets/guest_participants_section.dart';
import 'package:moazez/feature/guest/presentation/widgets/guest_progress_chart.dart';

class GuestPackagesView extends StatelessWidget {
  const GuestPackagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const GuestHomeTopSection(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const GuestProgressChart(),
                const SizedBox(height: 16),
                // الباقات تم إزالتها بناءً على طلب المستخدم
                const GuestParticipantsSection(),
                const SizedBox(height: 48),
               
              ],
            ),
          ),
        ],
      ),
    );
  }
}
