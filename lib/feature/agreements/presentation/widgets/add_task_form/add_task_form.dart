import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:moazez/core/utils/widgets/custom_snackbar.dart';
import 'package:moazez/feature/agreements/domain/entities/team_member.dart';
import 'package:moazez/feature/agreements/domain/entities/task.dart' as task_entity;
import 'package:moazez/feature/agreements/presentation/cubit/create_task_cubit.dart';
import 'package:moazez/feature/agreements/presentation/cubit/team_members_cubit.dart';
import 'package:moazez/feature/agreements/presentation/widgets/add_task_form/date_duration_section.dart';
import 'package:moazez/feature/agreements/presentation/widgets/add_task_form/member_selection_section.dart';
import 'package:moazez/feature/agreements/presentation/widgets/add_task_form/priority_selector_section.dart';
import 'package:moazez/feature/agreements/presentation/widgets/add_task_form/reward_details_section.dart';
import 'package:moazez/feature/agreements/presentation/widgets/add_task_form/reward_type_selector_section.dart';
import 'package:moazez/feature/agreements/presentation/widgets/add_task_form/stages_selector_section.dart';
import 'package:moazez/feature/agreements/presentation/widgets/add_task_form/submit_button_section.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';
import 'package:moazez/feature/agreements/presentation/widgets/add_task_form/task_details_section.dart';

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

  List<TeamMember> _selectedMembers = [];
  String _priority = 'normal';
  String _rewardType = 'cash';
  int _totalStages = 1;

  @override
  void initState() {
    super.initState();
    _durationController.addListener(_updateEndDate);
    context.read<TeamMembersCubit>().fetchTeamMembers();
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
      try {
        final startDate = DateTime.parse(_startDateController.text);
        final duration = int.parse(_durationController.text);
        final endDate = startDate.add(Duration(days: duration));
        _endDateController.text = DateFormat('yyyy-MM-dd').format(endDate);
      } catch (e) {
        _endDateController.clear();
      }
    }
  }

  void _selectStartDate() async {
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

  void _createTask(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (_selectedMembers.isEmpty) {
        CustomSnackbar.showError(
            context: context, message: 'الرجاء اختيار عضو واحد على الأقل');
        return;
      }

      final task = task_entity.Task(
        id: 0,
        title: _titleController.text,
        description: _descriptionController.text,
        startDate: _startDateController.text,
        durationDays: int.parse(_durationController.text),
        endDate: _endDateController.text,
        status: 'pending',
        priority: _priority,
        rewardType: _rewardType,
        rewardAmount: double.tryParse(_rewardAmountController.text),
        rewardDescription: _rewardDescriptionController.text,
        isMultiple: _selectedMembers.length > 1 ? 1 : 0,
        selectedMembers: _selectedMembers.map((e) => e.id).toList(),
        receiverId: _selectedMembers.isNotEmpty ? _selectedMembers.first.id : 0,
        totalStages: _totalStages,
      );

      context.read<CreateTaskCubit>().createTask(task);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateTaskCubit, CreateTaskState>(
      listener: (context, state) {
        if (state is CreateTaskSuccess) {
          CustomSnackbar.showSuccess(
              context: context, message: 'تم إنشاء المهمة بنجاح!');
          Future.delayed(Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });
        } else if (state is CreateTaskError) {
          CustomSnackbar.showError(context: context, message: state.message);
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  TaskDetailsSection(
                    titleController: _titleController,
                    descriptionController: _descriptionController,
                  ),
                  const SizedBox(height: 16),
                  MemberSelectionSection(
                    selectedMembers: _selectedMembers,
                    onMembersSelected: (selected) {
                      setState(() {
                        _selectedMembers = selected;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  DateDurationSection(
                    startDateController: _startDateController,
                    durationController: _durationController,
                    endDateController: _endDateController,
                    onStartDateSelected: _selectStartDate,
                  ),
                  const SizedBox(height: 16),
                  StagesSelectorSection(
                    totalStages: _totalStages,
                    onStagesChanged: (newStages) {
                      setState(() {
                        _totalStages = newStages;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  // PrioritySelectorSection(
                  //   priority: _priority,
                  //   onPriorityChanged: (newPriority) {
                  //     setState(() {
                  //       _priority = newPriority;
                  //     });
                  //   },
                  // ),
                  const SizedBox(height: 24),
                  RewardTypeSelectorSection(
                    rewardType: _rewardType,
                    onRewardTypeChanged: (newType) {
                      setState(() {
                        _rewardType = newType;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  RewardDetailsSection(
                    rewardType: _rewardType,
                    rewardAmountController: _rewardAmountController,
                    rewardDescriptionController: _rewardDescriptionController,
                  ),
                  const SizedBox(height: 24),
                  SubmitButtonSection(
                    isLoading: state is CreateTaskLoading,
                    onSubmit: () => _createTask(context),
                  ),
                ],
              ),
            ),
            if (state is CreateTaskLoading)
              const Positioned.fill(
                child: Center(
                  child: CustomProgressIndcator(size: 50),
                ),
              ),
          ],
        );
      },
    );
  }
}
