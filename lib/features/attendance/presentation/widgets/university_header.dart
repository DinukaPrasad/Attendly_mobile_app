import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../widgets/app_cached_image.dart';

/// A header widget displaying the university logo and name.
///
/// This widget shows the university branding at the top of the home screen.
class UniversityHeader extends StatelessWidget {
  /// The university name to display.
  final String universityName;

  /// Optional network URL for the university logo.
  final String? logoUrl;

  /// Optional asset path for the university logo (fallback).
  final String? logoAssetPath;

  const UniversityHeader({
    super.key,
    required this.universityName,
    this.logoUrl,
    this.logoAssetPath,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          // University Logo
          _buildLogo(theme),
          Gap(16.w),
          // University Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Gap(4.h),
                Text(
                  universityName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(ThemeData theme) {
    return Container(
      width: 64.w,
      height: 64.w,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildLogoImage(theme),
    );
  }

  Widget _buildLogoImage(ThemeData theme) {
    // Try network image first with CachedNetworkImage
    if (logoUrl != null && logoUrl!.isNotEmpty) {
      return AppCachedImage(
        imageUrl: logoUrl!,
        width: 64.w,
        height: 64.w,
        borderRadius: 12.r,
        errorWidget: _buildPlaceholder(theme),
      );
    }

    // Try asset image
    if (logoAssetPath != null && logoAssetPath!.isNotEmpty) {
      return Image.asset(
        logoAssetPath!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(theme),
      );
    }

    // Fallback to placeholder
    return _buildPlaceholder(theme);
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Center(
      child: Icon(
        Icons.school_rounded,
        size: 32.sp,
        color: theme.colorScheme.primary,
      ),
    );
  }
}
