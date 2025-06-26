import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moazez/core/utils/animations/custom_animations.dart';
import 'package:moazez/feature/home_supporter/domain/entities/member_stats_entity.dart';
import 'package:moazez/feature/agreements/presentation/widgets/gradient_progress_indicator.dart';

class AgreementCard extends StatelessWidget {
  final MemberStatsEntity member;
  final VoidCallback onTap;

  const AgreementCard({super.key, required this.member, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completedTasks = member.tasks.where((t) => t.status == 'completed').length;
    final totalTasks = member.tasks.length;
    final progressString = member.stats.completionPercentageMargin.replaceAll('%', '');
    final progressValue = (double.tryParse(progressString) ?? 0.0) / 100.0;

    return CustomAnimations.fadeIn(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildInfoRow(
                context,
                title: 'التقدم',
                value: '${(progressValue * 100).toStringAsFixed(0)}%',
                indicator: GradientProgressIndicator(
                  progress: progressValue,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF006E82), Color(0xFF0DD0F4)],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildInfoRow(
                context,
                title: 'المهام',
                value: '$completedTasks من $totalTasks',
                indicator: _buildTasksIndicator(context, completedTasks, totalTasks),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: theme.scaffoldBackgroundColor,
          backgroundImage: member.avatarUrl.isNotEmpty
              ? CachedNetworkImageProvider(member.avatarUrl)
              : null,
          child: member.avatarUrl.isEmpty
              ? const Icon(Icons.person, size: 24, color: Colors.grey)
              : null,
        ),
        const SizedBox(width: 12),
        Text(
          member.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String title,
    required String value,
    required Widget indicator,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: theme.textTheme.bodyMedium),
            Text(value, style: theme.textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: 8),
        indicator,
      ],
    );
  }

  Widget _buildTasksIndicator(BuildContext context, int completed, int total) {
    if (total == 0) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return SizedBox(
      height: 8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: total > 0 ? completed / total : 0,
          backgroundColor: theme.scaffoldBackgroundColor,
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00B2D6)),
        ),
      ),
    );
  }
}
