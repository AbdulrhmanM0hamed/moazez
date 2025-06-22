import 'package:flutter/material.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/profile/data/models/profile_model.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.user});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('المعلومات الشخصية', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(height: 24),
          _buildInfoRow(Icons.phone_outlined, 'الهاتف', user.phone ?? '--'),
          _buildInfoRow(Icons.cake_outlined, 'تاريخ الميلاد', user.birthdate ?? '--'),
          _buildInfoRow(user.gender == 'male' ? Icons.male : Icons.female, 'النوع', user.gender == 'male' ? 'ذكر' : 'أنثى'),
          _buildInfoRow(Icons.location_on_outlined, 'المنطقة', user.area?.name ?? 'غير محدد'),
          _buildInfoRow(Icons.location_city_outlined, 'المدينة', user.city?.name ?? 'غير محدد', hasDivider: false),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {bool hasDivider = true}) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(width: 16),
            Text(label, style: const TextStyle(fontSize: 16, color: AppColors.textSecondary)),
            const Spacer(),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
          ],
        ),
        if (hasDivider) const Divider(height: 24),
      ],
    );
  }
}
