import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/common/custom_app_bar.dart';
import 'package:moazez/feature/agreements/presentation/cubit/create_task_cubit.dart';
import 'package:moazez/feature/agreements/presentation/cubit/team_members_cubit.dart';
import 'package:moazez/feature/agreements/presentation/widgets/add_task_form/add_task_form.dart';

class AddTaskView extends StatelessWidget {
  const AddTaskView({super.key});

  static const String routeName = '/add-task';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<CreateTaskCubit>()),
        BlocProvider(create: (context) => sl<TeamMembersCubit>()),
      ],
      child: Scaffold(
        appBar: CustomAppBar(title: 'إضافة هدف جديد'),
        body: const AddTaskForm(),
      ),
    );
  }
}
