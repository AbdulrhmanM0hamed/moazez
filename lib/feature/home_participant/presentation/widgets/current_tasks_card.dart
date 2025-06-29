import 'package:flutter/material.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/agreements/presentation/widgets/gradient_progress_indicator.dart';
import 'package:moazez/feature/task_details/presentation/view/task_details_view.dart';

class CurrentTasksCard extends StatelessWidget {
  final String status;
  final String title;
  final double progress;
  final int taskId;

  const CurrentTasksCard({
    super.key,
    required this.status,
    required this.title,
    required this.progress,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailsView(taskId: taskId),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.09),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size16,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                    softWrap: true,
                  ),
                ),
                const SizedBox(width: 16),
                _buildStatusBadge(context),
              ],
            ),
            const SizedBox(height: 16),
            _buildProgressRow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _getStatusColor(context, status).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        status,
        style: getMediumStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size12,
          color: _getStatusColor(context, status),
        ),
      ),
    );
  }

  Widget _buildProgressRow(BuildContext context) {
    final theme = Theme.of(context);
    final double progressValue = progress / 100.0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'التقدم',
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            Text(
              '${progress.toStringAsFixed(0)}%',
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GradientProgressIndicator(
          progress: progressValue,
          gradient: const LinearGradient(
            colors: [Color(0xFF0DD0F4), Color(0xFF006E82)],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(BuildContext context, String status) {
    switch (status) {
      case 'قيد التنفيذ':
        return Colors.blue;
      case 'مكتمل':
        return Colors.green;
      case 'قيد الانتظار':
        return Colors.orange;
      default:
        return Colors.orange;
    }
  }
}

class TitleWithSeeAll extends StatelessWidget {
  const TitleWithSeeAll({super.key, required this.onTap});

  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: Row(
        children: [
          Text(
            'مهامي الحالية',
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size16,
              color: AppColors.primary,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
