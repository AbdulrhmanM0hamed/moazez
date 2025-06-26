import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/auth/presentation/pages/terms_and_privacy_view.dart';

class TermsAndConditionsWidget extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const TermsAndConditionsWidget({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: 'من خلال إنشاء حساب، فإنك توافق على ',
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: AppColors.textSecondary,
              ),
              children: [
                TextSpan(
                  text: 'الشروط والأحكام الخاصة بنا',
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size14,
                    color: AppColors.primary,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushNamed(
                        context,
                        TermsAndPrivacyView.routeName,
                      );
                    },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
