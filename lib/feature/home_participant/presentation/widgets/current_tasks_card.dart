import 'package:flutter/material.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/agreements/presentation/widgets/gradient_progress_indicator.dart';

class CurrentTasksCard extends StatelessWidget {
  final String status;
  final String title;
  final double progress;
  final VoidCallback? onViewAllTap;

  const CurrentTasksCard({
    super.key,
    required this.status,
    required this.title,
    required this.progress,
    this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size16,
                  color: theme.textTheme.bodyLarge?.color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              _buildHeader(context),
            ],
          ),
          const SizedBox(height: 16),
          _buildProgressRow(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: _getStatusColor(
                      context,
                      status,
                    ).withValues(alpha: .08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  

                  child: Text(
                    status,
                    style: getMediumStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size12,
                      color: _getStatusColor(context, status),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_filled,
                      color: const Color.fromARGB(255, 61, 188, 211),
                    ),
                    SizedBox(width: 6),
                    Text("10 ايام"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressRow(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'التقدم',
              style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: getSemiBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GradientProgressIndicator(
          progress: progress,
          backgroundColor: theme.scaffoldBackgroundColor,
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
        return Colors.orange;
      case 'مكتمل':
        return Colors.green;
      case 'قيد الانتظار':
        return Colors.grey;
      default:
        return Theme.of(context).textTheme.bodySmall?.color ?? Colors.black;
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
          InkWell(
            onTap: onTap,
            child: Text(
              'عرض الكل',
              style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
