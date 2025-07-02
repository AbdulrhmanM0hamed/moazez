import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/guest/presentation/widgets/guest_packages_view.dart';

class GuestSupporterViewBody extends StatefulWidget {
  const GuestSupporterViewBody({super.key});

  @override
  State<GuestSupporterViewBody> createState() => _GuestSupporterViewBodyState();
}

class _GuestSupporterViewBodyState extends State<GuestSupporterViewBody> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // إغلاق التطبيق عند الضغط على زر الرجوع من الصفحة الرئيسية
        await SystemNavigator.pop();
        return false;
      },
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          // No action needed for guest mode refresh
          await Future.delayed(const Duration(milliseconds: 1500));
        },
        child: Stack(
          children: [
            // استخدام العرض الجديد للباقات للزائر
            const GuestPackagesView(),
            
            // زر الإضافة في الأسفل
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColors.primary,
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.white, size: 32),
                      onPressed: () {
                        // No action for guest mode
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('هذه ميزة للمستخدمين المسجلين فقط')),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
