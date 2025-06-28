import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/feature/agreements/presentation/cubit/close_task_cubit.dart';
import 'package:moazez/feature/agreements/presentation/widgets/gradient_progress_indicator.dart';
import 'package:moazez/feature/agreements/presentation/widgets/stages_indicator.dart';
import 'package:moazez/core/utils/common/custom_dialog_button.dart';
import 'package:moazez/feature/agreements/presentation/view/task_details_view.dart';
import 'package:moazez/feature/home_supporter/domain/entities/member_stats_entity.dart';

class MemberTaskCard extends StatelessWidget {
  final TaskEntity task;
  final MemberStatsEntity member;

  const MemberTaskCard({super.key, required this.task, required this.member});

  bool _isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    Uri? uri;
    try {
      uri = Uri.parse(url);
    } catch (e) {
      return false;
    }
    return uri.isScheme('HTTP') || uri.isScheme('HTTPS');
  }


  void _showConfirmationDialog(BuildContext context, String taskId, String status) {
    final statusText = status == 'completed' ? 'مكتمل' : 'غير مكتمل';

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('تأكيد تحديث الحالة', style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
          content: Text(
            'هل أنت متأكد من تحديث حالة المهمة إلى "$statusText"؟',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: CustomDialogButton(
                    text: 'إلغاء',
                    onPressed: () => Navigator.of(dialogContext).pop(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomDialogButton(
                    text: 'تأكيد',
                    backgroundColor: const Color(0xFF28A745), // Success Green
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      context.read<CloseTaskCubit>().closeTask(
                            taskId: taskId,
                            status: status,
                          );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String formatDate(String dateStr) {
      if (dateStr.isEmpty) return '';
      try {
        final date = DateTime.parse(dateStr);
        return '${date.day}/${date.month}/${date.year}';
      } catch (e) {
        return '';
      }
    }

    final createdDateStr = formatDate(task.createdAt);
    final dueDateStr = formatDate(task.dueDate);
    String dateRange;

    if (createdDateStr.isNotEmpty && dueDateStr.isNotEmpty) {
      dateRange = '$createdDateStr - $dueDateStr';
    } else if (dueDateStr.isNotEmpty) {
      dateRange = 'تاريخ الاستحقاق: $dueDateStr';
    } else if (createdDateStr.isNotEmpty) {
      dateRange = 'تاريخ الإنشاء: $createdDateStr';
    } else {
      dateRange = '';
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailsView(taskId: task.id),
          ),
        );
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Title, Date, Menu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dateRange,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (task.status != 'completed')
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        _showConfirmationDialog(context, task.id.toString(), value);
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'completed',
                          child: Text('مكتمل'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'not_completed',
                          child: Text('غير مكتمل'),
                        ),
                      ],
                    )
                  else
                    // Reserve space to keep the layout consistent
                    const SizedBox(width: 48.0),
                ],
              ),
              const SizedBox(height: 12),
              // Status Badge
              Align(
                alignment: Alignment.centerRight,
                child: _TaskStatusBadge(status: task.status),
              ),
              const SizedBox(height: 16),
              // Progress
              _buildInfoRow(
                context,
                title: 'التقدم',
                value: '${task.progress}%',
                indicator: GradientProgressIndicator(
                  progress: task.progress / 100.0,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF006E82), Color(0xFF0DD0F4)],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Stages
              _buildInfoRow(
                context,
                title: 'المراحل',
                value: '${task.stagesCount} مراحل',
                indicator: StagesIndicator(
                  totalStages: task.stagesCount,
                  completedStages: task.completedStages,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              // Participant
              Row(
                children: [
                  Text(
                    'المشارك',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const Spacer(),
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: _isValidUrl(member.avatarUrl)
                        ? CachedNetworkImageProvider(member.avatarUrl)
                        : null,
                    child: !_isValidUrl(member.avatarUrl)
                        ? const Icon(Icons.person, size: 16)
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    member.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String title,
    required String value,
    required Widget indicator,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: theme.textTheme.bodyMedium),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        indicator,
      ],
    );
  }
}

class _TaskStatusBadge extends StatelessWidget {
  final String status;

  const _TaskStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    String text;
    Color backgroundColor;
    Color foregroundColor;
    IconData icon;

    switch (status) {
      case 'completed':
        text = 'مكتمل';
        backgroundColor = const Color(0xFFE4F8E9); // Light Green
        foregroundColor = const Color(0xFF28A745); // Dark Green
        icon = Icons.check_circle;
        break;
      case 'in_progress':
        text = 'قيد التنفيذ';
        backgroundColor = const Color(0xFFE0F7FA); // Light Blue
        foregroundColor = const Color(0xFF007BFF); // Dark Blue
        icon = Icons.play_circle_outline;
        break;
      case 'pending':
        text = 'معلق';
        backgroundColor = const Color(0xFFFFF3E0); // Light Orange
        foregroundColor = const Color(0xFFFD7E14); // Dark Orange
        icon = Icons.pause_circle_outline;
        break;
      default:
        text = status;
        backgroundColor = Colors.grey.shade200;
        foregroundColor = Colors.grey.shade800;
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: foregroundColor),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: foregroundColor,
            ),
          ),
        ],
      ),
    );
  }
}
