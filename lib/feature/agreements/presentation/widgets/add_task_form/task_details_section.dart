import 'package:flutter/material.dart';
import 'package:moazez/core/utils/validation/validators.dart';
import 'package:moazez/feature/agreements/presentation/widgets/custom_task_text_field.dart';

class TaskDetailsSection extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  const TaskDetailsSection({
    super.key,
    required this.titleController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTaskTextField(
          controller: titleController,
          labelText: 'عنوان المهمة',
          prefixIcon: Icons.title,
          validator: AppValidators.validateTitle,
        ),
        const SizedBox(height: 16),
        CustomTaskTextField(
          controller: descriptionController,
          labelText: 'وصف المهمة',
          prefixIcon: Icons.description,
          maxLines: 3,
          validator: AppValidators.validateDescription,
        ),
      ],
    );
  }
}
