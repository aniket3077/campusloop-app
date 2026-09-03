import '../models/chat_message_model.dart';

abstract class ChatService {
  Future<List<ChatConversationModel>> getConversations();
  Future<List<ChatMessageModel>> getMessages(String conversationId);
  Future<ChatMessageModel> sendMessage(String conversationId, String text, {double? priceOffer});
}

class MockChatService implements ChatService {
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
  };

  @override
  Future<List<ChatConversationModel>> getConversations() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return ChatConversationModel.mockConversations;
  }

  @override
  Future<List<ChatMessageModel>> getMessages(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _messages[conversationId] ?? [];
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
    );
    if (!_messages.containsKey(conversationId)) {
      _messages[conversationId] = [];
    }
    _messages[conversationId]!.add(msg);
    return msg;
  }
}
