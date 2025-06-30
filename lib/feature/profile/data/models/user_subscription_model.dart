import '../../domain/entities/user_subscription_entity.dart';

class UserSubscriptionModel extends UserSubscriptionEntity {
  const UserSubscriptionModel({
    required super.id,
    required super.packageId,
    required super.status,
    required super.startDate,
    required super.endDate,
    required super.pricePaid,
    required super.packageInfo,
  });

  factory UserSubscriptionModel.fromJson(Map<String, dynamic> json) {
    return UserSubscriptionModel(
      id: json['id'] as int,
      packageId: json['package_id'] as int,
      status: json['status'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      pricePaid: (json['price_paid'] ?? '').toString(),
      packageInfo: PackageInfo(
        id: json['package']['id'] as int,
        name: json['package']['name'] as String,
        price: (json['package']['price'] ?? '').toString(),
        maxTasks: json['package']['max_tasks'] as int,
        maxMilestonesPerTask: json['package']['max_milestones_per_task'] as int,
        isTrial: json['package']['is_trial'] as bool,
      ),
    );
  }
}
