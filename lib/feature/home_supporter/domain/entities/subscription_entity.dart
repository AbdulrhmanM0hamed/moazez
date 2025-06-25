import 'package:equatable/equatable.dart';

class SubscriptionEntity extends Equatable {
  final int id;
  final String status;
  final String startDate;
  final String? endDate;
  final String pricePaid;
  final PackageEntity package;
  final UsageEntity usage;
  final double? daysRemaining;
  final bool isActive;

  const SubscriptionEntity({
    required this.id,
    required this.status,
    required this.startDate,
    this.endDate,
    required this.pricePaid,
    required this.package,
    required this.usage,
    this.daysRemaining,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
        id,
        status,
        startDate,
        endDate,
        pricePaid,
        package,
        usage,
        daysRemaining,
        isActive,
      ];
}

class PackageEntity extends Equatable {
  final int id;
  final String name;
  final int isTrial;
  final int maxTasks;
  final int maxMilestonesPerTask;

  const PackageEntity({
    required this.id,
    required this.name,
    required this.isTrial,
    required this.maxTasks,
    required this.maxMilestonesPerTask,
  });

  @override
  List<Object> get props => [id, name, isTrial, maxTasks, maxMilestonesPerTask];
}

class UsageEntity extends Equatable {
  final int tasksCreated;
  final int remainingTasks;
  final int usagePercentage;

  const UsageEntity({
    required this.tasksCreated,
    required this.remainingTasks,
    required this.usagePercentage,
  });

  @override
  List<Object> get props => [tasksCreated, remainingTasks, usagePercentage];
}
