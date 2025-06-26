import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/feature/agreements/presentation/widgets/member_task_card.dart';
import 'package:moazez/feature/agreements/presentation/widgets/member_task_card_shimmer.dart';
import 'package:moazez/feature/home_supporter/domain/entities/member_stats_entity.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/member_stats_cubit.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/member_stats_state.dart';
import 'package:moazez/feature/agreements/presentation/widgets/agreement_filter_tabs.dart';
import 'package:moazez/feature/home_supporter/presentation/widgets/home_top_section.dart';

class AgreementsViewBody extends StatelessWidget {
  const AgreementsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MemberStatsCubit>()..fetchMemberTaskStats(),
      child: const _AgreementsContent(),
    );
  }
}

class _AgreementsContent extends StatefulWidget {
  const _AgreementsContent();

  @override
  State<_AgreementsContent> createState() => _AgreementsContentState();
}

class _AgreementsContentState extends State<_AgreementsContent> {
  int _selectedFilterIndex = 0;
  List<_TaskWithMemberInfo> _tasks = [];

  List<_TaskWithMemberInfo> _getFilteredTasks() {
    if (_selectedFilterIndex == 0) return _tasks; // ALL

    return _tasks.where((taskWithInfo) {
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
          child: BlocConsumer<MemberStatsCubit, MemberStatsState>(
            listener: (context, state) {
              if (state is MemberStatsLoaded) {
                setState(() {
                  _tasks = state.response.members
                      .expand((member) => member.tasks
                          .map((task) => _TaskWithMemberInfo(task: task, member: member)))
                      .toList();
                });
              }
            },
            builder: (context, state) {
                            if (state is MemberStatsLoading && _tasks.isEmpty) {
                return const ShimmerTaskList();
              }

              if (state is MemberStatsError && _tasks.isEmpty) {
                return Center(child: Text(state.message));
              }

              final filteredTasks = _getFilteredTasks();

              if (filteredTasks.isEmpty) {
                return const Center(
                  child: Text('لا توجد مهام مطابقة لهذا الفلتر'),
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
