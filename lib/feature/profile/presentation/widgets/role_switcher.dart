import 'package:flutter/material.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/splash/presentation/splash_view.dart';

class RoleSwitcher extends StatefulWidget {
  const RoleSwitcher({super.key});

  @override
  State<RoleSwitcher> createState() => _RoleSwitcherState();
}

class _RoleSwitcherState extends State<RoleSwitcher> {
  int _selectedRoleIndex = 0; // 0 for Participant, 1 for Supporter
  final CacheService _cacheService = sl<CacheService>();

  @override
  void initState() {
    super.initState();
    _loadSavedRole();
  }

  Future<void> _loadSavedRole() async {
    String? savedRole = await _cacheService.getUserRole();
    if (savedRole != null) {
      setState(() {
        _selectedRoleIndex = savedRole == 'Supporter' ? 1 : 0;
      });
    }
  }

  Future<void> _handleRoleSwitch(int index) async {
    String role = index == 0 ? 'Participant' : 'Supporter';
    await _cacheService.saveUserRole(role);
    setState(() {
      _selectedRoleIndex = index;
    });
    // Navigate to splash screen to restart app flow based on role
    Navigator.of(context).pushReplacementNamed(SplashView.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: ToggleButtons(
        isSelected: [_selectedRoleIndex == 0, _selectedRoleIndex == 1],
        onPressed: (index) => _handleRoleSwitch(index),
        borderRadius: BorderRadius.circular(30),
        selectedColor: Colors.white,
      
        fillColor: AppColors.primary,
        splashColor: AppColors.primary.withOpacity(0.12),
        hoverColor: AppColors.primary.withOpacity(0.04),
        renderBorder: false,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 12.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.person_outline, size: 20),
                SizedBox(width: 8),
                Text('مشارك', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 12.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.verified_user_outlined, size: 20),
                SizedBox(width: 8),
                Text('داعم', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
