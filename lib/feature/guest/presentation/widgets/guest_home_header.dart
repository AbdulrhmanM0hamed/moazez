import 'package:flutter/material.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';

class GuestHomeHeader extends StatelessWidget {
  const GuestHomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 8),
      child: Row(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: SvgPicture.asset(
                  'assets/images/defualt_avatar.svg',
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'مرحبا بك',
                style: getBoldStyle(
                  color: AppColors.white,
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size20,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Guest invitation button
          Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: () {
                  // Show a message for guest users
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('هذه الميزة متاحة للمستخدمين المسجلين فقط')),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.info.withValues(alpha: 0.2),
                    border: Border.all(
                      color: AppColors.info.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "دعوات الانضمام",
                        style: getMediumStyle(
                          color: Colors.white,
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SvgPicture.asset(
                        'assets/images/request.svg',
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}