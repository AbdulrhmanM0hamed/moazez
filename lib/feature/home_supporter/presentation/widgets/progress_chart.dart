
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/member_stats_cubit.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/member_stats_state.dart';

class ProgressChart extends StatelessWidget {
  const ProgressChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<MemberStatsCubit, MemberStatsState>(
        builder: (context, state) {
          if (state is MemberStatsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MemberStatsLoaded) {
            final members = state.response.members;

            if (members.isEmpty) {
              return const Center(child: Text('لا يوجد بيانات للمشاركين'));
            }

            // Preparing chart data
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
                        toY: percent * 100, // Scale to 0-100
                        fromY: 0, // Explicitly start from 0 to avoid any offset
                        gradient: percent > 0
                            ? const LinearGradient(
                                colors: [Color(0xFF0DD0F4), Color(0xFF006E82)],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              )
                            : null,
                        color: percent == 0 ? Colors.red : null,
                        width: 12,
                        borderRadius: percent > 0
                            ? const BorderRadius.all(Radius.circular(4))
                            : BorderRadius.zero,
                        backDrawRodData: BackgroundBarChartRodData(
                          show: false, // Disable background to avoid any offset
                          toY: 0,
                          color: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                );

                taskLabels.add(member.name);
                avatarUrls.add(member.avatarUrl);
                taskIndex++;
              }
            }

            return Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Fixed Y-axis
                  SizedBox(
                    width: 60,
                    child: Column(
                      children: [
                        Expanded(
                          child: BarChart(
                            BarChartData(
                              minY: 0,
                              maxY: 100,
                              titlesData: FlTitlesData(
                                show: true,
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: (value, meta) {
                                      if (value % 20 != 0) {
                                        return const SizedBox.shrink();
                                      }
                                      return Text('${value.toInt()}%', style: const TextStyle(fontSize: 10));
                                    },
                                    interval: 20,
                                  ),
                                ),
                                bottomTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              gridData: FlGridData(
                                show: true,
                                horizontalInterval: 20,
                                drawVerticalLine: false,
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: Colors.grey.withOpacity(0.2),
                                    strokeWidth: 1,
                                  );
                                },
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: const Border(
                                  left: BorderSide(color: Colors.black, width: 1),
                                  bottom: BorderSide(color: Colors.black, width: 1),
                                ),
                              ),
                              barGroups: [],
                            ),
                          ),
                        ),
                        // This SizedBox is a placeholder to align with the bottom labels section of the scrollable chart
                        const SizedBox(height: 78),
                      ],
                    ),
                  ),

                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: barGroups.length * 60.0,
                            height: constraints.maxHeight,
                            child: Column(
                              children: [
                                Expanded(
                                  child: BarChart(
                                    BarChartData(
                                      minY: 0,
                                      maxY: 100,
                                      alignment: BarChartAlignment.spaceAround,
                                      barGroups: barGroups,
                                      borderData: FlBorderData(
                                        show: true,
                                        border: const Border(
                                          bottom: BorderSide(color: Colors.black, width: 1),
                                        ),
                                      ),
                                      gridData: FlGridData(
                                        show: true,
                                        horizontalInterval: 20,
                                        drawVerticalLine: false,
                                        getDrawingHorizontalLine: (value) {
                                          return FlLine(
                                            color: Colors.grey.withOpacity(0.2),
                                            strokeWidth: 1,
                                          );
                                        },
                                      ),
                                      titlesData: const FlTitlesData(
                                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  height: 70,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: List.generate(taskLabels.length, (index) {
                                      return SizedBox(
                                        width: 60,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            ClipOval(
                                              child: Image.network(
                                                avatarUrls[index],
                                                width: 32,
                                                height: 32,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Image.asset(
                                                    'assets/images/avatar.jpg',
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
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
