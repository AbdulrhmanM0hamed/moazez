import 'package:flutter/material.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';

class RoleSwitcher extends StatefulWidget {
  const RoleSwitcher({super.key});

  @override
  State<RoleSwitcher> createState() => _RoleSwitcherState();
}

class _RoleSwitcherState extends State<RoleSwitcher> {
  int _selectedRoleIndex = 0; // 0 for Participant, 1 for Supporter

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: ToggleButtons(
        isSelected: [_selectedRoleIndex == 0, _selectedRoleIndex == 1],
        onPressed: (index) {
          setState(() {
            _selectedRoleIndex = index;
          });
        },
        borderRadius: BorderRadius.circular(30),
        selectedColor: Colors.white,
        color: AppColors.textPrimary,
        fillColor: AppColors.primary,
        splashColor: AppColors.primary.withOpacity(0.12),
        hoverColor: AppColors.primary.withOpacity(0.04),
        renderBorder: false,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.person_outline, size: 20),
                SizedBox(width: 8),
                Text('مشارك', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.verified_user_outlined, size: 20),
                SizedBox(width: 8),
                Text('داعم', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
