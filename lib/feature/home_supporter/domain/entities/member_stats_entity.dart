class MemberStatsEntity {
  final int id;
  final String name;
  final String email;
  final String avatarUrl;
  final StatsEntity stats;
  final List<TaskEntity> tasks;

  const MemberStatsEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.stats,
    required this.tasks,
  });

  factory MemberStatsEntity.fromJson(Map<String, dynamic> json) {
    return MemberStatsEntity(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String? ?? "",
      stats: json['stats'] != null 
          ? StatsEntity.fromJson(json['stats'] as Map<String, dynamic>)
          : const StatsEntity(completionPercentageMargin: "0.0"),
      tasks: (json['tasks'] as List<dynamic>)
          .map((taskJson) => TaskEntity.fromJson(taskJson as Map<String, dynamic>))
          .toList(),
    );
  }
}

class StatsEntity {
  final String completionPercentageMargin;

  const StatsEntity({
    required this.completionPercentageMargin,
  });

  factory StatsEntity.fromJson(Map<String, dynamic> json) {
    return StatsEntity(
      completionPercentageMargin: json['completion_percentage_margin'] as String,
    );
  }
}

class TaskEntity {
  final int id;
  final String title;
  final String status;
  final int progress;
  final String dueDate;
  final String createdAt;
  final int stagesCount;
  final int completedStages;

  const TaskEntity({
    required this.id,
    required this.title,
    required this.status,
    required this.progress,
    required this.dueDate,
    required this.createdAt,
    required this.stagesCount,
    required this.completedStages,
  });

  factory TaskEntity.fromJson(Map<String, dynamic> json) {
    return TaskEntity(
      id: json['id'] as int,
      title: json['title'] as String,
      status: json['status'] as String,
      progress: json['progress'] as int,
      dueDate: json['due_date']  ?? '',
      createdAt: json['created_at'] as String,
      stagesCount: json['stages_count'] as int,
      completedStages: json['completed_stages'] as int,
    );
  }
}

class TeamSummaryEntity {
  final int totalTasks;
  final int completedTasks;
  final int pendingTasks;
  final int inProgressTasks;
  final double completionRate;

  const TeamSummaryEntity({
    required this.totalTasks,
    required this.completedTasks,
    required this.pendingTasks,
    required this.inProgressTasks,
    required this.completionRate,
  });

  factory TeamSummaryEntity.fromJson(Map<String, dynamic> json) {
    return TeamSummaryEntity(
      totalTasks: json['total_tasks'] as int,
      completedTasks: json['completed_tasks'] as int,
      pendingTasks: json['pending_tasks'] as int,
      inProgressTasks: json['in_progress_tasks'] as int,
      completionRate: (json['completion_rate'] as num).toDouble(),
    );
  }
}

class PaginationEntity {
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;

  const PaginationEntity({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
  });

  factory PaginationEntity.fromJson(Map<String, dynamic> json) {
    return PaginationEntity(
      total: json['total'] as int,
      perPage: json['per_page'] as int,
      currentPage: int.parse(json['current_page'].toString()),
      lastPage: json['last_page'] as int,
    );
  }
}

class MemberTaskStatsResponseEntity {
  final List<MemberStatsEntity> members;
  final TeamSummaryEntity teamSummary;
  final PaginationEntity pagination;

  const MemberTaskStatsResponseEntity({
    required this.members,
    required this.teamSummary,
    required this.pagination,
  });

  factory MemberTaskStatsResponseEntity.fromJson(Map<String, dynamic> json) {
    return MemberTaskStatsResponseEntity(
      members: (json['members'] as List<dynamic>)
          .map((memberJson) => MemberStatsEntity.fromJson(memberJson as Map<String, dynamic>))
          .toList(),
      teamSummary: json['team_summary'] is Map<String, dynamic>
          ? TeamSummaryEntity.fromJson(json['team_summary'] as Map<String, dynamic>)
          : const TeamSummaryEntity(
              totalTasks: 0,
              completedTasks: 0,
              pendingTasks: 0,
              inProgressTasks: 0,
              completionRate: 0.0,
            ),
      pagination: json['pagination'] is Map<String, dynamic>
          ? PaginationEntity.fromJson(json['pagination'] as Map<String, dynamic>)
          : const PaginationEntity(
              total: 0,
              perPage: 0,
              currentPage: 0,
              lastPage: 0,
            ),
    );
  }
}
