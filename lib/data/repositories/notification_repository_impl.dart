import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  const NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Notification>> getNotificationsByRecipient(int recipientId) {
    return remoteDataSource.getNotificationsByRecipient(recipientId);
  }

  @override
  Future<List<Notification>> getUnreadNotifications(int recipientId) {
    return remoteDataSource.getUnreadNotifications(recipientId);
  }

  @override
  Future<void> markNotificationAsRead(int notificationId) {
    return remoteDataSource.markNotificationAsRead(notificationId);
  }
}
