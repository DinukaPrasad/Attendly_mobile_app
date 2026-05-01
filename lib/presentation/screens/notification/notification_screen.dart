import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/datasources/notification_remote_datasource.dart';
import '../../../data/repositories/notification_repository_impl.dart';
import '../../../domain/entities/notification.dart' as app_notification;
import '../../../domain/usecases/get_notifications_usecase.dart';
import '../../../domain/usecases/mark_notification_read_usecase.dart';
import '../../widgets/custom_button.dart';

class NotificationScreen extends StatefulWidget {
  final String token;
  final int userId;

  const NotificationScreen({
    super.key,
    required this.token,
    required this.userId,
  });

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late final GetNotificationsUseCase _getNotificationsUseCase =
      GetNotificationsUseCase(
        NotificationRepositoryImpl(NotificationRemoteDataSource()),
      );

  late final MarkNotificationReadUseCase _markNotificationReadUseCase =
      MarkNotificationReadUseCase(
        NotificationRepositoryImpl(NotificationRemoteDataSource()),
      );

  List<app_notification.Notification> _notifications = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final notifications = await _getNotificationsUseCase(widget.userId);
      setState(() => _notifications = notifications);
    } catch (e) {
      setState(
        () => _errorMessage = e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _onNotificationTap(app_notification.Notification notification) async {
    // If unread, mark as read
    if (notification.status?.toUpperCase() != 'READ') {
      try {
        await _markNotificationReadUseCase(notification.id ?? 0);
        // Refresh the list after marking as read
        await _fetchNotifications();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString().replaceFirst('Exception: ', '')),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  bool _isNotificationUnread(app_notification.Notification notification) {
    return notification.status?.toUpperCase() != 'READ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Notifications'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : _errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: AppColors.error),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      label: 'Retry',
                      onPressed: _fetchNotifications,
                    ),
                  ],
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: _fetchNotifications,
              child: _notifications.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_none_outlined,
                              size: 48,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No notifications yet',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        return _buildNotificationCard(_notifications[index]);
                      },
                    ),
            ),
    );
  }

  Widget _buildNotificationCard(app_notification.Notification notification) {
    final isUnread = _isNotificationUnread(notification);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isUnread
          ? const Color(0xFF03DAC6).withValues(alpha: 0.15)
          : AppColors.surface,
      child: InkWell(
        onTap: () => _onNotificationTap(notification),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      notification.senderName ?? 'Unknown Sender',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isUnread
                            ? FontWeight.w700
                            : FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (isUnread)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'New',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                notification.content ?? '',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            notification.datetime ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isUnread)
                    Icon(
                      Icons.done_all,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
