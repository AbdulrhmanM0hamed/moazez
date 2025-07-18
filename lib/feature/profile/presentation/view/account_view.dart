import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/common/custom_app_bar.dart';
import 'package:moazez/core/utils/common/unauthenticated_widget.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/auth/presentation/cubit/logout_cubit/logout_cubit.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/team_cubit.dart';
import 'package:moazez/feature/profile/data/models/profile_model.dart';
import 'package:moazez/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:moazez/feature/profile/presentation/widgets/info_card.dart';
import 'package:moazez/feature/profile/presentation/widgets/logout_listener.dart';
import 'package:moazez/feature/profile/presentation/widgets/menu_items_card.dart';
import 'package:moazez/feature/profile/presentation/widgets/profile_header.dart';
import 'package:moazez/feature/profile/presentation/widgets/profile_shimmer.dart';
import 'package:moazez/feature/profile/presentation/widgets/role_switcher.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<LogoutCubit>()),
        BlocProvider(create: (context) => sl<ProfileCubit>()..fetchProfile()),
        BlocProvider(create: (context) => sl<TeamCubit>()..fetchTeamInfo()),
      ],
      child: const _AccountViewBody(),
    );
  }
}

class _AccountViewBody extends StatelessWidget {
  const _AccountViewBody();

  @override
  Widget build(BuildContext context) {
    return LogoutListener(
      child: WillPopScope(
        onWillPop: () async {
          // إغلاق التطبيق عند الضغط على زر الرجوع من الصفحة الرئيسية
          await SystemNavigator.pop();
          return false;
        },
        child: Scaffold(
          appBar: CustomAppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            title: 'حسابي',
            centerTitle: true,
          ),
          body: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileError) {
                if (state.message.contains('Unauthenticated.')) {
                  return const UnauthenticatedWidget();
                }
              }
              if (state is ProfileLoading) {
                return const ProfileShimmer();
              } else if (state is ProfileLoaded) {
                return _buildProfileContent(
                  context,
                  state.profileResponse.data.user,
                );
              } else if (state is ProfileError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.message,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed:
                            () => context.read<ProfileCubit>().fetchProfile(),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserProfile user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ProfileHeader(user: user),
          const SizedBox(height: 24),
          const RoleSwitcher(),
          const SizedBox(height: 24),
          InfoCard(user: user),
          const SizedBox(height: 16),
          const MenuItemsCard(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
