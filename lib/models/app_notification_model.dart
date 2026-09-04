enum NotificationType {
  message,
  offer,
  transaction,
  system,
}

class AppNotificationModel {
  final String id;
  final String title;
  final String message;
  final String? conversationId;
  final String? itemId;
  final String? itemTitle;
  final String? senderId;
  final String senderName;
  final String? senderAvatar;
  final double? priceOffer;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;

  const AppNotificationModel({
    required this.id,
    required this.title,
    required this.message,
    this.conversationId,
    this.itemId,
    this.itemTitle,
    this.senderId,
    required this.senderName,
    this.senderAvatar,
    this.priceOffer,
    this.type = NotificationType.message,
    required this.timestamp,
    this.isRead = false,
  });

  AppNotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? conversationId,
    String? itemId,
    String? itemTitle,
    String? senderId,
    String? senderName,
    String? senderAvatar,
    double? priceOffer,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return AppNotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      conversationId: conversationId ?? this.conversationId,
      itemId: itemId ?? this.itemId,
      itemTitle: itemTitle ?? this.itemTitle,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      priceOffer: priceOffer ?? this.priceOffer,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) {
    return AppNotificationModel(
      id: json['id'] as String? ?? 'notif_${DateTime.now().millisecondsSinceEpoch}',
      title: json['title'] as String? ?? 'Notification',
      message: json['message'] as String? ?? '',
      conversationId: json['conversationId'] as String?,
      itemId: json['itemId'] as String?,
      itemTitle: json['itemTitle'] as String?,
      senderId: json['senderId'] as String?,
      senderName: json['senderName'] as String? ?? 'Campus Student',
      senderAvatar: json['senderAvatar'] as String?,
      priceOffer: (json['priceOffer'] as num?)?.toDouble(),
      type: NotificationType.values.firstWhere(
        (t) => t.name == (json['type'] as String? ?? 'message'),
        orElse: () => NotificationType.message,
      ),
      timestamp: json['timestamp'] != null
          ? (DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now())
          : DateTime.now(),
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'conversationId': conversationId,
      'itemId': itemId,
      'itemTitle': itemTitle,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'priceOffer': priceOffer,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }
}
