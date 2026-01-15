import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Reusable shimmer loading widget for skeleton screens.
///
/// Wraps child widgets with a shimmer effect for loading states.
class ShimmerLoading extends StatelessWidget {
  /// The child widget to apply shimmer effect to.
  final Widget child;

  /// Whether the shimmer is enabled. When false, shows child directly.
  final bool isLoading;

  const ShimmerLoading({super.key, required this.child, this.isLoading = true});

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark
          ? theme.colorScheme.surfaceContainerHighest
          : Colors.grey.shade300,
      highlightColor: isDark
          ? theme.colorScheme.surfaceContainer
          : Colors.grey.shade100,
      child: child,
    );
  }
}

/// Skeleton placeholder for a line of text
class ShimmerTextLine extends StatelessWidget {
  final double? width;
  final double height;

  const ShimmerTextLine({super.key, this.width, this.height = 14});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

/// Skeleton placeholder for a circular avatar
class ShimmerAvatar extends StatelessWidget {
  final double size;

  const ShimmerAvatar({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Skeleton placeholder for a card
class ShimmerCard extends StatelessWidget {
  final double? height;
  final double? width;
  final double borderRadius;

  const ShimmerCard({
    super.key,
    this.height,
    this.width,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
