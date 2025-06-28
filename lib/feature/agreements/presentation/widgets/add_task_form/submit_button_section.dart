import 'package:flutter/material.dart';
import 'package:moazez/core/utils/common/custom_button.dart';

class SubmitButtonSection extends StatelessWidget {
  final bool isLoading;
  final Function() onSubmit;

  const SubmitButtonSection({
    super.key,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: isLoading ? null : onSubmit,
      text: 'إنشاء المهمة',
    );
  }
}
