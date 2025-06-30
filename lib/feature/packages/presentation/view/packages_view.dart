import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';
import 'package:moazez/core/utils/common/custom_app_bar.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/core/utils/widgets/custom_snackbar.dart';
import 'package:moazez/feature/packages/presentation/cubit/subscription_cubit.dart';
import 'package:moazez/feature/packages/presentation/cubit/subscription_state.dart';
import 'package:moazez/feature/packages/presentation/widgets/subscription_card.dart';
import 'package:moazez/feature/packages/presentation/cubit/package_cubit.dart';
import 'package:moazez/feature/packages/presentation/cubit/package_state.dart';
import 'package:moazez/feature/packages/presentation/widgets/packages_grid.dart';
import 'package:moazez/feature/packages/presentation/cubit/payment_cubit.dart';
import 'package:moazez/feature/packages/presentation/cubit/payment_state.dart';
import 'package:moazez/feature/packages/presentation/view/payment_webview.dart';

class PackagesView extends StatelessWidget {
  static const String routeName = '/packages';

  const PackagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PackageCubit>(
          create: (context) => sl<PackageCubit>()..getPackages(),
        ),
        BlocProvider<SubscriptionCubit>(
          create:
              (context) => sl<SubscriptionCubit>()..fetchCurrentSubscription(),
        ),
        BlocProvider<PaymentCubit>(
          create: (context) {
            final paymentCubit = sl<PaymentCubit>();
            // تعيين مراجع للكيوبت الأخرى لتحديث الحالة بعد الدفع الناجح
            Future.delayed(Duration.zero, () {
              paymentCubit.setSubscriptionCubit(
                context.read<SubscriptionCubit>(),
              );
              paymentCubit.setPackageCubit(context.read<PackageCubit>());
            });
            return paymentCubit;
          },
        ),
      ],
      child: Scaffold(
        appBar: CustomAppBar(title: 'الباقات'),
        body: BlocListener<PaymentCubit, PaymentState>(
          listener: (context, paymentState) {
            if (paymentState is PaymentSuccess) {
              // عرض رسالة للمستخدم قبل فتح صفحة الدفع
              CustomSnackbar.showSuccess(
                context: context,
                message: 'جارٍ تحويلك إلى صفحة الدفع...',
              );

              // تأخير قصير قبل فتح صفحة الدفع
              Future.delayed(const Duration(seconds: 1), () {
                final paymentCubit = context.read<PaymentCubit>();
                final scaffoldMessengerState = ScaffoldMessenger.of(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => BlocProvider.value(
                          value: paymentCubit,
                          child: PaymentWebView(
                            paymentUrl: paymentState.paymentUrl,
                            onPaymentComplete: (bool success) {
                              // استخدام Future.microtask لتأجيل العمليات حتى يتم إكمال بناء الشاشة الحالية
                              Future.microtask(() {
                                // إغلاق شاشة WebView أولاً
                                if (Navigator.canPop(context)) {
                                  Navigator.of(context).pop();
                                }

                                // عرض تعليقات باستخدام ScaffoldMessengerState المحفوظ
                                scaffoldMessengerState
                                    .clearSnackBars(); // إزالة أي snackbars سابقة
                                CustomSnackbar.showSuccess(
                                  context: context,
                                  message:
                                      success
                                          ? 'تمت عملية الدفع بنجاح! جارٍ تحديث اشتراكك...'
                                          : 'فشلت عملية الدفع، يرجى المحاولة مرة أخرى لاحقًا',
                                );

                                // تحديث الاشتراك الحالي بعد الدفع الناجح
                                if (success) {
                                  // استخدام الدالة الجديدة لتحديث الاشتراك والباقات
                                  paymentCubit.updateSubscriptionAfterPayment();
                                }
                              });
                            },
                          ),
                        ),
                  ),
                );
              });
            } else if (paymentState is PaymentError) {
              debugPrint(
                '[PackagesView] Payment error: ${paymentState.message}',
              );

              // تحقق مما إذا كانت رسالة الخطأ تتعلق بتجاوز عدد المحاولات
              final bool isTooManyRequests =
                  paymentState.message.contains(
                    'لقد قمت بالعديد من المحاولات',
                  ) ||
                  paymentState.message.contains('تجاوز الحد المسموح');

              // إنشاء رسالة خطأ أكثر وضوحًا للمستخدم
              final String userMessage =
                  isTooManyRequests
                      ? 'لقد قمت بالعديد من محاولات الدفع. يرجى الانتظار لمدة 5 دقائق قبل المحاولة مرة أخرى.'
                      : paymentState.message;

              CustomSnackbar.showError(context: context, message: userMessage);

              // إذا كان الخطأ بسبب تجاوز عدد المحاولات، يمكن إضافة تأخير قبل السماح بمحاولة جديدة
              if (isTooManyRequests) {
                // يمكن هنا تعطيل زر الدفع مؤقتًا أو إضافة منطق آخر إذا لزم الأمر
              }
            } else if (paymentState is PaymentLoading) {
              // يمكن إضافة مؤشر تحميل هنا إذا لزم الأمر
            }
          },
          child: BlocBuilder<PackageCubit, PackageState>(
            builder: (context, state) {
              return Column(
                children: [
                  // Adding SubscriptionCard at the top of the page
                  BlocBuilder<SubscriptionCubit, SubscriptionState>(
                    builder: (context, subState) {
                      if (subState is SubscriptionLoading) {
                        return const Center(child: CustomProgressIndcator());
                      } else if (subState is SubscriptionLoaded) {
                        return SubscriptionCard(
                          subscription: subState.subscription,
                        );
                      } else if (subState is SubscriptionError) {
                        print(subState.message);
                        return Center(child: Text(subState.message));
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  Expanded(
                    child: BlocBuilder<PackageCubit, PackageState>(
                      builder: (context, state) {
                        if (state is PackageLoading) {
                          return const Center(child: CustomProgressIndcator());
                        } else if (state is PackageLoaded) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: PackagesGrid(packages: state.packages),
                          );
                        } else if (state is PackageError) {
                          print(state.message);
                          return Center(
                            child: Text(
                              state.message,
                              style: const TextStyle(color: AppColors.error),
                            ),
                          );
                        } else {
                          return const Center(child: Text('ابدأ بجلب الباقات'));
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
