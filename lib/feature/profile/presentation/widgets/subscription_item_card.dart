import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import '../../domain/entities/user_subscription_entity.dart';
import '../../../../core/utils/theme/app_colors.dart';

class SubscriptionItemCard extends StatelessWidget {
  const SubscriptionItemCard({super.key, required this.subscription});

  final UserSubscriptionEntity subscription;

  String _formatDate(String date) {
    if (date.isEmpty) return 'غير محدد';
    try {
      final DateTime parsedDate = DateTime.parse(date);
      return intl.DateFormat('dd/MM/yyyy', 'ar').format(parsedDate);
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = subscription.status == 'active';
    final statusColor = isActive ? AppColors.success : AppColors.error;
    final statusText = isActive ? 'نشط' : 'منتهي';

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [theme.cardColor.withOpacity(0.9), theme.cardColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with package name and status
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      subscription.packageInfo.name,
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size20,
                        color: theme.colorScheme.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          statusText,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size12,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Subscription details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildDetailRow(
                    context,
                    icon: Icons.monetization_on_outlined,
                    label: 'السعر المدفوع:',
                    value: '${subscription.packageInfo.price} ريال',
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    context,
                    icon: Icons.calendar_today_outlined,
                    label: 'تاريخ البدء:',
                    value: _formatDate(subscription.createdAt),
                  ),
                  const SizedBox(height: 12),

                  const SizedBox(height: 12),
                  _buildDetailRow(
                    context,
                    icon: Icons.task_outlined,
                    label: 'الحد الأقصى للمهام:',
                    value: '${subscription.packageInfo.maxTasks} مهمة',
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    context,
                    icon: Icons.list_outlined,
                    label: 'المراحل لكل مهمة:',
                    value:
                        '${subscription.packageInfo.maxMilestonesPerTask} مراحل',
                  ),
                  if (subscription.packageInfo.isTrial) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'باقة تجريبية',
                            style: getMediumStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: FontSize.size14,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Text(
          label,
          style: getRegularStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size14,
            color: theme.textTheme.bodyMedium!.color!.withOpacity(0.7),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size14,
            color: theme.textTheme.bodyLarge!.color,
          ),
        ),
      ],
    );
  }
}
