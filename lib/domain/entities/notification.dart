class Notification {
  final int? id;
  final int? senderId;
  final String? senderName;
  final int? recipientId;
  final String? content;
  final String? status;
  final String? datetime;

  const Notification({
    this.id,
    this.senderId,
    this.senderName,
    this.recipientId,
    this.content,
    this.status,
    this.datetime,
  });
}
