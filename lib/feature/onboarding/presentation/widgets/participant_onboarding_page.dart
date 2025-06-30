import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';

import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';

class ParticipantOnboardingPage extends StatelessWidget {
  const ParticipantOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Text(
              'جاهز تثبت قدراتك؟\nالمهام في انتظارك',
              textAlign: TextAlign.center,
              style: getBoldStyle(
                fontSize: FontSize.size16,
                fontFamily: FontConstant.cairo,
              ),
            ),
            const SizedBox(height: 24),
            _buildTaskCards(),
            const SizedBox(height: 16),
            _buildProgressSection(),
            const SizedBox(height: 10),
            _buildRewardsSection(),
            const SizedBox(height: 24),
            Text(
              'ابدأ رحلتك مع معزز',
              style: getSemiBoldStyle(
                fontSize: FontSize.size18,
                fontFamily: FontConstant.cairo,
              ),
            ),
            const SizedBox(height: 16),
            SvgPicture.asset(
              'assets/images/part.svg',
              height: MediaQuery.of(context).size.height * 0.23,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(child: _TaskCard(label: 'مهام نشطة', value: '0')),
        const SizedBox(width: 16),
        Expanded(
          child: _TaskCard(
            label: 'مهام مكتملة',
            valueWidget: Icon(Icons.check, color: AppColors.primary, size: 30),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'التقدم',
          style: getMediumStyle(
            color: AppColors.primary,
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size16,
          ),
        ),
        const SizedBox(height: 8),
        ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [Color(0xFF0DD0F4), Color(0xFF006E82)],
            ).createShader(Rect.fromLTRB(0, 0, bounds.width, bounds.height));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.4,
              backgroundColor: Colors.grey.withValues(alpha: 0.4),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 255, 255, 255),
              ),
              minHeight: 10,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '40%',
            style: getSemiBoldStyle(
              color: AppColors.primary,
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRewardsSection() {
    return Column(
      children: [
        const SizedBox(height: 20),
        _RewardCard(
          title: 'المعززات المحققة',
          icon: Icons.emoji_events_outlined,
          iconColor: Colors.amber,
        ),
        const SizedBox(height: 12),
        _RewardCard(
          title: 'معزز إنجاز المهام',
          trailing: Text(
            '68 ر.س',
            style: getBoldStyle(
              color: AppColors.textSecondary,
              fontSize: FontSize.size16,
              fontFamily: FontConstant.cairo,
            ),
          ),
          icon: Icons.note_alt_outlined,
          iconColor: AppColors.textSecondary,
        ),
      ],
    );
  }
}

class _TaskCard extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? valueWidget;

  const _TaskCard({required this.label, this.value, this.valueWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          valueWidget ??
              Text(
                value!,
                style: getBoldStyle(
                  color: AppColors.textSecondary,
                  fontSize: FontSize.size24,
                  fontFamily: FontConstant.cairo,
                ),
              ),
          const SizedBox(height: 8),
          Text(
            label,
            style: getMediumStyle(
              color: AppColors.textSecondary,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final IconData icon;
  final Color iconColor;

  const _RewardCard({
    required this.title,
    this.trailing,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: getSemiBoldStyle(
                color: AppColors.textSecondary,
                fontSize: FontSize.size16,
                fontFamily: FontConstant.cairo,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
