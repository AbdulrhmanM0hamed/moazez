import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/feature/agreements/presentation/widgets/member_task_card.dart';
import 'package:moazez/feature/agreements/presentation/widgets/member_task_card_shimmer.dart';
import 'package:moazez/feature/home_supporter/domain/entities/member_stats_entity.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/member_stats_cubit.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/member_stats_state.dart';
import 'package:moazez/feature/agreements/presentation/widgets/agreement_filter_tabs.dart';
import 'package:moazez/feature/home_supporter/presentation/widgets/home_top_section.dart';

class AgreementsViewBody extends StatefulWidget {
  const AgreementsViewBody({super.key});

  @override
  State<AgreementsViewBody> createState() => _AgreementsViewBodyState();
}

class _AgreementsViewBodyState extends State<AgreementsViewBody> {
  int _selectedFilterIndex = 0;

  List<_TaskWithMemberInfo> _getFilteredTasks(List<_TaskWithMemberInfo> allTasks) {
    if (_selectedFilterIndex == 0) return allTasks; // ALL

    return allTasks.where((taskWithInfo) {
      final status = taskWithInfo.task.status;
      switch (_selectedFilterIndex) {
        case 1: // Completed
          return status == 'completed';
        case 2: // In Progress
          return status == 'in_progress';
        case 3: // Not Started
          return status == 'pending';
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HomeTopSection(),
        const SizedBox(height: 24),
        AgreementFilterTabs(
          selectedIndex: _selectedFilterIndex,
          onTabSelected: (index) {
            setState(() {
              _selectedFilterIndex = index;
            });
          },
        ),
        const SizedBox(height: 16),
        Expanded(
          child: BlocBuilder<MemberStatsCubit, MemberStatsState>(
            builder: (context, state) {
              if (state is MemberStatsLoading) {
                return const ShimmerTaskList();
              }

              if (state is MemberStatsError) {
                return Center(child: Text(state.message));
              }

              if (state is MemberStatsLoaded) {
                final allTasks = state.response.members
                    .expand(
                      (member) => member.tasks.map(
                        (task) => _TaskWithMemberInfo(
                          task: task,
                          member: member,
                        ),
                      ),
                    )
                    .toList();

                // Sort tasks by creation date (newest first)
                allTasks.sort((a, b) {
                  try {
                    // Handle empty or null dates gracefully
                    if (a.task.createdAt.isEmpty && b.task.createdAt.isEmpty) return 0;
                    if (a.task.createdAt.isEmpty) return 1; // Treat empty dates as older
                    if (b.task.createdAt.isEmpty) return -1; // Treat empty dates as older

                    final dateA = DateTime.parse(a.task.createdAt);
                    final dateB = DateTime.parse(b.task.createdAt);
                    return dateB.compareTo(dateA);
                  } catch (e) {
                    // Fallback for malformed date strings
                    return 0;
                  }
                });

                final filteredTasks = _getFilteredTasks(allTasks);

                if (filteredTasks.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/tasks_empty.svg',
                        height: 200,
                        width: 200,
                      ),
                      Text(
                        'لا توجد مهام ',
                        style: getMediumStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final taskWithInfo = filteredTasks[index];
                    return MemberTaskCard(
                      task: taskWithInfo.task,
                      member: taskWithInfo.member,
                    );
                  },
                );
              }

              return const ShimmerTaskList();
            },
          ),
        ),
      ],
    );
  }
}

class _TaskWithMemberInfo {
  final TaskEntity task;
  final MemberStatsEntity member;

  _TaskWithMemberInfo({required this.task, required this.member});
}
