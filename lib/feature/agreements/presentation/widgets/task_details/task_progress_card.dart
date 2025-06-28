import 'package:flutter/material.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';

class TaskProgressCard extends StatelessWidget {
  final int progress;
  const TaskProgressCard({super.key, required this.progress});

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
            Text(
              'تقدم المهمة',
              style: getBoldStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontFamily: FontConstant.cairo,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: SizedBox(
                        height: 12,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: progress / 100,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: const LinearGradient(
                                    begin: Alignment.centerRight,
                                    end: Alignment.centerLeft,
                                    colors: [
                                      Color(0xFF0DD0F4),
                                      Color(0xFF006E82),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '$progress%',
                  style: getBoldStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
