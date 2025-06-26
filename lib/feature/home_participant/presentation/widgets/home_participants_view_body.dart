import 'package:flutter/material.dart';
import 'package:moazez/feature/home_supporter/presentation/widgets/home_top_section.dart';
import 'package:moazez/feature/home_participant/presentation/widgets/task_summary_card.dart';
import 'package:moazez/feature/home_participant/presentation/widgets/current_tasks_card.dart';

class HomeParticipantsViewBody extends StatelessWidget {
  const HomeParticipantsViewBody({super.key});
  

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const HomeTopSection(),
          Row(
            children: const [
              TaskSummaryCard(count: 5, title: 'مهام نشطة'),
              TaskSummaryCard(count: 10, title: 'مهام مكتملة'),
            ],
          ),
          TitleWithSeeAll(onTap: () {}),
          CurrentTasksCard(
            status: 'قيد التنفيذ',
            title: 'مهمة حالية - مثال',
            progress: 0.65,
            onViewAllTap: () {
              // Navigate to full tasks view
            },
          ),
        ],
      ),
    );
  }
}
