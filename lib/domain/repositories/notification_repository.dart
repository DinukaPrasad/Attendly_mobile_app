import '../entities/notification.dart';

abstract class NotificationRepository {
  Future<List<Notification>> getNotificationsByRecipient(int recipientId);

  Future<List<Notification>> getUnreadNotifications(int recipientId);

  Future<void> markNotificationAsRead(int notificationId);
}
