import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moazez/feature/agreements/presentation/widgets/gradient_progress_indicator.dart';
import 'package:moazez/feature/agreements/presentation/widgets/stages_indicator.dart';
import 'package:moazez/feature/home_supporter/domain/entities/member_stats_entity.dart';

class MemberTaskCard extends StatelessWidget {
  final TaskEntity task;
  final MemberStatsEntity member;

  const MemberTaskCard({super.key, required this.task, required this.member});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String formatDate(String dateStr) {
      if (dateStr.isEmpty) return '';
      try {
        final date = DateTime.parse(dateStr);
        return '${date.day}/${date.month}';
      } catch (e) {
        return '';
      }
    }

    final dateRange =
        '${formatDate(task.createdAt)} - ${formatDate(task.dueDate)}';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Title, Date, Menu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateRange,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    // TODO: Implement menu action
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Progress
            _buildInfoRow(
              context,
              title: 'التقدم',
              value: '${task.progress}%',
              indicator: GradientProgressIndicator(
                progress: task.progress / 100.0,
                gradient: const LinearGradient(
                  colors: [Color(0xFF006E82), Color(0xFF0DD0F4)],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Stages
            _buildInfoRow(
              context,
              title: 'المراحل',
              value: '${task.stagesCount} مراحل',
              indicator: StagesIndicator(
                totalStages: task.stagesCount,
                completedStages: task.completedStages,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            // Participant
            Row(
              children: [
                Text(
                  'المشارك',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade700,
                  ),
                ),
                const Spacer(),
                CircleAvatar(
                  radius: 16,
                  backgroundImage:
                      (member.avatarUrl.isNotEmpty)
                          ? CachedNetworkImageProvider(member.avatarUrl)
                          : null,
                  child:
                      (member.avatarUrl.isEmpty)
                          ? const Icon(Icons.person, size: 16)
                          : null,
                ),
                const SizedBox(width: 8),
                Text(
                  member.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        indicator,
      ],
    );
  }
}
