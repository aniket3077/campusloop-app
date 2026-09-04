import '../models/chat_message_model.dart';
import '../services/chat_service.dart';

class ChatRepository {
  final ChatService _chatService;

  ChatRepository({ChatService? chatService})
      : _chatService = chatService ?? CloudRunChatService();

  Future<List<ChatConversationModel>> getConversations() =>
      _chatService.getConversations();

  Future<ChatConversationModel?> createConversation({
    required String sellerId,
    String? itemId,
    String? initialMessage,
  }) =>
      _chatService.createConversation(
        sellerId: sellerId,
        itemId: itemId,
        initialMessage: initialMessage,
      );

  Future<List<ChatMessageModel>> getMessages(String conversationId) =>
      _chatService.getMessages(conversationId);

  Future<ChatMessageModel> sendMessage(
    String conversationId,
    String text, {
    double? priceOffer,
    String? itemId,
    String? sellerId,
  }) =>
      _chatService.sendMessage(
        conversationId,
        text,
        priceOffer: priceOffer,
        itemId: itemId,
        sellerId: sellerId,
      );

  Future<bool> blockUser(String conversationId, String userId) =>
      _chatService.blockUser(conversationId, userId);

  Future<bool> reportUser(String conversationId, String userId, String reason) =>
      _chatService.reportUser(conversationId, userId, reason);
}
