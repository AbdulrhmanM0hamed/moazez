import 'package:flutter/material.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';

class TaskSummaryCard extends StatelessWidget {
  final int completedTasks;
  final int pendingTasks;

  const TaskSummaryCard({
    super.key,
    required this.completedTasks,
    required this.pendingTasks,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.09),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            context,
            count: completedTasks,
            title: 'مهام مكتملة',
            icon: Icons.check_circle_outline_rounded,
            color: AppColors.success,
          ),
          Container(
            height: 60,
            width: 1,
            color: theme.dividerColor.withValues(alpha: 0.5),
          ),
          _buildSummaryItem(
            context,
            count: pendingTasks,
            title: 'مهام قيد التنفيذ',
            icon: Icons.hourglass_top_rounded,
            color: AppColors.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context,
      {required int count, required String title, required IconData icon, required Color color}) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          count.toString(),
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
