import 'package:flutter/material.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';

/// Chip widget for displaying status in Arabic with color
class StatusChipAr extends StatelessWidget {
  final String status;
  const StatusChipAr({super.key, required this.status});

  static const Map<String, String> arStatus = {
    'completed': 'مكتملة',
    'in_progress': 'قيد التنفيذ',
    'pending': 'معلقة',
    'not_completed': 'غير مكتملة',
  };

  static const Map<String, String> statusText = {
    'pending': 'Pending',
    'in_progress': 'In Progress',
    'completed': 'Completed',
  };

  static const Map<String, String> statusTextAr = {
    'pending': 'في الانتظار',
    'in_progress': 'قيد التنفيذ',
    'completed': 'مكتمل',
  };
  static const Map<String, Color> statusColor = {
    'completed': Colors.green,
    'in_progress': Colors.blue,
    'pending': Colors.orange,
    'not_completed': Colors.red,
  };

  @override
  Widget build(BuildContext context) {
    final lower = status.toLowerCase();
    final label = arStatus[lower] ?? status;
    final color = statusColor[lower] ?? Colors.grey;
    return Chip(
      label: Text(
        label,
        style: getBoldStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: FontConstant.cairo,
        ),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
