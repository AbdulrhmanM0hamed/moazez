import 'package:flutter/material.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';

class AgreementFilterTabs extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const AgreementFilterTabs({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  final _tabs = const ['الكل', 'مكتمل', 'قيد التنفيذ', 'لم يبدأ'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_tabs.length, (index) {
          return _buildTab(context, _tabs[index], index);
        }),
      ),
    );
  }

  Widget _buildTab(BuildContext context, String text, int index) {
    final isSelected = selectedIndex == index;
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? theme.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border:
                isSelected
                    ? null
                    : Border.all(color: AppColors.primary, ),
          ),
          child: Center(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color:
                    isSelected
                        ? Colors.white
                        : theme.textTheme.bodyLarge?.color?.withValues(
                          alpha: 0.7,
                        ),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
