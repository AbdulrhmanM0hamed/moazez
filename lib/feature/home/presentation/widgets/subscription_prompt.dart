import 'package:flutter/material.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/core/utils/common/custom_button.dart';

class SubscriptionPrompt extends StatelessWidget {
  final VoidCallback? onSubscribePressed;

  const SubscriptionPrompt({super.key, this.onSubscribePressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric( vertical: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon or Illustration
          Icon(
            Icons.lock_outline_rounded,
            size: 64,
            color: AppColors.primary.withValues(alpha:  0.7),
          ),
          const SizedBox(height: 16),
          // Title
          Text(
            'لست مشتركًا في أي باقة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Subtitle
          Text(
            'اشترك الآن وابدأ رحلتك معنا للحصول على أفضل الخدمات والمميزات الحصرية',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Subscribe Button
          CustomButton(
            text: 'ابدأ الآن',
            onPressed: onSubscribePressed ?? () {
              // Default action if no callback is provided
            },
            backgroundColor: AppColors.primary,
            textColor: AppColors.white,
          ),
        ],
      ),
    );
  }
}
