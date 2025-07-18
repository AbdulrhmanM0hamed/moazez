import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/utils/common/custom_dialog_button.dart';
import 'package:moazez/feature/packages/presentation/cubit/payment_cubit.dart';

class PaymentStatusHandler {
  final BuildContext context;
  final Function(bool) onPaymentComplete;

  PaymentStatusHandler({
    required this.context,
    required this.onPaymentComplete,
  });

  void checkPaymentStatus(String url) {
    final lowerUrl = url.toLowerCase();

    if (lowerUrl.contains('return') || lowerUrl.contains('callback')) {
      handleSuccessfulPayment(url);
      return;
    }

    if (lowerUrl.contains('success') ||
        lowerUrl.contains('payment_success') ||
        lowerUrl.contains('payment/success') ||
        lowerUrl.contains('status=1') ||
        lowerUrl.contains('result=1') ||
        lowerUrl.contains('payment_status=completed')) {
      handleSuccessfulPayment(url);
      return;
    }

    if (lowerUrl.contains('cancel') ||
        lowerUrl.contains('cancelled') ||
        lowerUrl.contains('payment/cancel') ||
        lowerUrl.contains('payment_status=cancelled')) {
      handleFailedPayment('تم إلغاء عملية الدفع من قبل المستخدم');
      return;
    }

    if (lowerUrl.contains('fail') ||
        lowerUrl.contains('failure') ||
        lowerUrl.contains('payment_failure') ||
        lowerUrl.contains('payment/fail') ||
        lowerUrl.contains('error') ||
        lowerUrl.contains('status=0') ||
        lowerUrl.contains('result=0') ||
        lowerUrl.contains('payment_status=failed')) {
      handleFailedPayment(
          'فشلت عملية الدفع، يرجى المحاولة مرة أخرى أو استخدام طريقة دفع أخرى');
      return;
    }
  }

  void handleSuccessfulPayment(String url) {
    try {
      if (context.mounted) {
        final paymentCubit = context.read<PaymentCubit>();
        paymentCubit.updateSubscriptionAfterPayment();

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 60,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'تمت العملية بنجاح',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'تم إتمام عملية الدفع بنجاح وتفعيل اشتراكك في الباقة.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF424242),
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: CustomDialogButton(
                        text: 'تم',
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          if (Navigator.canPop(context)) {
                            Navigator.of(context).pop();
                          }
                          Future.microtask(() {
                            onPaymentComplete(true);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    } catch (e) {
      onPaymentComplete(true);
    }
  }

  void handleFailedPayment(String errorMessage) {
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBE9E7),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withValues(alpha: 0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'فشلت العملية',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB71C1C),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      errorMessage,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF424242),
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        if (Navigator.canPop(context)) {
                          Navigator.of(context).pop();
                        }
                        Future.microtask(() {
                          onPaymentComplete(false);
                        });
                      },
                      child: const Text(
                        'إغلاق',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      onPaymentComplete(false);
    }
  }
}
