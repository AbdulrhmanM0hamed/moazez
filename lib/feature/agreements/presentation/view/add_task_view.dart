import 'package:flutter/material.dart';
import 'package:moazez/core/utils/common/custom_app_bar.dart';
import 'package:moazez/feature/agreements/presentation/widgets/add_task_form.dart';

class AddTaskView extends StatelessWidget {
  const AddTaskView({super.key});

  static const String routeName = '/add-task';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'إضافة مهمة جديدة'),
      body: const AddTaskForm(),
    );
  }
}
