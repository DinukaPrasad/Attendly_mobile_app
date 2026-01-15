import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// A quick action button widget for the home screen.
///
/// Displays an icon and label in a compact, tappable format.
class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? iconColor;

  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.primaryContainer;
    final fgColor = iconColor ?? theme.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: bgColor.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: fgColor.withValues(alpha: 0.2)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 28.sp, color: fgColor),
              Gap(8.h),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: fgColor,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A row of quick action buttons for the home screen.
class QuickActionsRow extends StatelessWidget {
  final VoidCallback? onScanTap;
  final VoidCallback? onHistoryTap;
  final VoidCallback? onProfileTap;

  const QuickActionsRow({
    super.key,
    this.onScanTap,
    this.onHistoryTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: QuickActionButton(
              icon: Icons.qr_code_scanner_rounded,
              label: 'Scan QR',
              onTap: onScanTap,
            ),
          ),
          Gap(12.w),
          Expanded(
            child: QuickActionButton(
              icon: Icons.history_rounded,
              label: 'History',
              onTap: onHistoryTap,
            ),
          ),
          Gap(12.w),
          Expanded(
            child: QuickActionButton(
              icon: Icons.person_outline_rounded,
              label: 'Profile',
              onTap: onProfileTap,
            ),
          ),
        ],
      ),
    );
  }
}
