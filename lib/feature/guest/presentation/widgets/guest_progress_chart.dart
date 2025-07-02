import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moazez/core/utils/animations/custom_animations.dart';
import 'package:moazez/feature/guest/data/models/dummy_member_stats_entity.dart';
import 'package:moazez/feature/home_supporter/domain/entities/member_stats_entity.dart';

class _ChartDataPoint {
  final MemberStatsEntity member;
  final TaskEntity task;
  _ChartDataPoint(this.member, this.task);
}

class GuestProgressChart extends StatelessWidget {
  const GuestProgressChart({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyStats = DummyMemberStatsData.getDummyMemberStats();
    final members = dummyStats.members;

    if (members.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/epmtyData.svg',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 16),
            const Text(
              'لا توجد بيانات لعرضها حاليًا، حاول لاحقًا!',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    // 1. Prepare a flat list of data points (member + task)
    final List<_ChartDataPoint> chartDataPoints = [];
    for (var member in members) {
      for (var task in member.tasks) {
        chartDataPoints.add(_ChartDataPoint(member, task));
      }
    }

    // 2. Generate BarChartGroupData from the flat list
    final barGroups = List.generate(chartDataPoints.length, (index) {
      final dataPoint = chartDataPoints[index];
      final percent = dataPoint.task.progress.toDouble();
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: percent,
            fromY: 0,
            gradient: const LinearGradient(
              colors: [Color(0xFF0DD0F4), Color(0xFF006E82)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            width: 12,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    });

    // 3. Generate labels and avatars from the flat list
    final taskLabels = chartDataPoints.map((dp) => dp.member.name).toList();
    final avatarUrls = chartDataPoints.map((dp) => dp.member.avatarUrl).toList();

    return CustomAnimations.scaleIn(
      duration: const Duration(milliseconds: 600),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          height: 250, // Fixed height for the entire chart area
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: Column(
                  children: [
                    Expanded(
                      child: BarChart(
                        BarChartData(
                          minY: 0,
                          maxY: 100,
                          alignment: BarChartAlignment.spaceAround,
                          barGroups: const [], // Remove the grey placeholder bar
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 20,
                            getDrawingHorizontalLine: (value) {
                              return const FlLine(
                                color: Colors.black12,
                                strokeWidth: 1,
                              );
                            },
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  if (value % 20 == 0) {
                                    final text = '${value.toInt()}%';
                                    if (value == 0) {
                                      return Transform.translate(
                                        offset: const Offset(0, 10),
                                        child: Text(
                                          text,
                                          style: const TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                      );
                                    }
                                    return Text(
                                      text,
                                      style: const TextStyle(
                                        fontSize: 10,
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border(
                              left: BorderSide(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey.shade600
                                    : Colors.grey.shade600,
                                width: 1,
                              ), // Restore Y-axis line
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 78,
                    ), // Spacer to align with bottom labels
                  ],
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final chartWidth = constraints.maxWidth > chartDataPoints.length * 50.0
                        ? constraints.maxWidth
                        : chartDataPoints.length * 50.0;

                    return SizedBox(
                      height: constraints.maxHeight,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: chartWidth,
                          child: Column(
                            children: [
                              Expanded(
                                child: BarChart(
                                  BarChartData(
                                    minY: 0,
                                    maxY: 100,
                                    alignment: BarChartAlignment.spaceAround,
                                    barGroups: barGroups,
                                    barTouchData: BarTouchData(
                                      touchCallback: (FlTouchEvent event, BarTouchResponse? response) {
                                        // No action for guest mode
                                      },
                                    ),
                                    borderData: FlBorderData(
                                      show: true,
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.grey.shade600
                                              : Colors.grey.shade600,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    gridData: FlGridData(
                                      show: true,
                                      drawVerticalLine: false,
                                      horizontalInterval: 20,
                                      getDrawingHorizontalLine: (value) {
                                        return FlLine(
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.grey.shade600
                                              : Colors.grey.shade600,
                                          strokeWidth: 1,
                                        );
                                      },
                                    ),
                                    titlesData: const FlTitlesData(
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),
                                      rightTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),
                                      topTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 70,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    taskLabels.length,
                                    (index) {
                                      return SizedBox(
                                        width: 50,
                                        child: Column(
                                          children: [
                                            ClipOval(
                                              child: Image.network(
                                                avatarUrls[index],
                                                width: 32,
                                                height: 32,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return SvgPicture.asset(
                                                    'assets/images/defualt_avatar.svg',
                                                    width: 32,
                                                    height: 32,
                                                    fit: BoxFit.cover,
                                                  );
                                                },
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              taskLabels[index],
                                              style: const TextStyle(
                                                fontSize: 10,
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}