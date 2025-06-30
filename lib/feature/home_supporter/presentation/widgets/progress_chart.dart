
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moazez/feature/home_supporter/domain/entities/member_stats_entity.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/member_stats_cubit.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/member_stats_state.dart';
import 'package:moazez/feature/home_supporter/presentation/widgets/task_details_dialog.dart';
import 'dart:math';
import 'package:moazez/core/utils/animations/custom_animations.dart';

class _ChartDataPoint {
  final MemberStatsEntity member;
  final TaskEntity task;
  _ChartDataPoint(this.member, this.task);
}

class ProgressChart extends StatelessWidget {
  const ProgressChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemberStatsCubit, MemberStatsState>(
      builder: (context, state) {
        if (state is MemberStatsLoading) {
          return const SizedBox.shrink();
        }
        if (state is MemberStatsError) {
          return Center(child: Text(state.message));
        }
        if (state is MemberStatsLoaded) {
          final members = state.response.members;
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
                                            child: Text(text, style: const TextStyle(fontSize: 10)),
                                          );
                                        }
                                        return Text(text, style: const TextStyle(fontSize: 10));
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                ),
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),

                              borderData: FlBorderData(
                                show: true,
                                border: const Border(
                                  left: BorderSide(color: Colors.black, width: 1), // Restore Y-axis line
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 78), // Spacer to align with bottom labels
                      ],
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final chartWidth = max(constraints.maxWidth, chartDataPoints.length * 50.0);

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
                                            if (response == null || response.spot == null) {
                                              return;
                                            }
                                            if (event is FlTapUpEvent) {
                                              final index = response.spot!.touchedBarGroupIndex;
                                              if (index >= 0 && index < chartDataPoints.length) {
                                                final dataPoint = chartDataPoints[index];
                                                showDialog(
                                                  context: context,
                                                  builder: (_) => TaskDetailsDialog(
                                                    member: dataPoint.member,
                                                    task: dataPoint.task,
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                        ),
                                        borderData: FlBorderData(
                                          show: true,
                                          border: Border(
                                            bottom: BorderSide(color: Colors.black, width: 1),
                                          ),
                                        ),
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
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: List.generate(taskLabels.length, (index) {
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
                                                style: const TextStyle(fontSize: 10),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
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
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),);
        }
        // Return a widget for other states to avoid null return
        return const SizedBox.shrink();
      },
    );
  }


}
