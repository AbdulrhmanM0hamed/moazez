import 'package:flutter/material.dart';
import '../../domain/entities/payment_entity.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';

class PaymentItemCard extends StatelessWidget {
  final PaymentEntity payment;
  const PaymentItemCard({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    payment.packageType,
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size18,
                      color: AppColors.primary,
                    ),
                  ),
                  Chip(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    label: Text(
                      payment.status == 'completed' ? 'مكتملة' : 'معلقة',
                      style: getMediumStyle(
                        color: Colors.white,
                        fontSize: FontSize.size12,
                        fontFamily: FontConstant.cairo,
                      ),
                    ),
                    backgroundColor: payment.status == 'completed'
                        ? AppColors.success
                        : AppColors.warning,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide.none,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.money_rounded, 'المبلغ: ${payment.amount} ${payment.currency}'),
              const SizedBox(height: 10),
              _buildDetailRow(Icons.calendar_today_outlined, 'التاريخ: ${payment.createdAt.toLocal().toString().split(' ')[0]}'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 18),
        const SizedBox(width: 10),
        Text(
          text,
          style: getRegularStyle(
            color: AppColors.textSecondary,
            fontSize: FontSize.size14,
            fontFamily: FontConstant.cairo,
          ),
        ),
      ],
    );
  }
}
