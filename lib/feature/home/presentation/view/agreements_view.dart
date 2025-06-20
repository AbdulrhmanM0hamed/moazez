import 'package:flutter/material.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';

class AgreementsView extends StatelessWidget {
  const AgreementsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('اتفاقياتى'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'قائمة اتفاقياتى',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
