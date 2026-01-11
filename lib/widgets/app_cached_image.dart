import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

/// Reusable cached network image with consistent placeholder and error handling.
class AppCachedImage extends StatelessWidget {
  /// The URL of the image to load.
  final String imageUrl;

  /// Width of the image.
  final double? width;

  /// Height of the image.
  final double? height;

  /// How the image should fit within its bounds.
  final BoxFit fit;

  /// Border radius for the image.
  final double? borderRadius;

  /// Whether the image should be circular.
  final bool isCircular;

  /// Custom placeholder widget.
  final Widget? placeholder;

  /// Custom error widget.
  final Widget? errorWidget;

  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.isCircular = false,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) =>
          placeholder ?? _buildPlaceholder(theme, isDark),
      errorWidget: (context, url, error) =>
          errorWidget ?? _buildErrorWidget(theme),
    );

    if (isCircular) {
      return ClipOval(child: image);
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius!),
        child: image,
      );
    }

    return image;
  }

  Widget _buildPlaceholder(ThemeData theme, bool isDark) {
    return Shimmer.fromColors(
      baseColor: isDark
          ? theme.colorScheme.surfaceContainerHighest
          : Colors.grey.shade300,
      highlightColor: isDark
          ? theme.colorScheme.surfaceContainer
          : Colors.grey.shade100,
      child: Container(width: width, height: height, color: Colors.white),
    );
  }

  Widget _buildErrorWidget(ThemeData theme) {
    return Container(
      width: width,
      height: height,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.broken_image_outlined,
        size: 24.sp,
        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
      ),
    );
  }
}

/// Cached avatar image with circular shape
class AppCachedAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final String? fallbackText;

  const AppCachedAvatar({
    super.key,
    this.imageUrl,
    this.size = 40,
    this.fallbackText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildFallback(theme);
    }

    return AppCachedImage(
      imageUrl: imageUrl!,
      width: size,
      height: size,
      isCircular: true,
      errorWidget: _buildFallback(theme),
    );
  }

  Widget _buildFallback(ThemeData theme) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          _getInitials(),
          style: TextStyle(
            color: theme.colorScheme.onPrimaryContainer,
            fontSize: size * 0.4,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _getInitials() {
    if (fallbackText == null || fallbackText!.isEmpty) return '?';
    final words = fallbackText!.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return fallbackText![0].toUpperCase();
  }
}
