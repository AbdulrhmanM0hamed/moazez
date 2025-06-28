import 'package:flutter/material.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/agreements/domain/entities/task_details_entity.dart';
import 'package:moazez/feature/agreements/presentation/widgets/task_details/status_chip_ar.dart';

class TaskHeaderCard extends StatelessWidget {
  final TaskDetailsEntity taskDetails;
  const TaskHeaderCard({super.key, required this.taskDetails});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    taskDetails.title,
                    style: getBoldStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                StatusChipAr(status: taskDetails.status),
              ],
            ),
            if (taskDetails.description.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                taskDetails.description,
                style: getMediumStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  fontFamily: FontConstant.cairo,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
