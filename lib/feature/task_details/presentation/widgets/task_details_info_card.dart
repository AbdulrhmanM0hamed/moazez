import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/feature/task_details/domain/entities/task_details_entity.dart';
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
              title: 'المنشئ',
              value: taskDetails.creator.name,
            ),
            FutureBuilder<String?>(
  future: sl<CacheService>().getUserRole(), // حسب اللي بتستخدمه, // أو sl<CacheService>().getUserRole() حسب اللي بتستخدمه
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const SizedBox.shrink(); // أو مؤقتًا Placeholder صغير
    }

    final role = snapshot.data?.toLowerCase();
    if (role == 'participant') {
      return const SizedBox.shrink();
    }

    return InfoTile(
      icon: Icons.person_pin_outlined,
      title: 'المستلم',
      value: taskDetails.receiver.name,
    );
  },
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
            Builder(builder: (context) {
              int? durationInDays;
              if (taskDetails.startDate != null && taskDetails.dueDate != null) {
                try {
                  final startDate = DateTime.parse(taskDetails.startDate!);
                  final dueDate = DateTime.parse(taskDetails.dueDate!);
                  final difference = dueDate.difference(startDate).inDays;
                  // Add 1 to make the duration inclusive
                  durationInDays = difference >= 0 ? difference + 1 : null;
                } catch (e) {
                  durationInDays = null;
                }
              } else {
                durationInDays = null;
              }

              if (durationInDays == null) {
                return const SizedBox.shrink();
              }

              String durationText;
              if (durationInDays == 1) {
                durationText = 'يوم واحد';
              } else if (durationInDays == 2) {
                durationText = 'يومان';
              } else if (durationInDays >= 3 && durationInDays <= 10) {
                durationText = '$durationInDays أيام';
              } else {
                durationText = '$durationInDays يومًا';
              }

              return InfoTile(
                icon: Icons.timelapse_outlined,
                title: 'المدة',
                value: durationText,
              );
            }),
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
