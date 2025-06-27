import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moazez/core/utils/common/custom_button.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/core/utils/validation/validators.dart';
import 'package:moazez/feature/agreements/presentation/widgets/custom_task_text_field.dart';

class AddTaskForm extends StatefulWidget {
  const AddTaskForm({super.key});

  @override
  State<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startDateController = TextEditingController();
  final _durationController = TextEditingController();
  final _endDateController = TextEditingController();
  final _rewardAmountController = TextEditingController();
  final _rewardDescriptionController = TextEditingController();

  String _priority = 'normal';
  String _rewardType = 'cash';
  int _totalStages = 1;

  @override
  void initState() {
    super.initState();
    _startDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _durationController.addListener(_updateEndDate);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _durationController.dispose();
    _endDateController.dispose();
    _rewardAmountController.dispose();
    _rewardDescriptionController.dispose();
    super.dispose();
  }

  void _updateEndDate() {
    if (_startDateController.text.isNotEmpty &&
        _durationController.text.isNotEmpty) {
      final startDate = DateTime.parse(_startDateController.text);
      final duration = int.tryParse(_durationController.text) ?? 0;
      final endDate = startDate.add(Duration(days: duration));
      _endDateController.text = DateFormat('yyyy-MM-dd').format(endDate);
    }
  }

  Future<void> _selectStartDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _startDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        _updateEndDate();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTaskTextField(
              controller: _titleController,
              labelText: 'عنوان المهمة',
              prefixIcon: Icons.title,
              validator: AppValidators.validateTitle,
            ),
            const SizedBox(height: 16),
            CustomTaskTextField(
              controller: _descriptionController,
              labelText: 'وصف المهمة',
              maxLines: 3,
              prefixIcon: Icons.description,
              validator: AppValidators.validateDescription,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomTaskTextField(
                    controller: _startDateController,
                    labelText: 'تاريخ البدء',
                    readOnly: true,
                    onTap: _selectStartDate,
                    prefixIcon: Icons.calendar_today,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTaskTextField(
                    controller: _durationController,
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
              controller: _endDateController,
              labelText: 'تاريخ الانتهاء ',
              readOnly: true,
              prefixIcon: Icons.event_available,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'المراحل',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 25,
                      height: 25,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_totalStages > 1) {
                            setState(() {
                              _totalStages--;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: EdgeInsets.zero,
                          backgroundColor: AppColors.primary,
                        ),
                        child: const Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '$_totalStages',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 25,
                      height: 25,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _totalStages++;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: EdgeInsets.zero,
                          backgroundColor: AppColors.primary,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'الأولوية',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildPrioritySelector(),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'نوع المكافأة',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildRewardTypeSelector(),
              ],
            ),
            const SizedBox(height: 16),
            if (_rewardType == 'cash')
              CustomTaskTextField(
                controller: _rewardAmountController,
                labelText: 'قيمة المكافأة',
                keyboardType: TextInputType.number,
                prefixIcon: Icons.attach_money,
                validator: AppValidators.validateRewardAmount,
              )
            else
              CustomTaskTextField(
                controller: _rewardDescriptionController,
                labelText: 'وصف المكافأة',
                prefixIcon: Icons.card_giftcard,
                validator: AppValidators.validateRewardDescription,
              ),
            const SizedBox(height: 24),
            // Placeholder for member selection
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'اختيار المشاركين',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('اختر من فريقك'),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle form submission
                  }
                },
                text: 'إنشاء المهمة',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return SegmentedButton<String>(
      segments: const [
        ButtonSegment(value: 'normal', label: Text('عادية')),
        ButtonSegment(value: 'Urgent', label: Text('عاجلة')),
      ],
      selected: {_priority},
      onSelectionChanged: (newSelection) {
        setState(() {
          _priority = newSelection.first;
        });
      },
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: AppColors.primary.withValues(alpha: 0.2),
        side: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }

  Widget _buildRewardTypeSelector() {
    return SegmentedButton<String>(
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: AppColors.primary.withValues(alpha: 0.2),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      segments: const [
        ButtonSegment(value: 'cash', label: Text('مبلغ مالي')),
        ButtonSegment(value: 'other', label: Text('أخرى')),
      ],
      selected: {_rewardType},
      onSelectionChanged: (newSelection) {
        setState(() {
          _rewardType = newSelection.first;
        });
      },
    );
  }
}
