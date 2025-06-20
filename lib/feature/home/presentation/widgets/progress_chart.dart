import 'package:flutter/material.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';

class ParticipantProgress {
  final double percent; // value between 0 and 1
  final String avatarPath;
  const ParticipantProgress({required this.percent, required this.avatarPath});
}

class ProgressChart extends StatelessWidget {
  const ProgressChart({super.key, required this.items});

  final List<ParticipantProgress> items;

  @override
  Widget build(BuildContext context) {
    // Height of chart area for bars only (exclude avatars and labels)
    const double chartHeight = 180;
    const double avatarSize = 32;
    const double avatarSpacing = 8;

    return SizedBox(
      height:
          chartHeight +
          avatarSpacing +
          avatarSize, // Total height calculated from components
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          children: [
            // Grid background behind the bars
            Positioned.fill(
              child: CustomPaint(painter: _ChartGridPainter(chartHeight)),
            ),
            // Main content (labels + bars) shifted a bit to the right to leave room for Y-axis labels
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Y-axis labels 100%, 80%, … 0%
                  Column(
                    children: [
                      SizedBox(
                        height: chartHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(6, (i) {
                            final percentText = (100 - i * 20).toString();
                            return Text(
                              '$percentText%',
                              style: const TextStyle(fontSize: 12),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: avatarSpacing),
                      SizedBox(height: avatarSize), // Spacer for avatar
                    ],
                  ),
                  const SizedBox(width: 12),
                  // Bars list with participant avatars underneath
                  Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      separatorBuilder:
                          (context, _) => const SizedBox(width: 15.7),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Progress bar
                            SizedBox(
                              height: chartHeight,
                              width: 12,
                              child: Stack(
                                clipBehavior:
                                    Clip.none, // Allow the dot to overflow
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Container(
                                    width: 12,
                                    height: chartHeight * item.percent,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          AppColors.primary,
                                          AppColors.primary.withOpacity(0.4),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  if (item.percent == 1)
                                    const Positioned(
                                      top:
                                          -3, // Position the dot on top of the bar
                                      left: 1,
                                      child: Icon(
                                        Icons.circle,
                                        size: 10,
                                        color: Color.fromARGB(255, 5, 226, 12),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            // Participant avatar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                item.avatarPath,
                                width: 20,
                                height: 20,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartGridPainter extends CustomPainter {
  const _ChartGridPainter(this.chartHeight);

  final double chartHeight;
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey.withOpacity(0.2)
          ..strokeWidth = 1;

    // draw horizontal grid lines each 20%
    for (int i = 0; i <= 5; i++) {
      final y = (chartHeight) * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  @override
  bool shouldRepaint(covariant _ChartGridPainter oldDelegate) =>
      oldDelegate.chartHeight != chartHeight;
}
