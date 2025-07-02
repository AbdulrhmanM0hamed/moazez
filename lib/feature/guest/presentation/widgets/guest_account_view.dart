import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moazez/core/utils/common/custom_app_bar.dart';
import 'package:moazez/core/utils/common/custom_button.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GuestAccountView extends StatelessWidget {
  const GuestAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // إغلاق التطبيق عند الضغط على زر الرجوع من الصفحة الرئيسية
        await SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: 'حسابي (زائر)',
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildProfileHeader(context),
              const SizedBox(height: 24),
              _buildInfoCard(context),
              const SizedBox(height: 16),
              _buildMenuItemsCard(context),
              const SizedBox(height: 24),
              _buildLoginButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: SvgPicture.asset(
                'assets/images/defualt_avatar.svg',
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'زائر',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'تجربة الوضع الزائر',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'معلومات الحساب',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInfoItem(context, 'الاسم', 'زائر'),
            _buildInfoItem(context, 'البريد الإلكتروني', 'غير مسجل'),
            _buildInfoItem(context, 'رقم الهاتف', 'غير مسجل'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItemsCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الإعدادات',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildMenuItem(context, Icons.settings, 'إعدادات الحساب', 'غير متاح في وضع الزائر'),
            _buildMenuItem(context, Icons.notifications, 'الإشعارات', 'غير متاح في وضع الزائر'),
            _buildMenuItem(context, Icons.help, 'المساعدة والدعم', 'غير متاح في وضع الزائر'),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey)),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('هذه الميزة غير متاحة في وضع الزائر')),
        );
      },
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return CustomButton(
      text: 'تسجيل الدخول',
      onPressed: () {
        // Navigate to login screen
        Navigator.of(context).pushReplacementNamed('/login');
      },
    );
  }
}
