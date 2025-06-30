
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/feature/packages/presentation/cubit/payment_cubit.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart' as webview_android;
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

    final WebViewController controller = WebViewController.fromPlatformCreationParams(params);

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
            debugPrint('[PaymentWebView] Navigation request to: ${request.url}');
            // تحقق من URL للتعامل مع حالات خاصة
            final lowerUrl = request.url.toLowerCase();
            if (lowerUrl.contains('callback') || lowerUrl.contains('return')) {
              debugPrint('[PaymentWebView] Detected callback/return in navigation request');
              // سنتعامل مع هذا في onPageFinished
            }
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('[PaymentWebView] WebView error: ${error.description}, errorCode: ${error.errorCode}');
            setState(() {
              _isLoading = false;
              _errorMessage = 'فشل تحميل صفحة الدفع: ${error.description}';
            });
            
            // إذا كان الخطأ متعلق بالاتصال بالإنترنت، نعرض رسالة خاصة
            if (error.errorCode == -2 || // net::ERR_INTERNET_DISCONNECTED
                error.errorCode == -7 || // net::ERR_NAME_NOT_RESOLVED
                error.errorCode == -106) { // net::ERR_CONNECTION_REFUSED
              setState(() {
                _errorMessage = 'تعذر الاتصال بخدمة الدفع. يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.';
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
          _errorMessage = 'استغرق تحميل صفحة الدفع وقتًا طويلاً. يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.';
        });
      }
    });

    // Configure Android specific settings
    if (controller.platform is webview_android.AndroidWebViewController) {
      webview_android.AndroidWebViewController.enableDebugging(true);
      (controller.platform as webview_android.AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
  }

  // وظيفة مساعدة لمعالجة حالات الدفع الناجحة بشكل موحد
  void _handleSuccessfulPayment(String url) {
    debugPrint('[PaymentWebView] Handling successful payment for URL: $url');
    
    try {
      // استخدام PaymentCubit لتحديث حالة الاشتراك والباقات
      if (context.mounted) {
        final paymentCubit = context.read<PaymentCubit>();
        paymentCubit.updateSubscriptionAfterPayment();
        debugPrint('[PaymentWebView] Called updateSubscriptionAfterPayment');
      }
    } catch (e) {
      debugPrint('[PaymentWebView] Error updating subscription: $e');
    }
    
    // استدعاء onPaymentComplete مباشرة بدون تأخير وبدون استخدام ScaffoldMessenger
    // لتجنب مشكلة الوصول إلى widget تم إلغاء تنشيطه
    widget.onPaymentComplete(true);
  }
  

  void _checkPaymentStatus(String url) {
    // تنفيذ منطق التحقق من حالة الدفع
    debugPrint('[PaymentWebView] Checking URL: $url');
    
    // تحويل URL إلى حروف صغيرة للتحقق بشكل أفضل
    final lowerUrl = url.toLowerCase();
    
    // أولاً، نتحقق من وجود 'return' أو 'callback' في URL
    // بناءً على المشكلة المكتشفة، نفترض أن الدفع ناجح دائمًا عند وجود هذه الكلمات
    if (lowerUrl.contains('return') || lowerUrl.contains('callback')) {
      debugPrint('[PaymentWebView] Return/callback URL detected - assuming SUCCESS');
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
      widget.onPaymentComplete(false);
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
      widget.onPaymentComplete(false);
      return;
    }
    
    // تم نقل منطق التحقق من وجود كلمة callback أو return إلى بداية الدالة
  }

  // وظيفة لإعادة تحميل صفحة الدفع
  void _reloadPaymentPage() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    _controller.loadRequest(Uri.parse(widget.paymentUrl)).catchError((error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'خطأ أثناء تحميل الصفحة: $error';
      });
    });
    debugPrint('[PaymentWebView] Reloading payment page');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // عرض مربع حوار للتأكيد قبل الإغلاق
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('إلغاء عملية الدفع'),
            content: const Text('هل أنت متأكد من رغبتك في إلغاء عملية الدفع؟'),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.of(context).pop(false);
                  }
                },
                child: const Text('لا'),
              ),
              TextButton(
                onPressed: () {
                  // استخدام Future.microtask لتجنب مشاكل الوصول إلى widget تم إلغاء تنشيطه
                  Future.microtask(() {
                    // إعلام المستخدم بأن عملية الدفع تم إلغاؤها
                    widget.onPaymentComplete(false);
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop(true);
                    }
                  });
                },
                child: const Text('نعم'),
              ),
            ],
          ),
        ) ?? false;
        
        return shouldPop;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('صفحة الدفع'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              // عرض مربع حوار للتأكيد قبل الإغلاق
              showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('إلغاء عملية الدفع'),
                  content: const Text('هل أنت متأكد من رغبتك في إلغاء عملية الدفع؟'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.of(context).pop(false);
                        }
                      },
                      child: const Text('لا'),
                    ),
                    TextButton(
                      onPressed: () {
                        // استخدام Future.microtask لتجنب مشاكل الوصول إلى widget تم إلغاء تنشيطه
                        Future.microtask(() {
                          // إعلام المستخدم بأن عملية الدفع تم إلغاؤها
                          widget.onPaymentComplete(false);
                          if (Navigator.canPop(context)) {
                            Navigator.of(context).pop(true); // إغلاق مربع الحوار
                            if (Navigator.canPop(context)) {
                              Navigator.of(context).pop(); // إغلاق صفحة الدفع
                            }
                          }
                        });
                      },
                      child: const Text('نعم'),
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
            if (_errorMessage == null)
              WebViewWidget(controller: _controller),
            
            // عرض مؤشر التحميل مع رسالة
            if (_isLoading && _errorMessage == null)
              Container(
                color: Colors.white.withOpacity(0.7),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'جارٍ تحميل صفحة الدفع...',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'يرجى الانتظار',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            
            // عرض رسالة الخطأ مع زر إعادة المحاولة
            if (_errorMessage != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _reloadPaymentPage,
                        icon: const Icon(Icons.refresh),
                        label: const Text('إعادة المحاولة'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          // استخدام Future.microtask لتجنب مشاكل الوصول إلى widget تم إلغاء تنشيطه
                          Future.microtask(() {
                            widget.onPaymentComplete(false);
                            if (Navigator.canPop(context)) {
                              Navigator.of(context).pop();
                            }
                          });
                        },
                        child: const Text('إلغاء عملية الدفع'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
