import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/auth/presentation/cubit/logout_cubit/logout_cubit.dart';
import 'package:moazez/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:moazez/feature/profile/presentation/view/edit_profile_info_view.dart';

class MenuItemsCard extends StatelessWidget {
  const MenuItemsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            context,
            'تعديل الملف الشخصي',
            Icons.edit_outlined,
            () {
              // TODO: Navigate to edit profile screen
              final profileCubit = context.read<ProfileCubit>();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => BlocProvider.value(
                        value: profileCubit,
                        child: const EditProfileInfo(),
                      ),
                ),
              );
            },
          ),
          
          _buildMenuItem(
            context,
            'فريقي',
            Icons.group_outlined,
            () {
              Navigator.pushNamed(context, '/team');
            },
          ),

          _buildMenuItem(
            context,
            'مكافآتك',
            Icons.card_giftcard_outlined,
            () {},
          ),
          _buildMenuItem(context, 'الإعدادات', Icons.settings_outlined, () {}),
          _buildMenuItem(context, 'الدعم والمساعدة', Icons.help_outline, () {}),
          _buildMenuItem(context, 'تسجيل الخروج', Icons.logout, () {
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: const Text(
                    'تأكيد تسجيل الخروج',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: const Text(
                    'هل أنت متأكد أنك تريد تسجيل الخروج؟',
                    textAlign: TextAlign.center,
                  ),
                  actionsAlignment: MainAxisAlignment.center,
                  actions: <Widget>[
                    TextButton(
                      child: const Text(
                        'إلغاء',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      onPressed: () {
                        Navigator.of(dialogContext).pop(); // Close the dialog
                      },
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'تأكيد',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(dialogContext).pop(); // Close the dialog
                        context.read<LogoutCubit>().logout(); // Perform logout
                      },
                    ),
                  ],
                );
              },
            );
          }, isLogout: true),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isLogout = false,
  }) {
    final color = isLogout ? AppColors.error : AppColors.textPrimary;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
      trailing:
          isLogout
              ? null
              : const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textSecondary,
              ),
      onTap: onTap,
    );
  }
}
