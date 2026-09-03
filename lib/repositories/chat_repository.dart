import '../models/chat_message_model.dart';
import '../services/chat_service.dart';

class ChatRepository {
  final ChatService _chatService;

  ChatRepository({ChatService? chatService})
      : _chatService = chatService ?? MockChatService();

  Future<List<ChatConversationModel>> getConversations() =>
      _chatService.getConversations();

  Future<List<ChatMessageModel>> getMessages(String conversationId) =>
      _chatService.getMessages(conversationId);

  Future<ChatMessageModel> sendMessage(
    String conversationId,
    String text, {
    double? priceOffer,
  }) =>
      _chatService.sendMessage(conversationId, text, priceOffer: priceOffer);
}
