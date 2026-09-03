import '../models/chat_message_model.dart';

/// Service interface prepared for real-time WebSocket / FCM messaging on Google Cloud backend
abstract class ChatService {
  Future<List<ChatConversationModel>> getConversations();
  Future<List<ChatMessageModel>> getMessages(String conversationId);
  Future<ChatMessageModel> sendMessage(String conversationId, String text, {double? priceOffer});
  Future<bool> blockUser(String conversationId, String userId);
  Future<bool> reportUser(String conversationId, String userId, String reason);
}

/// Cloud Run / WebSocket Real-time Chat Service Implementation
class CloudRunChatService implements ChatService {
  final List<ChatConversationModel> _conversations = List.from(ChatConversationModel.mockConversations);

  final Map<String, List<ChatMessageModel>> _messages = {
    'conv_001': [
      ChatMessageModel(
        id: 'msg_001',
        conversationId: 'conv_001',
        senderId: 'user_102',
        senderName: 'Marcus Chen',
        text: 'Hi Alex! The Linear Algebra textbook is still available.',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isMine: false,
      ),
      ChatMessageModel(
        id: 'msg_002',
        conversationId: 'conv_001',
        senderId: 'user_101',
        senderName: 'Alex Rivera',
        text: 'Great! Would you accept \$30 for campus pickup today?',
        priceOffer: 30.0,
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        isMine: true,
        isOffer: true,
        offerStatus: 'ACCEPTED',
      ),
      ChatMessageModel(
        id: 'msg_003',
        conversationId: 'conv_001',
        senderId: 'user_102',
        senderName: 'Marcus Chen',
        text: 'I can meet at Engineering Quad at 2 PM today!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
        isMine: false,
      ),
    ],
    'conv_002': [
      ChatMessageModel(
        id: 'msg_101',
        conversationId: 'conv_002',
        senderId: 'user_103',
        senderName: 'Sophia Patel',
        text: 'Hi Alex! Offering \$5.00 for 10 days borrow of the TI-84 calculator.',
        priceOffer: 5.0,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isMine: false,
        isOffer: true,
        offerStatus: 'PENDING',
      ),
    ],
  };

  @override
  Future<List<ChatConversationModel>> getConversations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_conversations);
  }

  @override
  Future<List<ChatMessageModel>> getMessages(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_messages[conversationId] ?? []);
  }

  @override
  Future<ChatMessageModel> sendMessage(String conversationId, String text, {double? priceOffer}) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final msg = ChatMessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: 'user_101',
      senderName: 'Alex Rivera',
      text: text,
      priceOffer: priceOffer,
      timestamp: DateTime.now(),
      isMine: true,
      isOffer: priceOffer != null,
      offerStatus: priceOffer != null ? 'PENDING' : null,
      isRead: true,
    );

    if (!_messages.containsKey(conversationId)) {
      _messages[conversationId] = [];
    }
    _messages[conversationId]!.add(msg);

    // Update conversation last message
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      _conversations[index] = _conversations[index].copyWith(
        lastMessage: text,
        lastMessageTime: DateTime.now(),
      );
    }

    return msg;
  }

  @override
  Future<bool> blockUser(String conversationId, String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      final updatedParticipant = _conversations[index].participant.copyWith(isBlocked: true);
      _conversations[index] = _conversations[index].copyWith(
        isBlocked: true,
        participant: updatedParticipant,
      );
    }
    return true;
  }

  @override
  Future<bool> reportUser(String conversationId, String userId, String reason) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
}
