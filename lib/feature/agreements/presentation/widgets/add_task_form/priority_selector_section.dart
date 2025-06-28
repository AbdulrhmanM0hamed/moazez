import 'package:flutter/material.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
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
    const priorities = {
      'low': 'منخفضة',
      'normal': 'عادية',
      'medium': 'متوسطة',
      'high': 'عالية',
      'urgent': 'عاجلة',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الأولوية',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children:
              priorities.entries.map((entry) {
                return ChoiceChip(
                  label: Text(
                    entry.value,
                    style: getMediumStyle(fontFamily: FontConstant.cairo),
                  ),
                  selected: priority == entry.key,
                  onSelected: (isSelected) {
                    if (isSelected) {
                      onPriorityChanged(entry.key);
                    }
                  },
                  selectedColor: AppColors.primary.withValues(alpha: 0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
