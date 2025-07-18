import 'package:flutter/material.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import '../theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final Widget? prefix;
  final Widget? suffix;
  final IconData? icon;
  final Color? borderColor;
  final double? elevation;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor = AppColors.primary,
    this.textColor = Colors.white,
    this.width,
    this.height,
    this.prefix,
    this.suffix,
    this.icon,
    this.borderColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 55,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [backgroundColor!.withValues(alpha: 0.9), backgroundColor!],
        ),
        borderRadius: BorderRadius.circular(16),
        border: borderColor != null ? Border.all(color: borderColor!) : null,
      ),
      child: MaterialButton(
        onPressed: isLoading ? null : onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: elevation ?? 2,
        child: _buildButtonChild(),
      ),
    );
  }

  Widget _buildButtonChild() {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (prefix != null) prefix!,
        if (icon != null) ...[  
          Icon(icon, color: textColor, size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size18,
            color: textColor,
          ),
        ),
        if (suffix != null) suffix!,
      ],
    );
  }
}
