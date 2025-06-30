import 'package:flutter/material.dart';
import 'package:moazez/core/utils/common/custom_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'payment_webview/payment_webview_controller.dart';
import 'payment_webview/payment_status_handler.dart';
import 'payment_webview/widgets/loading_indicator.dart';
import 'payment_webview/widgets/error_view.dart';
import 'payment_webview/widgets/cancellation_dialog.dart';

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
  late PaymentWebViewController _webViewController;
  late PaymentStatusHandler _statusHandler;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _statusHandler = PaymentStatusHandler(
      context: context,
      onPaymentComplete: widget.onPaymentComplete,
    );
    _initializeWebView();
    // Add a timeout to handle long loading times
    Future.delayed(const Duration(seconds: 15), () {
      if (mounted && _isLoading) {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'استغرق تحميل صفحة الدفع وقتًا طويلاً. يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.';
        });
      }
    });
  }

  void _initializeWebView() {
    _webViewController = PaymentWebViewController(
      paymentUrl: widget.paymentUrl,
      onPageStarted: (url) {
        setState(() {
          _isLoading = true;
          _errorMessage = null;
        });
      },
      onPageFinished: (url) {
        setState(() {
          _isLoading = false;
        });
        _statusHandler.checkPaymentStatus(url);
      },
      onNavigationRequest: (url) {
        // Additional logic can be added here if needed
      },
      onWebResourceError: (error) {
        setState(() {
          _isLoading = false;
          _errorMessage = _getErrorMessage(error);
        });
      },
    );
  }

  String _getErrorMessage(String error) {
    if (error.contains('net::ERR_INTERNET_DISCONNECTED') ||
        error.contains('net::ERR_CONNECTION_REFUSED') ||
        error.contains('net::ERR_NAME_NOT_RESOLVED')) {
      return 'تعذر الاتصال بخدمة الدفع. يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.';
    } else if (error.contains('429') || error.contains('Too Many Requests')) {
      return 'عدد كبير من الطلبات. يرجى الانتظار قليلاً ثم المحاولة مرة أخرى.';
    } else {
      return 'فشل تحميل صفحة الدفع: $error';
    }
  }

  void _reloadPaymentPage() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    _webViewController.loadRequest(widget.paymentUrl);
  }

  void _handleCancel() {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
    Future.microtask(() {
      widget.onPaymentComplete(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop =
            await showDialog<bool>(
              context: context,
              builder:
                  (context) =>
                      CancellationDialog(onConfirm: widget.onPaymentComplete),
            ) ??
            false;
        return shouldPop;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'صفحة الدفع',
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _reloadPaymentPage,
            ),
          ],
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _handleCancel,
          ),
        ),
        body: Stack(
          children: [
            if (_errorMessage == null)
              WebViewWidget(controller: _webViewController.controller),
            if (_isLoading && _errorMessage == null) const LoadingIndicator(),
            if (_errorMessage != null)
              ErrorView(
                errorMessage: _errorMessage!,
                onRetry: _reloadPaymentPage,
                onCancel: _handleCancel,
              ),
          ],
        ),
      ),
    );
  }
}
