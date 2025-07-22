import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/utils/common/custom_button.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/packages/domain/entities/package_entity.dart';
import 'package:moazez/feature/packages/presentation/cubit/payment_cubit.dart';
import 'package:moazez/feature/packages/presentation/cubit/payment_state.dart';

class PackageCard extends StatelessWidget {
  final PackageEntity package;
  final VoidCallback? onTap;

  const PackageCard({super.key, required this.package, this.onTap});

  Color get _primaryColor {
    if (package.name.contains('الأساسية'))
      return AppColors.primary; // Primary color for Basic
    if (package.name.contains('المتقدمة'))
      return AppColors.secondary; // Secondary color for Advanced
    if (package.name.contains('الاحترافية'))
      return AppColors.third; // Third color for Professional
    return AppColors.primary;
  }

  Color get _secondaryColor {
    if (package.name.contains('الأساسية'))
      return AppColors.primary.withValues(
        alpha: 0.8,
      ); // Slightly darker Primary for Basic
    if (package.name.contains('المتقدمة'))
      return AppColors.secondary.withValues(
        alpha: 0.8,
      ); // Slightly darker Secondary for Advanced
    if (package.name.contains('الاحترافية'))
      return AppColors.third.withValues(
        alpha: 0.8,
      ); // Slightly darker Third for Professional
    return AppColors.secondary;
  }

  Icon _getIcon(String type) {
    switch (type) {
      case 'price':
        return Icon(Icons.attach_money, color: _primaryColor, size: 24);
      case 'tasks':
        return Icon(Icons.task_alt, color: _primaryColor, size: 24);
      case 'members':
        return Icon(Icons.group, color: _primaryColor, size: 24);
      case 'stages':
        return Icon(Icons.layers, color: _primaryColor, size: 24);
      default:
        return Icon(Icons.check, color: _primaryColor, size: 20);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Debug log
    // ignore: avoid_print
    print(
      " [PackageCard] displaying package: ${package.name}, isTrial: ${package.isTrial}",
    );
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      elevation: 8,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: _primaryColor.withValues(alpha: 0.25),
          width: 1.3,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // Header with gradient
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryColor, _secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  package.name,
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // Price, Tasks, Members section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),

              child: Column(
                children: [
                  Row(
                    children: [
                      _buildInfoItem('price', 'السعر', package.priceFormatted),
                      _verticalDivider(),
                      _buildInfoItem(
                        'tasks',
                        'المهام',
                        package.maxTasks.toString(),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      _buildInfoItem('members', 'الأعضاء', "غير محدود"),
                      _verticalDivider(),
                      _buildInfoItem(
                        'stages',
                        'المراحل لكل مهمة',
                        package.maxStagesPerTask != null
                            ? package.maxStagesPerTask.toString()
                            : 'غير محدد',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Features

            // Button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: BlocBuilder<PaymentCubit, PaymentState>(
                builder: (context, paymentState) {
                  final isLoading = paymentState is PaymentLoading;
                  
                  // التحقق من وجود خطأ 429 (Too Many Requests)
                  // استخدام الدالة الجديدة للتحقق من حالة تقييد المعدل
                  final paymentCubit = context.read<PaymentCubit>();
                  final bool isTooManyRequests = paymentCubit.isRateLimited;
                  
                  // تحديد نص الزر بناءً على حالة الدفع
                  String buttonText = package.isTrial ? 'ابدأ مجانا' : 'اشترك الآن';
                  if (isLoading) {
                    buttonText = 'جارٍ المعالجة...';
                  } else if (isTooManyRequests) {
                    // حساب الوقت المتبقي بالدقائق
                    final remainingMinutes = (paymentCubit.remainingCooldownSeconds / 60).ceil();
                    buttonText = 'يرجى الانتظار ($remainingMinutes دقائق)';
                  }
                  
                  return Column(
                    children: [
                      // إذا كان هناك خطأ، نعرض رسالة صغيرة فوق الزر
                      if (isTooManyRequests)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            children: [
                              Text(
                                'تم تجاوز الحد المسموح به من المحاولات',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontFamily: FontConstant.cairo,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'يرجى الانتظار لمدة ${(paymentCubit.remainingCooldownSeconds / 60).ceil()} دقائق قبل المحاولة مرة أخرى',
                                style: TextStyle(
                                  color: Colors.red[700],
                                  fontSize: 11,
                                  fontFamily: FontConstant.cairo,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: CustomButton(
                          onPressed: (isLoading || isTooManyRequests)
                              ? null
                              : onTap ??
                                  () {
                                    // عرض مؤشر تحميل قبل بدء عملية الدفع
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('جارٍ تجهيز عملية الدفع...'),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                    
                                    // تسجيل معلومات الباقة في سجل التصحيح
                               //     debugPrint('[PackageCard] Initiating payment for package: ${package.id} (${package.name})');
                                    
                                    // بدء عملية الدفع
                                    context
                                        .read<PaymentCubit>()
                                        .initiatePayment(package.id);
                                  },
                          text: buttonText,
                          backgroundColor: isTooManyRequests 
                              ? Colors.grey[400] 
                              : _primaryColor,
                          isLoading: isLoading,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String type, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          _getIcon(type),
          const SizedBox(height: 2),
          Text(label, style: getSemiBoldStyle(fontFamily: FontConstant.cairo)),
          const SizedBox(height: 6),
          Text(
            value,
            style: getSemiBoldStyle(
              fontSize: 14,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() => Container(
    height: 60,
    width: 1,
    color: Colors.grey.withValues(alpha: 0.3),
    margin: const EdgeInsets.symmetric(horizontal: 6),
  );
}
