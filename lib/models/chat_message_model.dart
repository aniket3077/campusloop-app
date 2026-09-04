class ParticipantModel {
  final String id;
  final String name;
  final String university;
  final String department;
  final String? avatarUrl;
  final bool isVerifiedStudent;
  final double trustRating;
  final bool isBlocked;

  const ParticipantModel({
    required this.id,
    required this.name,
    required this.university,
    required this.department,
    this.avatarUrl,
    required this.isVerifiedStudent,
    required this.trustRating,
    this.isBlocked = false,
  });

  factory ParticipantModel.fromJson(Map<String, dynamic> json) {
    return ParticipantModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? 'Campus Student').toString(),
      university: (json['university'] ?? 'MIT CSN').toString(),
      department: (json['department'] ?? 'Student').toString(),
      avatarUrl: json['avatarUrl'] as String?,
      isVerifiedStudent: (json['isVerifiedStudent'] as bool?) ??
          (json['verificationStatus'] == 'VERIFIED'),
      trustRating: (json['trustRating'] as num?)?.toDouble() ?? 5.0,
      isBlocked: json['isBlocked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'university': university,
      'department': department,
      'avatarUrl': avatarUrl,
      'isVerifiedStudent': isVerifiedStudent,
      'trustRating': trustRating,
      'isBlocked': isBlocked,
    };
  }

  ParticipantModel copyWith({bool? isBlocked}) {
    return ParticipantModel(
      id: id,
      name: name,
      university: university,
      department: department,
      avatarUrl: avatarUrl,
      isVerifiedStudent: isVerifiedStudent,
      trustRating: trustRating,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }
}

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
  final bool isRead;

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
    this.isRead = true,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    final meta = json['metadata'] is Map ? (json['metadata'] as Map) : null;
    final priceOfferVal = (json['priceOffer'] as num?)?.toDouble() ??
        (meta != null && meta['priceOffer'] != null ? (meta['priceOffer'] as num).toDouble() : null) ??
        (meta != null && meta['offeredPrice'] != null ? (meta['offeredPrice'] as num).toDouble() : null);

    final isOfferVal = (json['isOffer'] as bool?) ??
        (json['type'] == 'OFFER' || priceOfferVal != null);

    final offerStatusVal = (json['offerStatus'] as String?) ??
        (meta != null && meta['status'] != null ? meta['status'].toString() : null) ??
        (isOfferVal ? 'PENDING' : null);

    return ChatMessageModel(
      id: (json['id'] ?? '').toString(),
      conversationId: (json['conversationId'] ?? '').toString(),
      senderId: (json['senderId'] ?? '').toString(),
      senderName: (json['senderName'] ?? (json['isMe'] == true ? 'Me' : 'Student')).toString(),
      text: (json['text'] ?? '').toString(),
      priceOffer: priceOfferVal,
      timestamp: json['timestamp'] != null
          ? (DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now())
          : DateTime.now(),
      isMine: json['isMine'] as bool? ?? json['isMe'] as bool? ?? false,
      isOffer: isOfferVal,
      offerStatus: offerStatusVal,
      isRead: json['isRead'] as bool? ?? true,
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
      'isRead': isRead,
    };
  }
}

class ChatConversationModel {
  final String id;
  final String resourceId;
  final String resourceTitle;
  final String resourceType;
  final double resourcePrice;
  final String? resourceImageUrl;
  final ParticipantModel participant;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isBlocked;

  const ChatConversationModel({
    required this.id,
    required this.resourceId,
    required this.resourceTitle,
    required this.resourceType,
    required this.resourcePrice,
    this.resourceImageUrl,
    required this.participant,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    this.isBlocked = false,
  });

  String get otherParticipantName => participant.name;
  String get otherParticipantAvatar => participant.name.isNotEmpty ? participant.name[0] : 'U';
  bool get isVerifiedStudent => participant.isVerifiedStudent;

  factory ChatConversationModel.fromJson(Map<String, dynamic> json) {
    return ChatConversationModel(
      id: (json['id'] ?? '').toString(),
      resourceId: (json['resourceId'] ?? json['itemId']) as String? ?? '',
      resourceTitle: (json['resourceTitle'] ?? json['itemTitle']) as String? ?? 'Campus Item',
      resourceType: (json['resourceType'] ?? json['itemCategory'] ?? json['transactionType']) as String? ?? 'SELL',
      resourcePrice: ((json['resourcePrice'] ?? json['itemPrice']) as num?)?.toDouble() ?? 0.0,
      resourceImageUrl: (json['resourceImageUrl'] ?? json['itemImageUrl']) as String?,
      participant: json['participant'] != null
          ? ParticipantModel.fromJson(Map<String, dynamic>.from(json['participant'] as Map))
          : ParticipantModel(
              id: (json['otherParticipantId'] ?? 'user_student').toString(),
              name: (json['otherParticipantName'] ?? 'Campus Student').toString(),
              university: 'MIT CSN',
              department: 'Student',
              isVerifiedStudent: json['isVerifiedStudent'] as bool? ?? true,
              trustRating: 5.0,
            ),
      lastMessage: (json['lastMessage'] ?? '').toString(),
      lastMessageTime: json['lastMessageTime'] != null
          ? DateTime.tryParse(json['lastMessageTime'].toString()) ?? DateTime.now()
          : DateTime.now(),
      unreadCount: json['unreadCount'] as int? ?? 0,
      isBlocked: json['isBlocked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resourceId': resourceId,
      'resourceTitle': resourceTitle,
      'resourceType': resourceType,
      'resourcePrice': resourcePrice,
      'resourceImageUrl': resourceImageUrl,
      'participant': participant.toJson(),
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'unreadCount': unreadCount,
      'isBlocked': isBlocked,
    };
  }

  ChatConversationModel copyWith({
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
    bool? isBlocked,
    ParticipantModel? participant,
  }) {
    return ChatConversationModel(
      id: id,
      resourceId: resourceId,
      resourceTitle: resourceTitle,
      resourceType: resourceType,
      resourcePrice: resourcePrice,
      resourceImageUrl: resourceImageUrl,
      participant: participant ?? this.participant,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }

  static List<ChatConversationModel> get mockConversations => const [];
}
