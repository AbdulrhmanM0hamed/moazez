import 'package:flutter/material.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/feature/search/domain/entities/search_task_entity.dart';
import 'package:moazez/feature/task_details/presentation/view/task_details_view.dart';

class SearchTaskCard extends StatelessWidget {
  final SearchTaskEntity task;

  const SearchTaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailsView(taskId: task.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(task.creator.avatarUrl),
              backgroundColor: Colors.grey.shade200,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size16,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'بواسطة: ${task.creator.name}',
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size14,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
