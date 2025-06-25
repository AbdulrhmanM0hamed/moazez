import 'package:flutter/material.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';

enum AccountType { supporter, participant }

class AccountTypeSwitcher extends StatefulWidget {
  const AccountTypeSwitcher({super.key});

  @override
  State<AccountTypeSwitcher> createState() => _AccountTypeSwitcherState();
}

class _AccountTypeSwitcherState extends State<AccountTypeSwitcher> {
  AccountType _selectedType = AccountType.supporter;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
      
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSwitchItem(AccountType.supporter, 'داعم'),
          _buildSwitchItem(AccountType.participant, 'مشارك'),
        ],
      ),
    );
  }

  Widget _buildSwitchItem(AccountType type, String text) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: getRegularStyle(
            color: isSelected ? Colors.white : AppColors.primary,
            fontSize: 12,
            fontFamily: FontConstant.cairo,
          ),
        ),
      ),
    );
  }
}
