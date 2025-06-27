import 'package:flutter/material.dart';
import 'package:moazez/core/utils/validation/validators.dart';
import 'package:moazez/feature/agreements/presentation/widgets/custom_task_text_field.dart';

class RewardDetailsSection extends StatelessWidget {
  final String rewardType;
  final TextEditingController rewardAmountController;
  final TextEditingController rewardDescriptionController;

  const RewardDetailsSection({
    super.key,
    required this.rewardType,
    required this.rewardAmountController,
    required this.rewardDescriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return rewardType == 'cash'
        ? CustomTaskTextField(
            controller: rewardAmountController,
            labelText: 'قيمة المكافأة',
            keyboardType: TextInputType.number,
            prefixIcon: Icons.attach_money,
            validator: AppValidators.validateRewardAmount,
          )
        : CustomTaskTextField(
            controller: rewardDescriptionController,
            labelText: 'وصف المكافأة',
            prefixIcon: Icons.card_giftcard,
            validator: AppValidators.validateRewardDescription,
          );
  }
}
