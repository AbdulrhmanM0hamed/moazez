import 'package:flutter/material.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/feature/task_details/domain/entites/task_details_entity.dart';
import 'package:moazez/feature/task_details/presentation/widgets/info_tile.dart';

class TaskRewardCard extends StatelessWidget {
  final TaskDetailsEntity taskDetails;
  const TaskRewardCard({super.key, required this.taskDetails});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool hasAmount =
        taskDetails.rewardAmount != null && taskDetails.rewardAmount!.isNotEmpty;
    final bool hasDescription =
        taskDetails.rewardDescription != null &&
        taskDetails.rewardDescription!.isNotEmpty;

    if (!hasAmount && !hasDescription) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.emoji_events_outlined,
                    color: theme.primaryColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  'المعزز',
                  style: getBoldStyle(
                    color: theme.primaryColor,
                    fontSize: 18,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            if (taskDetails.rewardType?.toLowerCase() == 'other')
              InfoTile(
                icon: Icons.card_giftcard_outlined,
                title: 'المعزز',
                value: taskDetails.rewardDescription ?? 'غير محدد',
              )
            else ...[
              if (hasAmount)
                InfoTile(
                  icon: Icons.monetization_on_outlined,
                  title: 'المبلغ',
                  value: taskDetails.rewardAmount!,
                ),
              if (hasDescription)
                InfoTile(
                  icon: Icons.description_outlined,
                  title: 'الوصف',
                  value: taskDetails.rewardDescription!,
                ),
            ],
          ],
        ),
      ),
    );
  }
}
