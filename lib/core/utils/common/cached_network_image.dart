import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'loading_widget.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;

  const CustomCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
    this.backgroundColor,
  });

  bool _isValidImageUrl(String url) {
    if (url.isEmpty) return false;
    try {
      final uri = Uri.parse(url);
      if (uri.scheme == 'file') return false; // Reject file:// URLs
      return uri.hasAuthority && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  Widget get _defaultErrorWidget => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: borderRadius ?? BorderRadius.circular(12),
        ),
        child: const Center(
          child: Icon(
            Icons.error_outline,
            color: AppColors.error,
          ),
        ),
      );

  Widget get _defaultLoadingWidget => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: borderRadius ?? BorderRadius.circular(12),
        ),
        child: const Center(
          child: LoadingWidget(
            size: 24,
            color: AppColors.primary,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (!_isValidImageUrl(imageUrl)) {
      return errorWidget ?? _defaultErrorWidget;
    }

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      child: Container(
        width: width,
        height: height,
        color: backgroundColor,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: fit ?? BoxFit.cover,
          placeholder: (context, url) => placeholder ?? _defaultLoadingWidget,
          errorWidget: (context, url, error) => errorWidget ?? _defaultErrorWidget,
        ),
      ),
    );
  }
}
