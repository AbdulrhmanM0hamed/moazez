import 'package:flutter/material.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moazez/core/utils/constant/app_assets.dart';
import 'package:moazez/feature/home/presentation/widgets/home_view_body.dart';
import 'package:moazez/feature/home/presentation/view/agreements_view.dart';
import 'package:moazez/feature/home/presentation/view/account_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  static const String routeName = '/home';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  late final List<Widget> _pages = [
    const HomeViewBody(),
    const AgreementsView(),
    const AccountView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
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
            showUnselectedLabels: false,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppAssets.home_outlined,
                  width: 26,
                  colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                ),
                activeIcon: SvgPicture.asset(
                  AppAssets.home_bold,
                  width: 26,
                  colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                ),
                label: 'الرئيسية',
              ),
              BottomNavigationBarItem(
               icon: SvgPicture.asset(
                  AppAssets.agreement,
                  width: 26,
                  colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                ),
                activeIcon: SvgPicture.asset(
                  AppAssets.agreement,
                  width: 26,
                  colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                ),
                label: 'اتفاقياتى',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppAssets.profileIcon,
                  width: 26,
                  colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                ),
                activeIcon: SvgPicture.asset(
                  AppAssets.profileIcon,
                  width: 26,
                  colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                ),
                label: 'حساب',
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
