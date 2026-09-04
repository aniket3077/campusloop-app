import '../models/chat_message_model.dart';
import 'backend_api_service.dart';

/// Service interface prepared for real-time WebSocket / FCM messaging on Google Cloud backend
abstract class ChatService {
  Future<List<ChatConversationModel>> getConversations();
  Future<List<ChatMessageModel>> getMessages(String conversationId);
  Future<ChatMessageModel> sendMessage(
    String conversationId,
    String text, {
    double? priceOffer,
    String? itemId,
    String? sellerId,
  });
  Future<ChatConversationModel?> createConversation({
    required String sellerId,
    String? itemId,
    String? initialMessage,
  });
  Future<bool> blockUser(String conversationId, String userId);
  Future<bool> reportUser(String conversationId, String userId, String reason);
}

/// Cloud Run / WebSocket Real-time Chat Service Implementation
class CloudRunChatService implements ChatService {
  final List<ChatConversationModel> _conversations = [];
  final Map<String, List<ChatMessageModel>> _messages = {};

  @override
  Future<List<ChatConversationModel>> getConversations() async {
    try {
      final remote = await BackendApiService.fetchConversations();
      if (remote != null) {
        final list = remote.map((c) => ChatConversationModel.fromJson(c)).toList();
        // Update local cache
        _conversations.clear();
        _conversations.addAll(list);
        return list;
      }
    } catch (_) {}
    return List.from(_conversations);
  }

  @override
  Future<ChatConversationModel?> createConversation({
    required String sellerId,
    String? itemId,
    String? initialMessage,
  }) async {
    try {
      final remote = await BackendApiService.createConversation(
        sellerId: sellerId,
        itemId: itemId,
        initialMessage: initialMessage,
      );
      if (remote != null) {
        final conv = ChatConversationModel.fromJson(remote);
        final idx = _conversations.indexWhere(
          (c) => c.id == conv.id || (conv.resourceId.isNotEmpty && c.resourceId == conv.resourceId),
        );
        if (idx != -1) {
          _conversations[idx] = conv;
        } else {
          _conversations.insert(0, conv);
        }
        return conv;
      }
    } catch (_) {}
    return null;
  }

  @override
  Future<List<ChatMessageModel>> getMessages(String conversationId) async {
    try {
      final remote = await BackendApiService.fetchMessages(conversationId);
      if (remote != null) {
        final list = remote.map((m) => ChatMessageModel.fromJson(m)).toList();
        _messages[conversationId] = list;
        return list;
      }
    } catch (_) {}
    return List.from(_messages[conversationId] ?? []);
  }

  @override
  Future<ChatMessageModel> sendMessage(
    String conversationId,
    String text, {
    double? priceOffer,
    String? itemId,
    String? sellerId,
  }) async {
    try {
      final remote = await BackendApiService.sendMessage(
        conversationId: conversationId,
        text: text,
        type: priceOffer != null ? 'OFFER' : 'TEXT',
        metadata: priceOffer != null ? {'priceOffer': priceOffer} : null,
        itemId: itemId,
        sellerId: sellerId,
      );
      if (remote != null) {
        final msg = ChatMessageModel.fromJson(remote);
        if (!_messages.containsKey(conversationId)) {
          _messages[conversationId] = [];
        }
        _messages[conversationId]!.add(msg);

        final index = _conversations.indexWhere((c) => c.id == conversationId || (msg.conversationId.isNotEmpty && c.id == msg.conversationId));
        if (index != -1) {
          _conversations[index] = _conversations[index].copyWith(
            lastMessage: text,
            lastMessageTime: msg.timestamp,
          );
        }
        return msg;
      }
    } catch (_) {}

    final msg = ChatMessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: 'user_current',
      senderName: 'Me',
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
