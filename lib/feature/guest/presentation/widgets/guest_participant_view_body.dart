import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/guest/presentation/widgets/guest_home_top_section.dart';
import 'package:moazez/feature/home_participant/presentation/widgets/current_tasks_card.dart';
import 'package:moazez/feature/home_participant/presentation/widgets/task_summary_card.dart';

class GuestParticipantViewBody extends StatelessWidget {
  const GuestParticipantViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // إغلاق التطبيق عند الضغط على زر الرجوع من الصفحة الرئيسية
        await SystemNavigator.pop();
        return false;
      },
      child: RefreshIndicator(
        onRefresh: () async {
          // No action needed for guest mode refresh
          await Future.delayed(const Duration(seconds: 1));
        },
        child: Column(
          children: [
            GuestHomeTopSection(),
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TaskSummaryCard(completedTasks: 3, pendingTasks: 2),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Text(
                          'المهام الحالية',
                          style: getBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size16,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      CurrentTasksCard(
                        taskId: 0,
                        status: 'قيد التنفيذ',
                        title: 'مهمة تجريبية 1',
                        progress: 50.0,
                      ),
                      CurrentTasksCard(
                        taskId: 1,
                        status: 'لم تبدأ',
                        title: 'مهمة تجريبية 2',
                        progress: 0.0,
                      ),
                      CurrentTasksCard(
                        taskId: 2,
                        status: 'مكتملة',
                        title: 'مهمة تجريبية 3',
                        progress: 100.0,
                      ),
                      CurrentTasksCard(
                        taskId: 3,
                        status: 'قيد التنفيذ',
                        title: 'مهمة تجريبية 4',
                        progress: 75.0,
                      ),
                      CurrentTasksCard(
                        taskId: 4,
                        status: 'مكتملة',
                        title: 'مهمة تجريبية 5',
                        progress: 100.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
