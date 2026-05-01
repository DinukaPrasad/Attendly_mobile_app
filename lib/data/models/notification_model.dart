import '../../domain/entities/notification.dart';

class NotificationModel extends Notification {
  const NotificationModel({
    super.id,
    super.senderId,
    super.senderName,
    super.recipientId,
    super.content,
    super.status,
    super.datetime,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int?,
      senderId: json['senderId'] as int?,
      senderName: json['senderName'] as String?,
      recipientId: json['recipientId'] as int?,
      content: json['content'] as String?,
      status: json['status'] as String?,
      datetime: json['datetime'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    if (senderId != null) 'senderId': senderId,
    if (senderName != null) 'senderName': senderName,
    if (recipientId != null) 'recipientId': recipientId,
    if (content != null) 'content': content,
    if (status != null) 'status': status,
    if (datetime != null) 'datetime': datetime,
  };
}
