import 'package:flutter/material.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/home/presentation/widgets/participants_section.dart';
import 'package:moazez/feature/home/presentation/widgets/progress_chart.dart';
import 'package:moazez/feature/packages/domain/models/package_entity.dart';

class SubscribedContent extends StatelessWidget {
  final PackageEntity trialPackage;
  final List<PackageEntity> packages;
  final ScrollController? scrollController;

  const SubscribedContent({
    super.key,
    required this.trialPackage,
    required this.packages,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        // Progress Chart Section
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(
                  'تقدم المشاركين',
                  icon: Icons.bar_chart_rounded,
                ),
                const SizedBox(height: 16),
                ProgressChart(
                  items: [
                    const ParticipantProgress(percent: 0.8, avatarPath: 'assets/images/avatar.jpg'),
                    const ParticipantProgress(percent: 0.6, avatarPath: 'assets/images/avatar.jpg'),
                    const ParticipantProgress(percent: 1.0, avatarPath: 'assets/images/avatar.jpg'),
                    const ParticipantProgress(percent: 0.4, avatarPath: 'assets/images/avatar.jpg'),
                    const ParticipantProgress(percent: 0.9, avatarPath: 'assets/images/avatar.jpg'),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Participants Section
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildSectionTitle(
                    'المشاركون',
                    icon: Icons.group_rounded,
                  ),
                ),
                const SizedBox(height: 16),
                const ParticipantsSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, {required IconData icon}) {
    return Row(
      children: [
        Icon(icon, size: 24, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
