import 'package:flutter/material.dart';
import 'package:moazez/core/utils/validation/validators.dart';
import 'package:moazez/feature/agreements/presentation/widgets/custom_task_text_field.dart';

class DateDurationSection extends StatelessWidget {
  final TextEditingController startDateController;
  final TextEditingController durationController;
  final TextEditingController endDateController;
  final Function() onStartDateSelected;

  const DateDurationSection({
    super.key,
    required this.startDateController,
    required this.durationController,
    required this.endDateController,
    required this.onStartDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTaskTextField(
                controller: startDateController,
                labelText: 'تاريخ البدء',
                readOnly: true,
                onTap: onStartDateSelected,
                prefixIcon: Icons.calendar_today,
                validator: AppValidators.validateRequired,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTaskTextField(
                controller: durationController,
                labelText: 'المدة (أيام)',
                keyboardType: TextInputType.number,
                prefixIcon: Icons.timelapse,
                validator: AppValidators.validateDuration,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomTaskTextField(
          controller: endDateController,
          labelText: 'تاريخ الانتهاء',
          readOnly: true,
          prefixIcon: Icons.event_available,
        ),
      ],
    );
  }
}
