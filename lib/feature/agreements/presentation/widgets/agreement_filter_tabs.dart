import 'package:flutter/material.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';

class AgreementFilterTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const AgreementFilterTabs({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(child: _buildTab(context, "الاتفاقيات الحالية", 0)),
          const SizedBox(width: 12),
          Expanded(child: _buildTab(context, "الاتفاقيات السابقة", 1)),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, String text, int index) {
    final bool isSelected = selectedIndex == index;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => onTabSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryColor : theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? null : Border.all(color: theme.primaryColor, width: 1.5),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Center(
          child: Text(
            text,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size14,
              color: isSelected ? Colors.white : theme.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
