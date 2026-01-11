import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/services/permission_manager.dart';

/// Permission gate screen shown on first install after login
///
/// Allows users to enable/deny permissions for:
/// - Network (informational)
/// - Location
/// - Notifications
class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  late final PermissionManager _permissionManager;

  // Permission statuses
  PermissionCheckStatus _networkStatus = PermissionCheckStatus.denied;
  PermissionCheckStatus _locationStatus = PermissionCheckStatus.denied;
  PermissionCheckStatus _notificationStatus = PermissionCheckStatus.denied;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _permissionManager = sl<PermissionManager>();
    _checkInitialPermissions();
  }

  Future<void> _checkInitialPermissions() async {
    setState(() => _isLoading = true);

    final statuses = await _permissionManager.checkAllPermissions();

    setState(() {
      _networkStatus = statuses['network'] ?? PermissionCheckStatus.denied;
      _locationStatus = statuses['location'] ?? PermissionCheckStatus.denied;
      _notificationStatus =
          statuses['notification'] ?? PermissionCheckStatus.denied;
      _isLoading = false;
    });
  }

  Future<void> _requestLocationPermission() async {
    setState(() => _isLoading = true);

    final status = await _permissionManager.requestLocationPermission();

    setState(() {
      _locationStatus = status;
      _isLoading = false;
    });
  }

  Future<void> _requestNotificationPermission() async {
    setState(() => _isLoading = true);

    final status = await _permissionManager.requestNotificationPermission();

    setState(() {
      _notificationStatus = status;
      _isLoading = false;
    });
  }

  Future<void> _completePermissionGate() async {
    // Mark permission gate as done
    await _permissionManager.markPermissionGateDone();

    // Refresh router to trigger redirect to home
    if (mounted) {
      AppRouter.refreshAuthState();
      context.go(AppRoutes.home);
    }
  }

  Color _getStatusColor(PermissionCheckStatus status) {
    switch (status) {
      case PermissionCheckStatus.granted:
        return Colors.green;
      case PermissionCheckStatus.denied:
        return Colors.orange;
      case PermissionCheckStatus.permanentlyDenied:
        return Colors.red;
      case PermissionCheckStatus.serviceDisabled:
        return Colors.red.shade700;
      case PermissionCheckStatus.notSupported:
        return Colors.grey;
    }
  }

  String _getStatusText(PermissionCheckStatus status) {
    switch (status) {
      case PermissionCheckStatus.granted:
        return 'Enabled';
      case PermissionCheckStatus.denied:
        return 'Not Set';
      case PermissionCheckStatus.permanentlyDenied:
        return 'Blocked';
      case PermissionCheckStatus.serviceDisabled:
        return 'Disabled';
      case PermissionCheckStatus.notSupported:
        return 'N/A';
    }
  }

  IconData _getStatusIcon(PermissionCheckStatus status) {
    switch (status) {
      case PermissionCheckStatus.granted:
        return Icons.check_circle;
      case PermissionCheckStatus.denied:
        return Icons.radio_button_unchecked;
      case PermissionCheckStatus.permanentlyDenied:
        return Icons.block;
      case PermissionCheckStatus.serviceDisabled:
        return Icons.error_outline;
      case PermissionCheckStatus.notSupported:
        return Icons.remove_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Gap(40.h),

                    // Header
                    Icon(
                          Icons.security,
                          size: 64.sp,
                          color: colorScheme.primary,
                        )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .scale(delay: 200.ms, duration: 300.ms),

                    Gap(24.h),

                    Text(
                      'App Permissions',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

                    Gap(8.h),

                    Text(
                      'Attendly needs some permissions to work properly. '
                      'Please enable the following to get the best experience.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

                    Gap(40.h),

                    // Network Status (informational)
                    _PermissionTile(
                      icon: Icons.wifi,
                      title: 'Network',
                      description: 'Check your internet connection status',
                      status: _networkStatus,
                      statusColor: _getStatusColor(_networkStatus),
                      statusText:
                          _networkStatus == PermissionCheckStatus.granted
                          ? 'Connected'
                          : 'No Connection',
                      statusIcon: _getStatusIcon(_networkStatus),
                      onTap: _checkInitialPermissions,
                      actionLabel: 'Refresh',
                    ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1),

                    Gap(16.h),

                    // Location Permission
                    _PermissionTile(
                      icon: Icons.location_on,
                      title: 'Location',
                      description:
                          'Required to verify attendance at specific locations',
                      status: _locationStatus,
                      statusColor: _getStatusColor(_locationStatus),
                      statusText: _getStatusText(_locationStatus),
                      statusIcon: _getStatusIcon(_locationStatus),
                      onTap: _locationStatus == PermissionCheckStatus.granted
                          ? null
                          : _requestLocationPermission,
                      actionLabel:
                          _locationStatus ==
                              PermissionCheckStatus.permanentlyDenied
                          ? 'Open Settings'
                          : 'Enable',
                    ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1),

                    Gap(16.h),

                    // Notification Permission
                    _PermissionTile(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      description:
                          'Stay updated with attendance reminders and alerts',
                      status: _notificationStatus,
                      statusColor: _getStatusColor(_notificationStatus),
                      statusText: _getStatusText(_notificationStatus),
                      statusIcon: _getStatusIcon(_notificationStatus),
                      onTap:
                          _notificationStatus == PermissionCheckStatus.granted
                          ? null
                          : _requestNotificationPermission,
                      actionLabel:
                          _notificationStatus ==
                              PermissionCheckStatus.permanentlyDenied
                          ? 'Open Settings'
                          : 'Enable',
                    ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.1),

                    Gap(40.h),

                    // Continue Button
                    ElevatedButton(
                      onPressed: _completePermissionGate,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),

                    Gap(12.h),

                    // Skip Button
                    TextButton(
                      onPressed: _completePermissionGate,
                      child: Text(
                        'Skip for now',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ).animate().fadeIn(delay: 700.ms),

                    Gap(24.h),

                    // Info text
                    Text(
                      'You can change these permissions later in Settings.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.7,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 800.ms),
                  ],
                ),
              ),
      ),
    );
  }
}

/// Individual permission tile with toggle action
class _PermissionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final PermissionCheckStatus status;
  final Color statusColor;
  final String statusText;
  final IconData statusIcon;
  final VoidCallback? onTap;
  final String actionLabel;

  const _PermissionTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.status,
    required this.statusColor,
    required this.statusText,
    required this.statusIcon,
    this.onTap,
    required this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isGranted = status == PermissionCheckStatus.granted;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isGranted
              ? Colors.green.withValues(alpha: 0.3)
              : colorScheme.outline.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, size: 24.sp, color: colorScheme.primary),
          ),

          Gap(16.w),

          // Title and description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(4.h),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          Gap(12.w),

          // Status and action
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Status badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 14.sp, color: statusColor),
                    Gap(4.w),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              if (onTap != null) ...[
                Gap(8.h),
                // Action button
                TextButton(
                  onPressed: onTap,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    actionLabel,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
