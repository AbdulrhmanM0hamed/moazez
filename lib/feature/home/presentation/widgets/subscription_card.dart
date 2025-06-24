import 'package:flutter/material.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/feature/home/domain/entities/subscription_entity.dart';
import 'package:moazez/feature/profile/data/models/profile_model.dart'
    show ActiveSubscription;

class SubscriptionCard extends StatelessWidget {
  final dynamic subscription;

  const SubscriptionCard({super.key, required this.subscription});

  @override
  Widget build(BuildContext context) {
    SubscriptionEntity sub;

    // Unify the data source to SubscriptionEntity
    if (subscription is SubscriptionEntity) {
      sub = subscription as SubscriptionEntity;
    } else if (subscription is ActiveSubscription) {
      final activeSub = subscription as ActiveSubscription;
      sub = SubscriptionEntity(
        id: 0,
        status: activeSub.status ?? 'pending',
        startDate: '',
        endDate: null,
        pricePaid: '0',
        isActive: activeSub.status == 'active',
        package: PackageEntity(
          id: 0,
          name: activeSub.packageName ?? 'Unknown Plan',
          isTrial: activeSub.packageName?.contains('التجريبية') == true ? 1 : 0,
          maxTasks: 0, // Not available
          maxMilestonesPerTask: 0, // Not available
        ),
        usage: UsageEntity(
          tasksCreated: 0, // Not available
          remainingTasks: activeSub.tasksRemaining ?? 0,
          usagePercentage: 0, // Not available
        ),
      );
    } else {
      return const SizedBox.shrink(); // Or a placeholder
    }

    // Map data to the new UI parameters
    final bool isTrial = sub.package.isTrial == 1;
    final String planName = sub.package.name;
    final String billingCycle =
        isTrial ? 'فترة تجريبية' : 'شهرياً'; // Placeholder
    final String status = _getStatusText(sub.status);
    final int remainingTasks = sub.usage.remainingTasks;
    final int totalTasks = sub.usage.tasksCreated + sub.usage.remainingTasks;
    final double usagePercentage =
        sub.usage.usagePercentage /
        100.0; // Convert to 0.0-1.0 range for progress bar
    final String trialPeriod =
        sub.daysRemaining != null
            ? '${sub.daysRemaining} يوم متبقي'
            : 'غير محدد';

    // Now, return the new UI using these variables
    return Directionality(
      textDirection: TextDirection.rtl, // Set to RTL for Arabic
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors:
                    isTrial
                        ? [
                          const Color.fromARGB(255, 84, 175, 90), // Light Green
                          const Color.fromARGB(
                            255,
                            93,
                            172,
                            98,
                          ), // Medium Green
                        ]
                        : [
                          const Color.fromARGB(255, 56, 74, 235), // Light Blue
                          const Color.fromARGB(255, 56, 74, 235), // Dark Blue
                        ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(planName, trialPeriod, billingCycle, isTrial),
                  const SizedBox(height: 8.0),

                  _buildProgress(
                    context,
                    remainingTasks,
                    totalTasks,
                    isTrial,
                    usagePercentage,
                  ),
                  const SizedBox(height: 16.0),
                  _buildStatus(status),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    String planName,
    String trialPeriod,
    String billingCycle,
    bool isTrial,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "انت الان على الباقة ${planName} ",
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Icon(
          isTrial ? Icons.star_rounded : Icons.card_membership_rounded,
          color: Colors.white,
          size: 32.0,
        ),
      ],
    );
  }

  Widget _buildProgress(
    BuildContext context,
    int tasksRemaining,
    int totalTasks,
    bool isTrial,
    double usagePercentage,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // النصوص العلوية
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'تقدم المهام',
              style: getSemiBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
            Text(
              totalTasks > 0
                  ? '$tasksRemaining من $totalTasks متبقي'
                  : '$tasksRemaining متبقي',
              style: getSemiBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: 14.0,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12.0),

        // Progress Bar بتدرج احترافي
        Stack(
          children: [
            // الخلفية
            Container(
              height: 10.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),

            // الشريط نفسه مع تدريج
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                height: 10.0,
                width:
                    usagePercentage.clamp(0.0, 1.0) *
                    MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: _getInterpolatedColor(usagePercentage, isTrial),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getInterpolatedColor(double percentage, bool isTrial) {
    if (percentage <= 0.5) {
      // من 0% إلى 50% - أخضر
      return const Color.fromARGB(255, 46, 204, 113); // Green
    } else if (percentage <= 0.8) {
      // من 51% إلى 80% - أصفر
      return const Color.fromARGB(255, 241, 196, 15); // Yellow
    } else {
      // من 81% إلى 100% - أحمر
      return const Color.fromARGB(255, 231, 76, 60); // Red
    }
  }

  Widget _buildStatus(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getStatusIcon(status), color: Colors.white, size: 16.0),
          const SizedBox(width: 6.0),
          Text(
            status,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.cairo,
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'نشط';
      case 'expired':
        return 'منتهي';
      case 'pending':
        return 'معلق';
      default:
        return 'غير معروف';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'نشط':
        return const Color(0xFF2ECC71);
      case 'expired':
      case 'منتهي':
        return const Color(0xFFE74C3C);
      case 'pending':
      case 'معلق':
        return const Color(0xFFF39C12);
      default:
        return const Color(0xFF95A5A6);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'نشط':
        return Icons.check_circle_outline_rounded;
      case 'expired':
      case 'منتهي':
        return Icons.error_outline_rounded;
      case 'pending':
      case 'معلق':
        return Icons.pending_outlined;
      default:
        return Icons.info_outline_rounded;
    }
  }
}
