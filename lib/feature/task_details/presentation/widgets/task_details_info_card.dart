import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/feature/task_details/domain/entites/task_details_entity.dart';
import 'package:moazez/feature/task_details/presentation/widgets/info_tile.dart';

class TaskDetailsInfoCard extends StatelessWidget {
  final TaskDetailsEntity taskDetails;
  const TaskDetailsInfoCard({super.key, required this.taskDetails});

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'غير محدد';
    try {
      final date = DateTime.parse(dateString);
      // Ensure you have initialized localization for Arabic
      return intl.DateFormat.yMMMd('ar').format(date);
    } catch (e) {
      return 'تاريخ غير صالح';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'التفاصيل',
              style: getBoldStyle(
                color: theme.primaryColor,
                fontSize: 18,
                fontFamily: FontConstant.cairo,
              ),
            ),
            const Divider(height: 24),
            InfoTile(
              icon: Icons.person_outline,
              title: 'المُنشئ',
              value: taskDetails.creator.name,
            ),
            InfoTile(
              icon: Icons.person_pin_outlined,
              title: 'المُستلم',
              value: taskDetails.receiver.name,
            ),
            InfoTile(
              icon: Icons.group_outlined,
              title: 'الفريق',
              value: taskDetails.team.name,
            ),
            InfoTile(
              icon: Icons.calendar_today_outlined,
              title: 'تاريخ البدء',
              value: _formatDate(taskDetails.startDate),
            ),
            InfoTile(
              icon: Icons.event_available_outlined,
              title: 'تاريخ الاستحقاق',
              value: _formatDate(taskDetails.dueDate),
            ),
          ],
        ),
      ),
    );
  }
}
