import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/core/widgets/empty_view.dart';
import 'package:moazez/feature/MyTasks/domain/entities/my_task_entity.dart';
import 'package:moazez/feature/MyTasks/presentation/cubit/my_tasks_cubit.dart';
import 'package:moazez/feature/MyTasks/presentation/cubit/my_tasks_state.dart';
import 'package:moazez/feature/home_participant/presentation/widgets/current_tasks_card.dart';
import 'package:moazez/feature/home_participant/presentation/widgets/task_summary_card.dart';
import 'package:moazez/feature/home_supporter/presentation/widgets/home_top_section.dart';

class HomeParticipantsViewBody extends StatelessWidget {
  const HomeParticipantsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MyTasksCubit>()..getMyTasks(),
      child: BlocBuilder<MyTasksCubit, MyTasksState>(
        builder: (context, state) {
          if (state is MyTasksLoading) {
            return Center(child: CustomProgressIndcator());
          }
          if (state is MyTasksError) {
            return Center(child: Text(state.message));
          }
          if (state is MyTasksLoaded) {
            return _buildContent(context, state.tasks);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<MyTaskEntity> tasks) {
    final completedCount = tasks.where((t) => t.status == 'completed').length;
    final currentTasks = tasks.where((t) => t.status != 'completed').toList();
    final pendingCount = currentTasks.length;

    final statusMap = {
      'pending': 'معلقة',
      'in_progress': 'قيد التنفيذ',
      'completed': 'مكتملة',
      'not_started': 'لم تبدأ',
    };

    return RefreshIndicator(
      onRefresh: () async {
        context.read<MyTasksCubit>().getMyTasks();
      },
      child: Column(
        children: [
          HomeTopSection(),
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TaskSummaryCard(
                      completedTasks: completedCount,
                      pendingTasks: pendingCount,
                    ),
                    const SizedBox(height: 24),
                    if (tasks.isEmpty)
                      const EmptyView(
                        imagePath: 'assets/images/tasksEmpty.png',
                        message: 'لا توجد مهام حالياً',
                        imageWidth: 350,
                      )
                    else if (currentTasks.isEmpty)
                      const EmptyView(
                        imagePath: 'assets/images/tasksEmpty.png',
                        message: 'لا توجد مهام حالية. عمل رائع!',
                        imageWidth: 350,
                      )
                    else ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Text(
                          'المهام الحالية',
                          style: getBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size16,
                            color: AppColors.primary,
                          ),
                        ),
                      ),

                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: currentTasks.length,
                        itemBuilder: (context, index) {
                          final task = currentTasks[index];
                          return CurrentTasksCard(
                            taskId: task.id,
                            status: statusMap[task.status] ?? task.status,
                            title: task.title,
                            progress: task.progress.toDouble(),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
