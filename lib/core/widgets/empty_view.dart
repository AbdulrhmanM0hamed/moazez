import 'package:flutter/material.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    required this.imagePath,
    required this.message,
    this.imageWidth = 350,
  });

  final String imagePath;
  final String message;
  final double imageWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: imageWidth,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                color: AppColors.border,
                fontSize: FontSize.size16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
