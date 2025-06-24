import 'package:flutter/material.dart';
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
    final String price = sub.pricePaid == '0' ? 'مجاني' : '\$${sub.pricePaid}';
    final String billingCycle =
        isTrial ? 'فترة تجريبية' : 'شهرياً'; // Placeholder
    final String status = sub.status;
    final int remainingTasks = sub.usage.remainingTasks;
    final int totalTasks = sub.usage.tasksCreated + sub.usage.remainingTasks;
    final String trialPeriod =
        sub.daysRemaining != null ? '${sub.daysRemaining} يوم متبقي' : 'غير محدد';

    // Now, return the new UI using these variables
    return Directionality(
      textDirection: TextDirection.rtl, // Set to RTL for Arabic
      child: Container(
        margin: const EdgeInsets.all(16.0),
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
                          const Color.fromARGB(
                            255,
                            129,
                            199,
                            132,
                          ), // Light Green
                          const Color.fromARGB(
                            255,
                            66,
                            150,
                            71,
                          ), // Medium Green
                        ]
                        : [
                          const Color.fromARGB(
                            255,
                            56,
                            74,
                            235,
                          ), // Light Blue
                          const Color.fromARGB(
                            255,
                            56,
                            74,
                            235,
                          ), // Dark Blue
                        ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(planName, trialPeriod, billingCycle, isTrial),
                  const SizedBox(height: 8.0),

                  _buildProgress(remainingTasks, totalTasks, isTrial),
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
              planName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
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

  Widget _buildPricing(String price, String billingCycle, bool isTrial) {
    if (isTrial) return const SizedBox.shrink();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          price,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 36.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8.0),
        Text(
          '/ ${billingCycle.toLowerCase()}',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }

  Widget _buildProgress(int tasksRemaining, int totalTasks, bool isTrial) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'تقدم المهام',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              totalTasks > 0
                  ? '$tasksRemaining من $totalTasks متبقي'
                  : '$tasksRemaining متبقي',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        if (totalTasks > 0)
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: LinearProgressIndicator(
              value: (totalTasks - tasksRemaining) / totalTasks,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                isTrial ? Colors.white : const Color(0xFF2ECC71),
              ),
              minHeight: 8.0,
            ),
          ),
      ],
    );
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
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return const Color(0xFF2ECC71);
      case 'expired':
        return const Color(0xFFE74C3C);
      case 'pending':
        return const Color(0xFFF39C12);
      default:
        return const Color(0xFF95A5A6);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Icons.check_circle_outline_rounded;
      case 'expired':
        return Icons.error_outline_rounded;
      case 'pending':
        return Icons.pending_outlined;
      default:
        return Icons.info_outline_rounded;
    }
  }
}
