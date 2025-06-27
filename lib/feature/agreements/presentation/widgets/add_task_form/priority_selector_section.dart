import 'package:flutter/material.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';

class PrioritySelectorSection extends StatelessWidget {
  final String priority;
  final Function(String) onPriorityChanged;

  const PrioritySelectorSection({
    super.key,
    required this.priority,
    required this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'الأولوية',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'normal', label: Text('عادية')),
            ButtonSegment(value: 'Urgent', label: Text('عاجلة')),
          ],
          selected: {priority},
          onSelectionChanged: (newSelection) {
            onPriorityChanged(newSelection.first);
          },
          style: SegmentedButton.styleFrom(
            selectedBackgroundColor: AppColors.primary.withValues(alpha: 0.2),
            side: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ],
    );
  }
}
