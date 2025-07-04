import 'package:equatable/equatable.dart';

class UserSubscriptionEntity extends Equatable {
  final int id;
  final int userId;
  final int packageId;
  final String status; // active / expired / cancelled
  final String createdAt;
  final String endDate;
  final String pricePaid;
  final PackageInfo packageInfo;

  const UserSubscriptionEntity({
    required this.id,
    required this.userId,
    required this.packageId,
    required this.status,
    required this.createdAt,
    required this.endDate,
    required this.pricePaid,
    required this.packageInfo,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    packageId,
    status,
    createdAt,
    endDate,
    pricePaid,
    packageInfo,
  ];
}

class PackageInfo extends Equatable {
  final int id;
  final String name;
  final String price;
  final int maxTasks;
  final int maxMilestonesPerTask;
  final bool isTrial;

  const PackageInfo({
    required this.id,
    required this.name,
    required this.price,
    required this.maxTasks,
    required this.maxMilestonesPerTask,
    required this.isTrial,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    price,
    maxTasks,
    maxMilestonesPerTask,
    isTrial,
  ];
}
