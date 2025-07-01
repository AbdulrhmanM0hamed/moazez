import 'package:flutter/material.dart';

class StagesIndicator extends StatelessWidget {
  final int totalStages;
  final int completedStages;
  const StagesIndicator({
    super.key,
    required this.totalStages,
    required this.completedStages,
  });

  @override
  Widget build(BuildContext context) {
    if (totalStages == 0) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    return Row(
      children: List.generate(totalStages, (index) {
        final isCompleted = index < completedStages;
        return Expanded(
          child: Container(
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              gradient: isCompleted
                  ? const LinearGradient(
                      colors: [Color(0xFF0DD0F4), Color(0xFF006E82)],
                    )
                  : null,
              color: isCompleted ? null : theme.dividerColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}
