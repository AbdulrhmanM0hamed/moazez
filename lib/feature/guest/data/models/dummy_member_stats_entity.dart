import 'package:moazez/feature/home_supporter/domain/entities/member_stats_entity.dart';

class DummyMemberStatsData {
  static MemberTaskStatsResponseEntity getDummyMemberStats() {
    return MemberTaskStatsResponseEntity(
      members: [
        MemberStatsEntity(
          id: 1,
          name: "أحمد محمد",
          email: "ahmed@example.com",
          avatarUrl: "https://i.pravatar.cc/150?img=1",
          stats: const StatsEntity(completionPercentageMargin: "75.0"),
          tasks: [
            const TaskEntity(
              id: 1,
              title: "إنشاء تصميم الواجهة",
              status: "completed",
              progress: 100,
              dueDate: "2023-12-30",
              createdAt: "2023-12-01",
              stagesCount: 3,
              completedStages: 3,
            ),
            const TaskEntity(
              id: 2,
              title: "تطوير الواجهة الأمامية",
              status: "in_progress",
              progress: 50,
              dueDate: "2024-01-15",
              createdAt: "2023-12-05",
              stagesCount: 4,
              completedStages: 2,
            ),
          ],
        ),
        MemberStatsEntity(
          id: 2,
          name: "سارة علي",
          email: "sara@example.com",
          avatarUrl: "https://i.pravatar.cc/150?img=5",
          stats: const StatsEntity(completionPercentageMargin: "60.0"),
          tasks: [
            const TaskEntity(
              id: 3,
              title: "تطوير واجهة برمجة التطبيقات",
              status: "in_progress",
              progress: 60,
              dueDate: "2024-01-20",
              createdAt: "2023-12-10",
              stagesCount: 5,
              completedStages: 3,
            ),
          ],
        ),
        MemberStatsEntity(
          id: 3,
          name: "محمد خالد",
          email: "mohamed@example.com",
          avatarUrl: "https://i.pravatar.cc/150?img=3",
          stats: const StatsEntity(completionPercentageMargin: "90.0"),
          tasks: [
            const TaskEntity(
              id: 4,
              title: "اختبار الوحدات",
              status: "completed",
              progress: 100,
              dueDate: "2023-12-25",
              createdAt: "2023-12-15",
              stagesCount: 2,
              completedStages: 2,
            ),
            const TaskEntity(
              id: 5,
              title: "اختبار التكامل",
              status: "in_progress",
              progress: 80,
              dueDate: "2024-01-10",
              createdAt: "2023-12-20",
              stagesCount: 3,
              completedStages: 2,
            ),
          ],
        ),
      ],
      teamSummary: const TeamSummaryEntity(
        totalTasks: 5,
        completedTasks: 2,
        pendingTasks: 0,
        inProgressTasks: 3,
        completionRate: 78.0,
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