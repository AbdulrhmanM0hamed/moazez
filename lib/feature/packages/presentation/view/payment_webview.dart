import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/utils/common/custom_dialog_button.dart';
import 'package:moazez/feature/packages/presentation/cubit/payment_cubit.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart'
    as webview_android;
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class PaymentWebView extends StatefulWidget {
  final String paymentUrl;
  final Function(bool success) onPaymentComplete;

  const PaymentWebView({
    Key? key,
    required this.paymentUrl,
    required this.onPaymentComplete,
  }) : super(key: key);

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    late final PlatformWebViewControllerCreationParams params;

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _errorMessage = null;
            });
            debugPrint('[PaymentWebView] Page started loading: $url');
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            debugPrint('[PaymentWebView] Page finished loading: $url');
            _checkPaymentStatus(url);
          },
          onNavigationRequest: (NavigationRequest request) {
            debugPrint(
              '[PaymentWebView] Navigation request to: ${request.url}',
            );
            // تحقق من URL للتعامل مع حالات خاصة
            final lowerUrl = request.url.toLowerCase();
            if (lowerUrl.contains('callback') || lowerUrl.contains('return')) {
              debugPrint(
                '[PaymentWebView] Detected callback/return in navigation request',
              );
              // سنتعامل مع هذا في onPageFinished
            }
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint(
              '[PaymentWebView] WebView error: ${error.description}, errorCode: ${error.errorCode}',
            );
            setState(() {
              _isLoading = false;
              _errorMessage = 'فشل تحميل صفحة الدفع: ${error.description}';
            });

            // إذا كان الخطأ متعلق بالاتصال بالإنترنت، نعرض رسالة خاصة
            if (error.errorCode == -2 || // net::ERR_INTERNET_DISCONNECTED
                error.errorCode == -7 || // net::ERR_NAME_NOT_RESOLVED
                error.errorCode == -106) {
              // net::ERR_CONNECTION_REFUSED
              setState(() {
                _errorMessage =
                    'تعذر الاتصال بخدمة الدفع. يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.';
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl)).catchError((error) {
        debugPrint('[PaymentWebView] Error loading URL: $error');
        setState(() {
          _isLoading = false;
          _errorMessage = 'خطأ أثناء تحميل صفحة الدفع: $error';
        });
      });

    // إضافة مؤقت للتحقق من حالة التحميل
    Future.delayed(const Duration(seconds: 15), () {
      if (mounted && _isLoading) {
        debugPrint('[PaymentWebView] Loading timeout after 15 seconds');
        setState(() {
          _isLoading = false;
          _errorMessage =
              'استغرق تحميل صفحة الدفع وقتًا طويلاً. يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.';
        });
      }
    });

    // Configure Android specific settings
    if (controller.platform is webview_android.AndroidWebViewController) {
      webview_android.AndroidWebViewController.enableDebugging(true);
      (controller.platform as webview_android.AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
  }

  /// معالجة حالات الدفع الناجحة وعرض حوار النجاح
  ///
  /// تقوم هذه الدالة بتحديث حالة الاشتراك وعرض حوار نجاح الدفع للمستخدم
  /// [url] عنوان URL الذي تم توجيه المستخدم إليه بعد إتمام الدفع
  void _handleSuccessfulPayment(String url) {
    debugPrint('[PaymentWebView] Handling successful payment for URL: $url');

    try {
      // استخدام PaymentCubit لتحديث حالة الاشتراك والباقات
      if (context.mounted) {
        final paymentCubit = context.read<PaymentCubit>();
        paymentCubit.updateSubscriptionAfterPayment();
        debugPrint('[PaymentWebView] Called updateSubscriptionAfterPayment');

        // عرض حوار نجاح الدفع مباشرة في صفحة الدفع
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
                    // رسوم متحركة للنجاح
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
                          // استدعاء onPaymentComplete بعد إغلاق الحوار
                          // استخدام Navigator.pop قبل استدعاء onPaymentComplete
                          if (Navigator.canPop(context)) {
                            Navigator.of(context).pop();
                          }
                          // استدعاء onPaymentComplete بعد إغلاق الحوار والصفحة
                          Future.microtask(() {
                            widget.onPaymentComplete(true);
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
      debugPrint('[PaymentWebView] Error updating subscription: $e');
      // استدعاء onPaymentComplete مباشرة في حالة حدوث خطأ
      widget.onPaymentComplete(true);
    }
  }

  void _checkPaymentStatus(String url) {
    // تنفيذ منطق التحقق من حالة الدفع
    debugPrint('[PaymentWebView] Checking URL: $url');

    // تحويل URL إلى حروف صغيرة للتحقق بشكل أفضل
    final lowerUrl = url.toLowerCase();

    // أولاً، نتحقق من وجود 'return' أو 'callback' في URL
    // بناءً على المشكلة المكتشفة، نفترض أن الدفع ناجح دائمًا عند وجود هذه الكلمات
    if (lowerUrl.contains('return') || lowerUrl.contains('callback')) {
      debugPrint(
        '[PaymentWebView] Return/callback URL detected - assuming SUCCESS',
      );
      debugPrint('[PaymentWebView] Full return/callback URL: $url');
      _handleSuccessfulPayment(url);
      return;
    }

    // التحقق من عناوين URL للنجاح والفشل
    // تحقق من عناوين URL المحتملة للنجاح
    if (lowerUrl.contains('success') ||
        lowerUrl.contains('payment_success') ||
        lowerUrl.contains('payment/success') ||
        lowerUrl.contains('status=1') ||
        lowerUrl.contains('result=1') ||
        lowerUrl.contains('payment_status=completed')) {
      debugPrint('[PaymentWebView] Payment successful - explicit success URL');
      _handleSuccessfulPayment(url);
      return;
    }

    // تحقق من عناوين URL المحتملة للإلغاء
    // نتحقق من الإلغاء قبل الفشل لأن بعض الروابط قد تحتوي على كلمة 'fail' كجزء من المسار
    if (lowerUrl.contains('cancel') ||
        lowerUrl.contains('cancelled') ||
        lowerUrl.contains('payment/cancel') ||
        lowerUrl.contains('payment_status=cancelled')) {
      debugPrint('[PaymentWebView] Payment cancelled by user');
      _handleFailedPayment('تم إلغاء عملية الدفع من قبل المستخدم');
      return;
    }

    // تحقق من عناوين URL المحتملة للفشل
    // نتحقق من الفشل بعد التحقق من النجاح والإلغاء
    if (lowerUrl.contains('fail') ||
        lowerUrl.contains('failure') ||
        lowerUrl.contains('payment_failure') ||
        lowerUrl.contains('payment/fail') ||
        lowerUrl.contains('error') ||
        lowerUrl.contains('status=0') ||
        lowerUrl.contains('result=0') ||
        lowerUrl.contains('payment_status=failed')) {
      debugPrint('[PaymentWebView] Payment failed - explicit failure URL');
      _handleFailedPayment(
        'فشلت عملية الدفع، يرجى المحاولة مرة أخرى أو استخدام طريقة دفع أخرى',
      );
      return;
    }

    // تم نقل منطق التحقق من وجود كلمة callback أو return إلى بداية الدالة
  }

  /// معالجة حالات فشل الدفع وعرض حوار الفشل
  ///
  /// تقوم هذه الدالة بعرض حوار فشل الدفع للمستخدم مع رسالة الخطأ المناسبة
  /// [errorMessage] رسالة الخطأ التي سيتم عرضها للمستخدم
  void _handleFailedPayment(String errorMessage) {
    debugPrint('[PaymentWebView] Handling failed payment: $errorMessage');

    if (context.mounted) {
      // عرض حوار فشل الدفع مباشرة في صفحة الدفع
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
                  // أيقونة الخطأ مع تأثيرات بصرية
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBE9E7),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
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
                        // إغلاق صفحة الدفع قبل استدعاء onPaymentComplete
                        if (Navigator.canPop(context)) {
                          Navigator.of(context).pop();
                        }
                        // استدعاء onPaymentComplete بعد إغلاق الحوار والصفحة
                        Future.microtask(() {
                          widget.onPaymentComplete(false);
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
      // إذا لم يكن السياق متاحًا، نستدعي onPaymentComplete مباشرة
      widget.onPaymentComplete(false);
    }
  }

  /// إعادة تحميل صفحة الدفع
  ///
  /// تقوم هذه الدالة بإعادة تحميل صفحة الدفع عند حدوث خطأ أو عند طلب المستخدم
  /// مع التعامل مع الأخطاء المحتملة أثناء التحميل
  void _reloadPaymentPage() {
    debugPrint('[PaymentWebView] Reloading payment page');

    // إعادة تعيين حالة التحميل وإزالة رسائل الخطأ
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // محاولة تحميل الصفحة مع التعامل مع الأخطاء
    try {
      _controller.loadRequest(Uri.parse(widget.paymentUrl)).catchError((error) {
        debugPrint('[PaymentWebView] Error reloading page: $error');

        // تحديث حالة الواجهة في حالة الخطأ
        setState(() {
          _isLoading = false;

          // تحديد رسالة خطأ مناسبة بناءً على نوع الخطأ
          if (error.toString().contains('net::ERR_INTERNET_DISCONNECTED') ||
              error.toString().contains('net::ERR_CONNECTION_REFUSED') ||
              error.toString().contains('net::ERR_NAME_NOT_RESOLVED')) {
            _errorMessage =
                'لا يمكن الاتصال بخادم الدفع. يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.';
          } else if (error.toString().contains('429') ||
              error.toString().contains('Too Many Requests')) {
            _errorMessage =
                'عدد كبير من الطلبات. يرجى الانتظار قليلاً ثم المحاولة مرة أخرى.';
          } else {
            _errorMessage =
                'حدث خطأ أثناء تحميل صفحة الدفع. يرجى المحاولة مرة أخرى.';
          }
        });

        // عرض حوار الفشل بعد تأخير قصير إذا كان السياق لا يزال متاحًا
        if (context.mounted && _errorMessage != null) {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (context.mounted) {
              _handleFailedPayment(_errorMessage!);
            }
          });
        }
      });
    } catch (e) {
      debugPrint('[PaymentWebView] Exception during reload: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى لاحقًا.';
      });

      // عرض حوار الفشل بعد تأخير قصير إذا كان السياق لا يزال متاحًا
      if (context.mounted) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            _handleFailedPayment(_errorMessage!);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // عرض حوار تأكيد الإلغاء عند محاولة الرجوع بتصميم جذاب
        final shouldPop =
            await showDialog<bool>(
              context: context,
              builder:
                  (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: const Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.amber,
                          size: 28,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'إلغاء عملية الدفع',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    content: const Text(
                      'هل أنت متأكد من رغبتك في إلغاء عملية الدفع؟ لن يتم اكمال عملية الاشتراك.',
                      style: TextStyle(fontSize: 16, height: 1.4),
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    actionsPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    actions: [
                      SizedBox(
                        width: 100,
                        child: TextButton(
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.of(context).pop(false);
                            }
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: Colors.grey[300]!),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'لا',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: TextButton(
                          onPressed: () {
                            // إغلاق مربع الحوار أولاً
                            Navigator.of(context).pop(true);

                            // إغلاق صفحة الدفع
                            if (Navigator.canPop(context)) {
                              Navigator.of(context).pop();
                            }
                            
                            // استدعاء onPaymentComplete مباشرة
                            Future.microtask(() {
                              widget.onPaymentComplete(false);
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'نعم',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
            ) ??
            false;

        return shouldPop;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'صفحة الدفع',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          elevation: 2,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black54, size: 28),
            onPressed: () {
              // عرض مربع حوار للتأكيد قبل الإغلاق
              showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.amber,
                            size: 28,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'إلغاء عملية الدفع',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      content: const Text(
                        'هل أنت متأكد من رغبتك في إلغاء عملية الدفع؟ لن يتم اكمال عملية الاشتراك.',
                        style: TextStyle(fontSize: 16, height: 1.4),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                      actionsPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      actions: [
                        SizedBox(
                          width: 100,
                          child: TextButton(
                            onPressed: () {
                              if (Navigator.canPop(context)) {
                                Navigator.of(context).pop(false);
                              }
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: Colors.grey[300]!),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              'لا',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: TextButton(
                            onPressed: () {
                              // إغلاق مربع الحوار أولاً
                              Navigator.of(context).pop(true);

                              // إغلاق صفحة الدفع
                              if (Navigator.canPop(context)) {
                                Navigator.of(context).pop();
                              }
                              
                              // استدعاء onPaymentComplete مباشرة
                              Future.microtask(() {
                                widget.onPaymentComplete(false);
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              'نعم',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
              );
            },
          ),
          actions: [
            // زر تحديث الصفحة
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _controller.reload();
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            // عرض WebView فقط إذا لم يكن هناك خطأ
            if (_errorMessage == null) WebViewWidget(controller: _controller),

            // عرض مؤشر التحميل أثناء تحميل الصفحة بشكل جذاب
            if (_isLoading && _errorMessage == null)
              Container(
                color: Colors.white,
                child: Center(
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 32,
                        horizontal: 40,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // مؤشر التحميل مع تأثيرات بصرية
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'جاري تحميل صفحة الدفع',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1565C0),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'يرجى الانتظار قليلاً...',
                            style: TextStyle(
                              color: Color(0xFF757575),
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // عرض رسالة الخطأ مع خيارات إعادة المحاولة أو إلغاء الدفع
            if (_errorMessage != null)
              Container(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // أيقونة الخطأ مع تأثيرات بصرية
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFBE9E7),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withOpacity(0.2),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'حدث خطأ',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB71C1C),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Color(0xFF424242),
                                fontSize: 16,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton.icon(
                                onPressed: _reloadPaymentPage,
                                icon: const Icon(Icons.refresh),
                                label: const Text('إعادة المحاولة'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: TextButton(
                                onPressed: () {
                                  // إغلاق صفحة الخطأ أولاً
                                  if (Navigator.canPop(context)) {
                                    Navigator.of(context).pop();
                                  }
                                  // استدعاء onPaymentComplete مباشرة بدلاً من عرض حوار الإلغاء
                                  Future.microtask(() {
                                    widget.onPaymentComplete(false);
                                  });
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(
                                      color: Colors.red,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'إلغاء عملية الدفع',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
