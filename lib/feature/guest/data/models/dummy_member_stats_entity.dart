import 'package:moazez/feature/home_supporter/domain/entities/member_stats_entity.dart';

class DummyMemberStatsData {
  static MemberTaskStatsResponseEntity getDummyMemberStats() {
    return MemberTaskStatsResponseEntity(
      members: [
        MemberStatsEntity(
          id: 1,
          name: "عبدالله السالم",
          email: "abdullah@example.com",
          avatarUrl: "https://picsum.photos/seed/abdullah/200",
          stats: const StatsEntity(completionPercentageMargin: "62.5"),
          tasks: [
            const TaskEntity(
              id: 1,
              title: "التحضير لماراثون الرياض",
              status: "in_progress",
              progress: 75,
              dueDate: "2025-10-30",
              createdAt: "2025-06-01",
              stagesCount: 4,
              completedStages: 3,
            ),
            const TaskEntity(
              id: 2,
              title: "قراءة 12 كتاباً خلال العام",
              status: "in_progress",
              progress: 50,
              dueDate: "2025-12-31",
              createdAt: "2025-01-05",
              stagesCount: 12,
              completedStages: 6,
            ),
          ],
        ),
        MemberStatsEntity(
          id: 2,
          name: "فاطمة الزهراني",
          email: "fatima@example.com",
          avatarUrl: "https://picsum.photos/seed/fatima/200",
          stats: const StatsEntity(completionPercentageMargin: "80.0"),
          tasks: [
            const TaskEntity(
              id: 3,
              title: "إطلاق الحملة التسويقية للمنتج",
              status: "completed",
              progress: 100,
              dueDate: "2025-08-20",
              createdAt: "2025-07-10",
              stagesCount: 5,
              completedStages: 5,
            ),
            const TaskEntity(
              id: 6,
              title: "تعلم أساسيات التصميم الجرافيكي",
              status: "in_progress",
              progress: 60,
              dueDate: "2025-09-15",
              createdAt: "2025-07-20",
              stagesCount: 10,
              completedStages: 6,
            ),
          ],
        ),
        MemberStatsEntity(
          id: 3,
          name: "عمر الأحمدي",
          email: "omar@example.com",
          avatarUrl: "https://picsum.photos/seed/omar/200",
          stats: const StatsEntity(completionPercentageMargin: "40.0"),
          tasks: [
            const TaskEntity(
              id: 4,
              title: "توفير 20% من الراتب الشهري",
              status: "in_progress",
              progress: 40,
              dueDate: "2025-12-31",
              createdAt: "2025-01-01",
              stagesCount: 12,
              completedStages: 4,
            ),
          ],
        ),
      ],
      teamSummary: const TeamSummaryEntity(
        totalTasks: 5,
        completedTasks: 1,
        pendingTasks: 0,
        inProgressTasks: 4,
        completionRate: 67.0,
      ),
      pagination: const PaginationEntity(
        total: 3,
        perPage: 10,
        currentPage: 1,
        lastPage: 1,
      ),
    );
  }
}