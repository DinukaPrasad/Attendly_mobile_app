import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';

import '../../../../widgets/shimmer_loading.dart';

/// Notifications screen displaying user notifications
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _isLoading = true;
  List<_NotificationItem> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    try {
      // Use constants for base URL and endpoint
      final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiEndpoints.notifications}',
      );
      final response = await http.get(
        url,
        headers: {
          'Content-Type': ApiConstants.contentType,
          // Add authorization header if needed
          // ApiConstants.authorization: '${ApiConstants.bearer} your_token',
        },
      );

      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse['content'] ?? [];
        _notifications = _mapNotifications(data);
      } else {
        print('API error: ${response.statusCode}');
        _notifications = _getMockNotifications();
      }
    } catch (e, stack) {
      print('Notification load error: $e\n$stack');
      _notifications = _getMockNotifications();
    }
    if (mounted) setState(() => _isLoading = false);
  }

  List<_NotificationItem> _mapNotifications(List<dynamic> data) {
    return data.map<_NotificationItem>((item) {
      return _NotificationItem(
        id: item['id'].toString(),
        title: item['title'] ?? '',
        message: item['message'] ?? '',
        time: DateTime.tryParse(item['createdAt'] ?? '') ?? DateTime.now(),
        isRead: item['read'] ?? false,
        type: _parseNotificationType(item['type']),
      );
    }).toList();
  }

  List<_NotificationItem> _getMockNotifications() {
    return [
      _NotificationItem(
        id: '1',
        title: 'Attendance Approved',
        message: 'Your attendance for Data Structures has been approved.',
        time: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
        type: _NotificationType.success,
      ),
      _NotificationItem(
        id: '2',
        title: 'New Session Available',
        message: 'Database Management lab session is now open for attendance.',
        time: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: false,
        type: _NotificationType.info,
      ),
      _NotificationItem(
        id: '3',
        title: 'Attendance Reminder',
        message:
            'Don\'t forget to mark your attendance for Software Engineering.',
        time: DateTime.now().subtract(const Duration(hours: 3)),
        isRead: true,
        type: _NotificationType.warning,
      ),
      _NotificationItem(
        id: '4',
        title: 'Session Ended',
        message: 'Computer Networks lecture has ended.',
        time: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
        type: _NotificationType.info,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (_notifications.any((n) => !n.isRead))
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _notifications.isEmpty
          ? _buildEmptyState(theme)
          : _buildNotificationsList(theme),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 4,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: ShimmerLoading(
          child: Container(
            height: 80.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_outlined,
            size: 64.sp,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          Gap(16.h),
          Text(
            'No notifications',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Gap(8.h),
          Text(
            'You\'re all caught up!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(ThemeData theme) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() => _isLoading = true);
        await _loadNotifications();
      },
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return _NotificationCard(
                notification: notification,
                onTap: () => _handleNotificationTap(notification),
                onDismiss: () => _dismissNotification(notification),
              )
              .animate()
              .fadeIn(duration: 300.ms, delay: (50 * index).ms)
              .slideX(begin: 0.1, duration: 300.ms, delay: (50 * index).ms);
        },
      ),
    );
  }

  void _markAllAsRead() {
    setState(() {
      _notifications = _notifications
          .map(
            (n) => _NotificationItem(
              id: n.id,
              title: n.title,
              message: n.message,
              time: n.time,
              isRead: true,
              type: n.type,
            ),
          )
          .toList();
    });
  }

  void _handleNotificationTap(_NotificationItem notification) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == notification.id);
      if (index != -1) {
        _notifications[index] = _NotificationItem(
          id: notification.id,
          title: notification.title,
          message: notification.message,
          time: notification.time,
          isRead: true,
          type: notification.type,
        );
      }
    });
  }

  void _dismissNotification(_NotificationItem notification) {
    setState(() {
      _notifications.removeWhere((n) => n.id == notification.id);
    });
  }

  _NotificationType _parseNotificationType(dynamic type) {
    switch (type?.toString().toLowerCase()) {
      case 'success':
        return _NotificationType.success;
      case 'warning':
        return _NotificationType.warning;
      case 'error':
        return _NotificationType.error;
      case 'info':
      default:
        return _NotificationType.info;
    }
  }
}

class _NotificationCard extends StatelessWidget {
  final _NotificationItem notification;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const _NotificationCard({
    required this.notification,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(Icons.delete_outline, color: theme.colorScheme.onError),
      ),
      child: Card(
        margin: EdgeInsets.only(bottom: 12.h),
        color: notification.isRead
            ? theme.colorScheme.surface
            : theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIcon(theme),
                Gap(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: notification.isRead
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      Gap(4.h),
                      Text(
                        notification.message,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Gap(8.h),
                      Text(
                        _formatTime(notification.time),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(ThemeData theme) {
    final iconData = switch (notification.type) {
      _NotificationType.success => Icons.check_circle_outline,
      _NotificationType.warning => Icons.warning_amber_outlined,
      _NotificationType.error => Icons.error_outline,
      _NotificationType.info => Icons.info_outline,
    };

    final color = switch (notification.type) {
      _NotificationType.success => Colors.green,
      _NotificationType.warning => Colors.orange,
      _NotificationType.error => theme.colorScheme.error,
      _NotificationType.info => theme.colorScheme.primary,
    };

    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(iconData, color: color, size: 20.sp),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${time.day}/${time.month}/${time.year}';
  }
}

enum _NotificationType { success, warning, error, info }

class _NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime time;
  final bool isRead;
  final _NotificationType type;

  const _NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.type,
  });
}
