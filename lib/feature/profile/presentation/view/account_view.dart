import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/auth/presentation/cubit/logout_cubit/logout_cubit.dart';
import 'package:moazez/feature/profile/presentation/widgets/logout_listener.dart';
import 'package:moazez/feature/profile/presentation/widgets/profile_header_card.dart';
import 'package:moazez/feature/profile/presentation/widgets/profile_menu_item.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LogoutCubit>(),
      child: const _AccountViewBody(),
    );
  }
}

class _AccountViewBody extends StatelessWidget {
  const _AccountViewBody();

  @override
  Widget build(BuildContext context) {
    return LogoutListener(
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: AppColors.scaffoldBackground,
          elevation: 0,
          title: Text(
            'حسابي',
            style: getBoldStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontFamily: FontConstant.cairo,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const ProfileHeaderCard(
                name: 'عبدالرحمن محمد',
                email: 'a.mohamed@example.com',
              ),
              const SizedBox(height: 24),
              _buildMenuItems(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ProfileMenuItem(
            title: 'الملف الشخصي',
            icon: Icons.person_outline,
            onTap: () {},
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ProfileMenuItem(
            title: 'مكافآتك',
            icon: Icons.card_giftcard_outlined,
            onTap: () {},
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ProfileMenuItem(
            title: 'الإعدادات',
            icon: Icons.settings_outlined,
            onTap: () {},
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ProfileMenuItem(
            title: 'الدعم والمساعدة',
            icon: Icons.help_outline,
            onTap: () {},
          ),
          const SizedBox(height: 16),
          ProfileMenuItem(
            title: 'تسجيل الخروج',
            icon: Icons.logout,
            isLogout: true,
            onTap: () {
              context.read<LogoutCubit>().logout();
            },
          ),
        ],
      ),
    );
  }
}
