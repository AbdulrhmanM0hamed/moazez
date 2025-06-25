import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moazez/core/utils/constant/app_assets.dart';
import 'package:moazez/feature/MyTasks/presentation/view/my_tasks_view.dart';
import 'package:moazez/feature/home_participant/presentation/widgets/home_participants_view_body.dart';
import 'package:moazez/feature/profile/presentation/view/account_view.dart';
import 'package:moazez/feature/auth/presentation/cubit/logout_cubit/logout_cubit.dart';
import 'package:moazez/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/team_cubit.dart';

class ParticipantsNavBar extends StatefulWidget {
  const ParticipantsNavBar({super.key});

  static const String routeName = '/participants-nav-bar';

  @override
  State<ParticipantsNavBar> createState() => _HomeViewState();
}

class _HomeViewState extends State<ParticipantsNavBar> {
  int _currentIndex = 0;

  late final List<Widget> _pages = [
    const HomeParticipantsViewBody(),
    const MyTasksView(),
    const AccountView(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<LogoutCubit>()),
        BlocProvider(create: (_) => sl<ProfileCubit>()..fetchProfile()),
        //    BlocProvider(create: (_) => sl<PackagesCubit>()..fetchPackages()),
        BlocProvider(create: (_) => sl<TeamCubit>()..fetchTeamInfo()),
      ],
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _pages),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) => setState(() => _currentIndex = index),
                type: BottomNavigationBarType.fixed,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                selectedItemColor: AppColors.primary,
                unselectedItemColor: Colors.grey,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                elevation: 0,
                items: [
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      AppAssets.homeOutlined,
                      width: 26,
                      colorFilter: const ColorFilter.mode(
                        Colors.grey,
                        BlendMode.srcIn,
                      ),
                    ),
                    activeIcon: SvgPicture.asset(
                      AppAssets.homeBold,
                      width: 28,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: 'الرئيسية',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      AppAssets.agreement,
                      width: 26,
                      colorFilter: const ColorFilter.mode(
                        Colors.grey,
                        BlendMode.srcIn,
                      ),
                    ),
                    activeIcon: SvgPicture.asset(
                      AppAssets.agreement,
                      width: 28,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: 'المهام',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      AppAssets.profileIcon,
                      width: 26,
                      colorFilter: const ColorFilter.mode(
                        Colors.grey,
                        BlendMode.srcIn,
                      ),
                    ),
                    activeIcon: SvgPicture.asset(
                      AppAssets.profileIcon,
                      width: 28,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: 'حساب',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
