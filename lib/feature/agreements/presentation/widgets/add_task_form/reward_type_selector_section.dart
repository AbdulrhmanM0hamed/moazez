import 'package:flutter/material.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';

class RewardTypeSelectorSection extends StatelessWidget {
  final String rewardType;
  final Function(String) onRewardTypeChanged;

  const RewardTypeSelectorSection({
    super.key,
    required this.rewardType,
    required this.onRewardTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'نوع المكافأة',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SegmentedButton<String>(
          style: SegmentedButton.styleFrom(
            selectedBackgroundColor: AppColors.primary.withValues(alpha: 0.2),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          segments: const [
            ButtonSegment(value: 'cash', label: Text('مبلغ مالي')),
            ButtonSegment(value: 'other', label: Text('أخرى')),
          ],
          selected: {rewardType},
          onSelectionChanged: (newSelection) {
            onRewardTypeChanged(newSelection.first);
          },
        ),
      ],
    );
  }
}
