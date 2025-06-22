import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/constant/app_assets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/profile/presentation/cubit/profile_cubit.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 8),
      child: Row(
        children: [
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded) {
                final user = state.profileResponse.data.user;
                return Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child:
                          user.avatarUrl != null && user.avatarUrl != ''
                              ? Image.network(
                                user.avatarUrl!,
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                              )
                              : Image.asset(
                                'assets/images/avatar.jpg',
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                              ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'هلا ${user.name}',
                      style: getBoldStyle(
                        color: AppColors.white,
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size20,
                      ),
                    ),
                  ],
                );
              } else if (state is ProfileLoading) {
                return Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Container(
                        width: 56,
                        height: 56,
                        color: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(width: 80, height: 18, color: Colors.grey[300]),
                  ],
                );
              } else {
                return Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Image.asset(
                        'assets/images/avatar.jpg',
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'مرحبا',
                      style: getBoldStyle(
                        color: AppColors.white,
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size20,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          const Spacer(),
          // Notification icon with badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              SvgPicture.asset(
                AppAssets.notificationIcon,
                width: 28,
                height: 28,
                colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
              ),
              Positioned(
                top: -4,
                right: 2,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
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
