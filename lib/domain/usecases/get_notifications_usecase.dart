import '../entities/notification.dart';
import '../repositories/notification_repository.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;

  const GetNotificationsUseCase(this.repository);

  Future<List<Notification>> call(int recipientId) {
    return repository.getNotificationsByRecipient(recipientId);
  }
}
