import 'package:flutter/material.dart';
import 'package:moazez/core/utils/common/cached_network_image.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/profile/data/models/profile_model.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomCachedNetworkImage(
          imageUrl: user.avatarUrl ?? '',
          width: 100,
          height: 100,
          borderRadius: BorderRadius.circular(50),
          placeholder: const CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.border,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          errorWidget: const CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.border,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.name,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
