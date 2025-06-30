import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moazez/feature/MyTasks/domain/entities/my_task_entity.dart';
import 'package:moazez/feature/MyTasks/presentation/widgets/gradient_progress_indicator.dart';
import 'package:moazez/feature/MyTasks/presentation/widgets/stages_indicator.dart';
import 'package:moazez/feature/task_details/presentation/view/task_details_view.dart';

class MyTaskCard extends StatelessWidget {
  final MyTaskEntity task;

  const MyTaskCard({super.key, required this.task});

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

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final createdDateStr = _formatDate(task.createdAt);
    final dueDateStr = _formatDate(task.dueDate);
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
              // Header: Title, Date
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
                        if (dateRange.isNotEmpty)
                          Text(
                            dateRange,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                      ],
                    ),
                  ),
                  _TaskStatusBadge(status: task.status),
                ],
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
              if (task.stagesCount > 0) ...[
                const SizedBox(height: 16),
                // Stages
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'المراحل',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    StagesIndicator(
                      totalStages: task.stagesCount,
                      completedStages: task.completedStages,
                    ),
                  ],
                ),
              ],
              const Divider(height: 32),
              // Creator Info
              Row(
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: task.creator.avatarUrl ?? '',
                        placeholder: (context, url) => SvgPicture.asset(
                          'assets/images/defualt_avatar.svg',
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) => SvgPicture.asset(
                          'assets/images/defualt_avatar.svg',
                          fit: BoxFit.cover,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'بواسطة',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          task.creator.name,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
    final Map<String, dynamic> statusInfo = {
      'not_started': {'text': 'لم تبدأ', 'color': Colors.grey},
      'in_progress': {'text': 'قيد التنفيذ', 'color': Colors.blue},
      'completed': {'text': 'مكتملة', 'color': Colors.green},
      'pending': {'text': 'معلقة', 'color': Colors.orange},
    };

    final info = statusInfo[status] ?? {'text': status, 'color': Colors.grey};

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: info['color'].withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        info['text'],
        style: TextStyle(
          color: info['color'],
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
