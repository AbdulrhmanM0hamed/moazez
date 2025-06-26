import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/member_stats_cubit.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/member_stats_state.dart';

class ProgressChart extends StatelessWidget {
  const ProgressChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          280, // Adjusted height to accommodate the chart, labels, and avatars
      padding: const EdgeInsets.all(16.0),
      child: BlocBuilder<MemberStatsCubit, MemberStatsState>(
        builder: (context, state) {
          if (state is MemberStatsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MemberStatsLoaded) {
            final members = state.response.members;
            if (members.isEmpty) {
              return const Center(child: Text('لا يوجد بيانات للمشاركين'));
            }

            // Prepare data for the chart - Treat each task as a separate group for precise alignment
            List<BarChartGroupData> barGroups = [];
            List<String> taskLabels = [];
            List<String> avatarUrls = [];
            int taskIndex = 0;

            for (var member in members) {
              for (var task in member.tasks) {
                final percent = task.progress / 100.0;
                barGroups.add(
                  BarChartGroupData(
                    x: taskIndex,
                    barRods: [
                      BarChartRodData(
                        toY: percent * 100, // Scale to 0-100 for display
                        color: percent == 0 ? Colors.red : null, // Highlight 0 progress with red color
                        gradient: percent != 0 ? const LinearGradient(
                          colors: [Color(0xFF0DD0F4), Color(0xFF006E82)],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ) : null,
                        width: 12,
                        borderRadius: BorderRadius.circular(4),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY:
                              0, // Ensure bars with 0 progress are visible at the zero line
                          color: Colors.transparent,
                        ),
                        rodStackItems:
                            percent == 0
                                ? [
                                  BarChartRodStackItem(
                                    -2,
                                    2,
                                    Colors.red, // Add a more noticeable red dot at the base for 0 progress
                                  ),
                                ]
                                : [],
                      ),
                    ],
                    showingTooltipIndicators: [],
                  ),
                );
                taskLabels.add('${member.name} - ${task.title}');
                avatarUrls.add(member.avatarUrl);
                taskIndex++;
              }
            }

            return Directionality(
              textDirection: TextDirection.ltr,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width:
                      barGroups.length *
                      45.0, // Approximate width per bar group
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceEvenly,
                      groupsSpace: 20, // Spacing between task bars
                      maxY: 100, // Keep maxY at 100
                      borderData: FlBorderData(
                        show: false,
                      ), // Remove outer border of the chart
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          tooltipPadding: const EdgeInsets.all(8),
                          tooltipMargin: 8,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              '${taskLabels[group.x]}\n${rod.toY.toStringAsFixed(1)}%',
                              const TextStyle(color: Colors.white),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              int index = value.toInt();
                              if (index >= 0 && index < taskLabels.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          avatarUrls[index],
                                          width: 24,
                                          height: 24,
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Image.asset(
                                              'assets/images/avatar.jpg',
                                              width: 24,
                                              height: 24,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                    
                                      SizedBox(
                                        width: 50,
                                        child: Text(
                                          taskLabels[index].split(
                                            ' - ',
                                          )[0], // Show only member name
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                            reservedSize:
                                70, // Increased space for avatar and text
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  '${value.toInt()}%',
                                  style: const TextStyle(fontSize: 10),
                                  textAlign: TextAlign.right,
                                ),
                              );
                            },
                            interval: 20,
                            reservedSize: 100, // Further increase reserved space for y-axis labels to ensure 100% is fully visible
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        checkToShowHorizontalLine: (value) => value % 20 == 0,
                        horizontalInterval: 20,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.withValues(alpha: 0.2),
                            strokeWidth: 1,
                          );
                        },
                        drawVerticalLine: false,
                      ),
                      barGroups: barGroups,
                    ),
                  ),
                ),
              ),
            );
          } else if (state is MemberStatsError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('يرجى تحميل البيانات'));
          }
        },
      ),
    );
  }
}
