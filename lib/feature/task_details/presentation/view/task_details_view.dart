import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';
import 'package:moazez/core/utils/common/custom_app_bar.dart';
import 'package:moazez/feature/task_details/domain/entities/task_details_entity.dart';
import 'package:moazez/feature/task_details/presentation/cubit/task_details_cubit.dart';
import 'package:moazez/feature/task_details/presentation/cubit/task_details_state.dart';
import 'package:moazez/core/services/service_locator.dart' as di;
import 'package:moazez/feature/task_details/presentation/widgets/task_details_info_card.dart';
import 'package:moazez/feature/task_details/presentation/widgets/task_header_card.dart';
import 'package:moazez/feature/task_details/presentation/widgets/task_progress_card.dart';
import 'package:moazez/feature/task_details/presentation/widgets/task_reward_card.dart';
import 'package:moazez/feature/task_details/presentation/widgets/task_stages_card.dart';

class TaskDetailsView extends StatelessWidget {
  final int taskId;

  const TaskDetailsView({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<TaskDetailsCubit>()..fetchTaskDetails(taskId),
      child: Scaffold(
        appBar: CustomAppBar(title: 'تفاصيل المهمة'),
        body: BlocBuilder<TaskDetailsCubit, TaskDetailsState>(
          builder: (context, state) {
            if (state is TaskDetailsLoading) {
              return const Center(child: CustomProgressIndcator());
            } else if (state is TaskDetailsLoaded) {
              return _TaskDetailsContent(taskDetails: state.taskDetails);
            } else if (state is TaskDetailsError) {
              return Center(child: Text('حدث خطأ: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _TaskDetailsContent extends StatelessWidget {
  final TaskDetailsEntity taskDetails;

  const _TaskDetailsContent({required this.taskDetails});

  @override
  Widget build(BuildContext context) {
    final bool hasAmount =
        taskDetails.rewardAmount != null &&
        taskDetails.rewardAmount!.isNotEmpty;
    final bool hasDescription =
        taskDetails.rewardDescription != null &&
        taskDetails.rewardDescription!.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TaskHeaderCard(taskDetails: taskDetails),
          const SizedBox(height: 16),
          TaskProgressCard(progress: taskDetails.progress),
          const SizedBox(height: 16),
          TaskDetailsInfoCard(taskDetails: taskDetails),
          const SizedBox(height: 16),
          TaskStagesCard(stages: taskDetails.stages),
          if (hasAmount || hasDescription)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TaskRewardCard(taskDetails: taskDetails),
            ),
        ],
      ),
    );
  }
}
