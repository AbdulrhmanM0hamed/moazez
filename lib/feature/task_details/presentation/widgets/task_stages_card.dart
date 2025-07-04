import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/services/service_locator.dart';

import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/task_details/domain/entities/task_details_entity.dart';
import 'package:moazez/feature/task_details/presentation/cubit/stage_completion_cubit.dart';
import 'package:moazez/feature/task_details/presentation/cubit/task_details_cubit.dart';
import 'package:moazez/feature/task_details/presentation/widgets/status_chip_ar.dart';
import 'package:moazez/feature/task_details/presentation/widgets/stage_completion_dialog.dart';
import 'package:moazez/feature/task_details/presentation/view/stage_details_screen.dart';

class TaskStagesCard extends StatelessWidget {
  final List<StageEntity> stages;
  const TaskStagesCard({super.key, required this.stages});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (stages.isEmpty) {
      return const SizedBox.shrink();
    }
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Text(
          'مراحل الهدف (${stages.length})',
          style: getBoldStyle(
            color: theme.primaryColor,
            fontSize: 18,
            fontFamily: FontConstant.cairo,
          ),
        ),
        children: stages.map((stage) {
          final statusColor =
              StatusChipAr.statusColor[stage.status.toLowerCase()] ??
              Colors.grey;
          final IconData statusIcon;
          switch (stage.status.toLowerCase()) {
            case 'completed':
              statusIcon = Icons.check_circle_outline;
              break;
            case 'in_progress':
              statusIcon = Icons.hourglass_top_outlined;
              break;
            case 'pending':
              statusIcon = Icons.pending_outlined;
              break;
            default:
              statusIcon = Icons.help_outline;
          }
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: statusColor.withValues(alpha: 0.1),
              child: Icon(statusIcon, color: statusColor, size: 22),
            ),
            title: Text(
              stage.title,
              style: getSemiBoldStyle(
                color: AppColors.primary,
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
              ),
            ),
           
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                StatusChipAr(status: stage.status),
                if (stage.status.toLowerCase() != 'completed')
                   FutureBuilder<String?>(
                     future: sl<CacheService>().getUserRole(),
                     builder: (context, snapshot) {
                       if (snapshot.hasData && snapshot.data?.toLowerCase() != 'supporter') {
                         return PopupMenuButton<String>(
                           icon: const Icon(Icons.more_vert),
                           onSelected: (value) {
                             if (value == 'complete') {
                               showDialog(
                                 context: context,
                                 builder: (dialogContext) {
                                   return BlocProvider.value(
                                     value: BlocProvider.of<StageCompletionCubit>(context),
                                     child: StageCompletionDialog(
                                       parentContext: context,
                                       stageId: stage.id,
                                       stageTitle: stage.title,
                                       onComplete: () {
                                         context.read<TaskDetailsCubit>().fetchTaskDetails(stage.taskId);
                                       },
                                     ),
                                   );
                                 },
                               );
                             }
                           },
                           itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                             const PopupMenuItem<String>(
                               value: 'complete',
                               child: ListTile(
                                 leading: Icon(Icons.check_circle_outline, color: Colors.green),
                                 title: Text('إتمام المرحلة'),
                               ),
                             ),
                           ],
                         );
                       }
                       return const SizedBox.shrink();
                     },
                   ),
              ],
            ),
            onTap: () {
              if (stage.status.toLowerCase() == 'completed') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StageDetailsScreen(stage: stage),
                  ),
                );
              }
            },
          );
        }).toList(),
      ),
    );
  }
}
