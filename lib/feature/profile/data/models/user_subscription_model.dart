import '../../domain/entities/user_subscription_entity.dart';

class UserSubscriptionModel extends UserSubscriptionEntity {
  const UserSubscriptionModel({
    required super.id,
    required super.userId,
    required super.packageId,
    required super.status,
    required super.createdAt,
    required super.endDate,
    required super.pricePaid,
    required super.packageInfo,
  });

  factory UserSubscriptionModel.fromJson(Map<String, dynamic> json) {
    return UserSubscriptionModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      packageId: json['package_id'] as int,
      status: json['status'] as String,
      createdAt: json['created_at']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      pricePaid: double.tryParse(json['price_paid']?.toString() ?? '0.0')?.toStringAsFixed(2) ?? '0.00',
      packageInfo: PackageInfo(
        id: json['package']['id'] as int,
        name: json['package']['name'] as String,
        price: double.tryParse(json['package']['price']?.toString() ?? '0.0')?.toStringAsFixed(2) ?? '0.00',
        maxTasks: json['package']['max_tasks'] as int,
        maxMilestonesPerTask: json['package']['max_milestones_per_task'] as int,
        isTrial: json['package']['is_trial'] as bool,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'package_id': packageId,
      'status': status,
      'created_at': createdAt,
      'end_date': endDate,
      'price_paid': pricePaid,
      'package': {
        'id': packageInfo.id,
        'name': packageInfo.name,
        'price': packageInfo.price,
        'max_tasks': packageInfo.maxTasks,
        'max_milestones_per_task': packageInfo.maxMilestonesPerTask,
        'is_trial': packageInfo.isTrial,
      },
    };
  }
}
