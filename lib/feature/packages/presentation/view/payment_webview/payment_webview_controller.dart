import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart' as webview_android;
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class PaymentWebViewController {
  late final WebViewController controller;
  final String paymentUrl;
  final Function(String) onPageStarted;
  final Function(String) onPageFinished;
  final Function(String) onNavigationRequest;
  final Function(String) onWebResourceError;

  PaymentWebViewController({
    required this.paymentUrl,
    required this.onPageStarted,
    required this.onPageFinished,
    required this.onNavigationRequest,
    required this.onWebResourceError,
  }) {
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

    controller = WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            onPageStarted(url);
          },
          onPageFinished: (String url) {
            onPageFinished(url);
          },
          onNavigationRequest: (NavigationRequest request) {
            onNavigationRequest(request.url);
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            onWebResourceError(error.description);
          },
        ),
      )
      ..loadRequest(Uri.parse(paymentUrl)).catchError((error) {
        onWebResourceError(error.toString());
      });

    // Configure Android specific settings
    if (controller.platform is webview_android.AndroidWebViewController) {
      webview_android.AndroidWebViewController.enableDebugging(true);
      (controller.platform as webview_android.AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
  }

  void reload() {
    controller.reload();
  }

  void loadRequest(String url) {
    controller.loadRequest(Uri.parse(url));
  }
}
