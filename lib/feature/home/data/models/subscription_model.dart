import 'package:moazez/feature/home/domain/entities/subscription_entity.dart';

class SubscriptionModel extends SubscriptionEntity {
  const SubscriptionModel({
    required int id,
    required String status,
    required String? startDate,
    required String? endDate,
    required String pricePaid,
    required PackageModel package,
    required UsageModel usage,
    required double? daysRemaining,
    required bool isActive,
  }) : super(
          id: id,
          status: status,
          startDate: startDate ?? '',
          endDate: endDate,
          pricePaid: pricePaid,
          package: package,
          usage: usage,
          daysRemaining: daysRemaining,
          isActive: isActive,
        );

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'],
      status: json['status'] ?? '',
      startDate: json['start_date'],
      endDate: json['end_date'],
      pricePaid: json['price_paid'] ?? '',
      package: PackageModel.fromJson(json['package'] ?? {}),
      usage: UsageModel.fromJson(json['usage'] ?? {}),
      daysRemaining: json['days_remaining'] is double 
          ? json['days_remaining'] 
          : (json['days_remaining'] is String && json['days_remaining'] != 'غير محدد') 
              ? double.tryParse(json['days_remaining']) 
              : null,
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'start_date': startDate,
      'end_date': endDate,
      'price_paid': pricePaid,
      'package': (package as PackageModel).toJson(),
      'usage': (usage as UsageModel).toJson(),
      'days_remaining': daysRemaining,
      'is_active': isActive,
    };
  }
}

class PackageModel extends PackageEntity {
  const PackageModel({
    required int id,
    required String name,
    required int isTrial,
    required int maxTasks,
    required int maxMilestonesPerTask,
  }) : super(
          id: id,
          name: name,
          isTrial: isTrial,
          maxTasks: maxTasks,
          maxMilestonesPerTask: maxMilestonesPerTask,
        );

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      isTrial: json['is_trial'] ?? 0,
      maxTasks: json['max_tasks'] ?? 0,
      maxMilestonesPerTask: json['max_milestones_per_task'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_trial': isTrial,
      'max_tasks': maxTasks,
      'max_milestones_per_task': maxMilestonesPerTask,
    };
  }
}

class UsageModel extends UsageEntity {
  const UsageModel({
    required int tasksCreated,
    required int remainingTasks,
    required int usagePercentage,
  }) : super(
          tasksCreated: tasksCreated,
          remainingTasks: remainingTasks,
          usagePercentage: usagePercentage,
        );

  factory UsageModel.fromJson(Map<String, dynamic> json) {
    final int tasksCreated = json['tasks_created'] ?? 0;
    final int maxTasks = json['max_tasks'] ?? 0;
    final int remainingTasks = json.containsKey('remaining_tasks') 
        ? json['remaining_tasks'] 
        : (maxTasks > 0 ? maxTasks - tasksCreated : 0);
    return UsageModel(
      tasksCreated: tasksCreated,
      remainingTasks: remainingTasks,
      usagePercentage: json['usage_percentage'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tasks_created': tasksCreated,
      'remaining_tasks': remainingTasks,
      'usage_percentage': usagePercentage,
    };
  }
}
