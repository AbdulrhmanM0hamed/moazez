import 'package:moazez/feature/home_supporter/domain/entities/member_stats_entity.dart';

class MemberStatsModel extends MemberStatsEntity {
  const MemberStatsModel({
    required int id,
    required String name,
    required String email,
    required String avatarUrl,
    required StatsModel stats,
    required List<TaskModel> tasks,
  }) : super(
         id: id,
         name: name,
         email: email,
         avatarUrl: avatarUrl,
         stats: stats,
         tasks: tasks,
       );

  factory MemberStatsModel.fromJson(Map<String, dynamic> json) {
    return MemberStatsModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String,
      stats: StatsModel.fromJson(json['stats'] as Map<String, dynamic>),
      tasks:
          (json['tasks'] as List<dynamic>)
              .map(
                (taskJson) =>
                    TaskModel.fromJson(taskJson as Map<String, dynamic>),
              )
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar_url': avatarUrl,
      'stats': (stats as StatsModel).toJson(),
      'tasks': tasks.map((task) => (task as TaskModel).toJson()).toList(),
    };
  }
}

class StatsModel extends StatsEntity {
  const StatsModel({required String completionPercentageMargin})
    : super(completionPercentageMargin: completionPercentageMargin);

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      completionPercentageMargin:
          json['completion_percentage_margin'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'completion_percentage_margin': completionPercentageMargin};
  }
}

class TaskModel extends TaskEntity {
  const TaskModel({
    required int id,
    required String title,
    required String status,
    required int progress,
    required int stagesCount,
  }) : super(
         id: id,
         title: title,
         status: status,
         progress: progress,
         stagesCount: stagesCount,
       );

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as int,
      title: json['title'] as String,
      status: json['status'] as String,
      progress: json['progress'] as int,
      stagesCount: json['stages_count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'progress': progress,
      'stages_count': stagesCount,
    };
  }
}

class TeamSummaryModel extends TeamSummaryEntity {
  const TeamSummaryModel({
    required int totalTasks,
    required int completedTasks,
    required int pendingTasks,
    required int inProgressTasks,
    required double completionRate,
  }) : super(
         totalTasks: totalTasks,
         completedTasks: completedTasks,
         pendingTasks: pendingTasks,
         inProgressTasks: inProgressTasks,
         completionRate: completionRate,
       );

  factory TeamSummaryModel.fromJson(Map<String, dynamic> json) {
    return TeamSummaryModel(
      totalTasks: json['total_tasks'] as int,
      completedTasks: json['completed_tasks'] as int,
      pendingTasks: json['pending_tasks'] as int,
      inProgressTasks: json['in_progress_tasks'] as int,
      completionRate: (json['completion_rate'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_tasks': totalTasks,
      'completed_tasks': completedTasks,
      'pending_tasks': pendingTasks,
      'in_progress_tasks': inProgressTasks,
      'completion_rate': completionRate,
    };
  }
}

class PaginationModel extends PaginationEntity {
  const PaginationModel({
    required int total,
    required int perPage,
    required int currentPage,
    required int lastPage,
  }) : super(
         total: total,
         perPage: perPage,
         currentPage: currentPage,
         lastPage: lastPage,
       );

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      total: json['total'] as int,
      perPage: json['per_page'] as int,
      currentPage: json['current_page'] as int,
      lastPage: json['last_page'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'per_page': perPage,
      'current_page': currentPage,
      'last_page': lastPage,
    };
  }
}

class MemberTaskStatsResponseModel extends MemberTaskStatsResponseEntity {
  const MemberTaskStatsResponseModel({
    required List<MemberStatsModel> members,
    required TeamSummaryModel teamSummary,
    required PaginationModel pagination,
  }) : super(
         members: members,
         teamSummary: teamSummary,
         pagination: pagination,
       );

  factory MemberTaskStatsResponseModel.fromJson(Map<String, dynamic> json) {
    return MemberTaskStatsResponseModel(
      members:
          (json['members'] as List<dynamic>)
              .map(
                (memberJson) => MemberStatsModel.fromJson(
                  memberJson as Map<String, dynamic>,
                ),
              )
              .toList(),
      teamSummary: TeamSummaryModel.fromJson(
        json['team_summary'] as Map<String, dynamic>,
      ),
      pagination: PaginationModel.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
    );
  }

  factory MemberTaskStatsResponseModel.fromEntity(
    MemberTaskStatsResponseEntity entity,
  ) {
    return MemberTaskStatsResponseModel(
      members:
          entity.members
              .map(
                (e) => MemberStatsModel(
                  id: e.id,
                  name: e.name,
                  email: e.email,
                  avatarUrl: e.avatarUrl,
                  stats: StatsModel(
                    completionPercentageMargin:
                        e.stats.completionPercentageMargin,
                  ),
                  tasks:
                      e.tasks
                          .map(
                            (t) => TaskModel(
                              id: t.id,
                              title: t.title,
                              status: t.status,
                              progress: t.progress,
                              stagesCount: t.stagesCount,
                            ),
                          )
                          .toList(),
                ),
              )
              .toList(),
      teamSummary: TeamSummaryModel(
        totalTasks: entity.teamSummary.totalTasks,
        completedTasks: entity.teamSummary.completedTasks,
        pendingTasks: entity.teamSummary.pendingTasks,
        inProgressTasks: entity.teamSummary.inProgressTasks,
        completionRate: entity.teamSummary.completionRate,
      ),
      pagination: PaginationModel(
        total: entity.pagination.total,
        perPage: entity.pagination.perPage,
        currentPage: entity.pagination.currentPage,
        lastPage: entity.pagination.lastPage,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'members':
          members
              .map((member) => (member as MemberStatsModel).toJson())
              .toList(),
      'team_summary': (teamSummary as TeamSummaryModel).toJson(),
      'pagination': (pagination as PaginationModel).toJson(),
    };
  }
}
