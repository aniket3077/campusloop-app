class ChatMessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String text;
  final double? priceOffer;
  final DateTime timestamp;
  final bool isMine;
  final bool isOffer;
  final String? offerStatus; // 'PENDING', 'ACCEPTED', 'DECLINED'

  const ChatMessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    required this.text,
    this.priceOffer,
    required this.timestamp,
    required this.isMine,
    this.isOffer = false,
    this.offerStatus,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      text: json['text'] as String,
      priceOffer: (json['priceOffer'] as num?)?.toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isMine: json['isMine'] as bool? ?? false,
      isOffer: json['isOffer'] as bool? ?? false,
      offerStatus: json['offerStatus'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'priceOffer': priceOffer,
      'timestamp': timestamp.toIso8601String(),
      'isMine': isMine,
      'isOffer': isOffer,
      'offerStatus': offerStatus,
    };
  }
}

class ChatConversationModel {
  final String id;
  final String resourceId;
  final String resourceTitle;
  final String resourceType;
  final double resourcePrice;
  final String otherParticipantName;
  final String otherParticipantAvatar;
  final bool isVerifiedStudent;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  const ChatConversationModel({
    required this.id,
    required this.resourceId,
    required this.resourceTitle,
    required this.resourceType,
    required this.resourcePrice,
    required this.otherParticipantName,
    required this.otherParticipantAvatar,
    required this.isVerifiedStudent,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });

  static List<ChatConversationModel> get mockConversations => [
    ChatConversationModel(
      id: 'conv_001',
      resourceId: 'res_001',
      resourceTitle: 'Linear Algebra & Its Applications (6th Ed)',
      resourceType: 'SELL',
      resourcePrice: 35.00,
      otherParticipantName: 'Marcus Chen',
      otherParticipantAvatar: 'M',
      isVerifiedStudent: true,
      lastMessage: 'I can meet at Engineering Quad at 2 PM today!',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 25)),
      unreadCount: 1,
    ),
    ChatConversationModel(
      id: 'conv_002',
      resourceId: 'res_002',
      resourceTitle: 'TI-84 Plus CE Graphing Calculator',
      resourceType: 'BORROW',
      resourcePrice: 5.00,
      otherParticipantName: 'Sophia Patel',
      otherParticipantAvatar: 'S',
      isVerifiedStudent: true,
      lastMessage: 'Offered \$5.00 for 10 days borrow',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 0,
    ),
  ];
}
