import 'package:cloud_firestore/cloud_firestore.dart';

class InboxModel {
  final String messageId;

  final String content;
  final DateTime sentAt;
  final String sender;
  final String receiverId;
  final bool isRead;

  InboxModel({
    required this.messageId,
    required this.content,
    required this.sentAt,
    required this.sender,
    required this.receiverId,
    required this.isRead,
  });

  InboxModel fromInboxSnapshot(DocumentSnapshot snapshot) {
    final data = {
      ...snapshot.data() as Map<String, dynamic>,
      'id': snapshot.id,
    };
    return InboxModel.fromJson(data);
  }

  factory InboxModel.fromJson(Map<String, dynamic> json) {
    return InboxModel(
      messageId: json['messageId'] ?? '',
      content: json['content'] ?? '',
      sentAt: (json['sentAt'] as Timestamp).toDate(),
      sender: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'content': content,
      'sentAt': sentAt.toIso8601String(),
      'senderId': sender,
      'receiverId': receiverId,
      'isRead': isRead,
    };
  }
}
