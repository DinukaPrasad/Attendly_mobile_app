import '../repositories/notification_repository.dart';

class MarkNotificationReadUseCase {
  final NotificationRepository repository;

  const MarkNotificationReadUseCase(this.repository);

  Future<void> call(int notificationId) {
    return repository.markNotificationAsRead(notificationId);
  }
}
