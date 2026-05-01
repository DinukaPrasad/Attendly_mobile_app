import '../models/notification_model.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';

class NotificationRemoteDataSource {
  final ApiClient _apiClient;

  NotificationRemoteDataSource({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<List<NotificationModel>> getNotificationsByRecipient(
    int recipientId,
  ) async {
    final data = await _apiClient.get(
      '${ApiConstants.notificationsRecipient}/$recipientId',
    );
    final List<dynamic> notificationList = data is List
        ? data
        : data['data'] ?? [];
    return notificationList
        .map(
          (notification) =>
              NotificationModel.fromJson(notification as Map<String, dynamic>),
        )
        .toList();
  }

  Future<List<NotificationModel>> getUnreadNotifications(
    int recipientId,
  ) async {
    final data = await _apiClient.get(
      '${ApiConstants.notifications}/unread/$recipientId',
    );
    final List<dynamic> notificationList = data is List
        ? data
        : data['data'] ?? [];
    return notificationList
        .map(
          (notification) =>
              NotificationModel.fromJson(notification as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> markNotificationAsRead(int notificationId) async {
    await _apiClient.put('${ApiConstants.notifications}/$notificationId/read');
  }
}
