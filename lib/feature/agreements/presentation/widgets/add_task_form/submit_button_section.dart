import 'package:flutter/material.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';

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
    return ElevatedButton(
      onPressed: isLoading ? null : onSubmit,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
      ),
      child: isLoading
          ? const CustomProgressIndcator(size: 25, color: Colors.white)
          : const Text('إنشاء المهمة'),
    );
  }
}
