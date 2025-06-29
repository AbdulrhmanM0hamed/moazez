import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  const CustomTextField({
    Key? key,
    this.hint,
    this.maxLines,
    this.onChanged,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: maxLines ?? 1,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
