import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../data/mock_data.dart';

/// Custom app bar widget for the home screen.
///
/// Displays the user's name on the left and action buttons on the right.
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The display name of the logged-in user.
  final String userName;

  /// Callback when notification icon is tapped.
  final VoidCallback? onNotificationTap;

  /// Callback when settings icon is tapped.
  final VoidCallback? onSettingsTap;

  const HomeAppBar({
    super.key,
    required this.userName,
    this.onNotificationTap,
    this.onSettingsTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notificationCount = MockNotificationData.unreadCount;

    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      scrolledUnderElevation: 1,
      title: Text(
        'Hi, $userName',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
      ),
      actions: [
        IconButton(
          icon: badges.Badge(
            showBadge: notificationCount > 0,
            badgeContent: Text(
              notificationCount > 9 ? '9+' : '$notificationCount',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            badgeStyle: badges.BadgeStyle(
              badgeColor: theme.colorScheme.error,
              padding: EdgeInsets.all(4.w),
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          onPressed: onNotificationTap,
          tooltip: 'Notifications',
        ),
        IconButton(
          icon: Icon(
            Icons.settings_outlined,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          onPressed: onSettingsTap,
          tooltip: 'Settings',
        ),
        Gap(8.w),
      ],
    );
  }
}
