import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/feature/MyTasks/domain/entities/my_task_entity.dart';
import 'package:moazez/feature/MyTasks/presentation/cubit/my_tasks_cubit.dart';
import 'package:moazez/feature/MyTasks/presentation/cubit/my_tasks_state.dart';
import 'package:moazez/feature/MyTasks/presentation/widgets/my_task_card.dart';
import 'package:moazez/feature/MyTasks/presentation/widgets/my_task_card_shimmer.dart';
import 'package:moazez/feature/MyTasks/presentation/widgets/my_tasks_filter_tabs.dart';
import 'package:moazez/core/widgets/empty_view.dart';
import 'package:moazez/feature/home_supporter/presentation/widgets/home_top_section.dart';

class MyTasksView extends StatelessWidget {
  const MyTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MyTasksCubit>(),
      child: const _MyTasksViewBody(),
    );
  }
}

class _MyTasksViewBody extends StatefulWidget {
  const _MyTasksViewBody();

  @override
  State<_MyTasksViewBody> createState() => _MyTasksViewBodyState();
}

class _MyTasksViewBodyState extends State<_MyTasksViewBody> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Fetch all tasks initially and let the client handle filtering
    context.read<MyTasksCubit>().getMyTasks(status: null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HomeTopSection(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: MyTasksFilterTabs(
              selectedIndex: _selectedIndex,
              onTabSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<MyTasksCubit, MyTasksState>(
              builder: (context, state) {
                if (state is MyTasksLoading) {
                  return const ShimmerTaskList();
                } else if (state is MyTasksError) {
                  return Center(child: Text(state.message));
                } else if (state is MyTasksLoaded) {
                  final List<MyTaskEntity> filteredTasks;
                  switch (_selectedIndex) {
                    case 1: // لم تبدأ
                      filteredTasks = state.tasks
                          .where((task) => task.progress == 0)
                          .toList();
                      break;
                    case 2: // قيد التنفيذ
                      filteredTasks = state.tasks
                          .where((task) => task.status == 'in_progress')
                          .toList();
                      break;
                    case 3: // مكتملة
                      filteredTasks = state.tasks
                          .where((task) => task.status == 'completed')
                          .toList();
                      break;
                    case 0: // الكل
                    default:
                      filteredTasks = state.tasks;
                      break;
                  }

                  if (filteredTasks.isEmpty) {
                    return const EmptyView(
                      imagePath: 'assets/images/tasksEmpty.png',
                      message: 'لا توجد مهام تطابق هذا الفلتر',
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      await context.read<MyTasksCubit>().getMyTasks();
                      return Future.delayed(const Duration(seconds: 1));
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 16),
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        return MyTaskCard(task: task);
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
