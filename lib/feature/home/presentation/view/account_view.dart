import 'package:flutter/material.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('حسابى'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'صفحة الحساب',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
