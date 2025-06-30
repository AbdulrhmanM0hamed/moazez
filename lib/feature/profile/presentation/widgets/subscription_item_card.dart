import 'package:flutter/material.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import '../../domain/entities/user_subscription_entity.dart';
import '../../../../core/utils/theme/app_colors.dart';

class SubscriptionItemCard extends StatelessWidget {
  const SubscriptionItemCard({super.key, required this.subscription});

  final UserSubscriptionEntity subscription;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).cardColor.withValues(alpha: 0.9),
              Theme.of(context).cardColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      subscription.packageInfo.name,
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size20,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Chip(
                    label: Text(
                      subscription.status == 'active' ? 'نشط' : 'منتهي',
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size12,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor:
                        subscription.status == 'active'
                            ? AppColors.success
                            : AppColors.error,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(thickness: 0.5),
              const SizedBox(height: 12),
              _buildDetailRow(
                context,
                icon: Icons.calendar_today_outlined,
                label: 'تاريخ البدء:',
                value: subscription.startDate,
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                context,
                icon: Icons.event_busy_outlined,
                label: 'تاريخ الانتهاء:',
                value: subscription.endDate,
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                context,
                icon: Icons.monetization_on_outlined,
                label: 'السعر المدفوع:',
                value: '${subscription.pricePaid} ريال',
              ),
            ],
          ),
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
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Text(
          label,
          style: getRegularStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size14,
            color: Theme.of(
              context,
            ).textTheme.bodyMedium!.color!.withValues(alpha: 0.7),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size14,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
      ],
    );
  }
}
