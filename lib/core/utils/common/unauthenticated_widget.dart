import 'package:flutter/material.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/feature/auth/presentation/pages/login_view.dart';

class UnauthenticatedWidget extends StatelessWidget {
  const UnauthenticatedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'يجب إعادة تسجيل الدخول',
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size20,
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'تم تسجيل خروجك تلقائياً لأنك قمت بتسجيل الدخول على جهاز آخر',
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await sl<CacheService>().clearCache();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      LoginView.routeName,
                      (route) => false,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'تسجيل الدخول',
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size16,
                    color: Colors.white,
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