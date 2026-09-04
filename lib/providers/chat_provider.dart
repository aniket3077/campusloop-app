import 'package:flutter/material.dart';
import '../models/academic_resource_model.dart';
import '../models/chat_message_model.dart';
import '../models/user_model.dart';
import '../repositories/chat_repository.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository _repository;

  List<ChatConversationModel> _conversations = [];
  final Map<String, List<ChatMessageModel>> _conversationMessages = {};
  bool _isLoading = false;

  ChatProvider({ChatRepository? repository})
      : _repository = repository ?? ChatRepository() {
    loadConversations();
  }

  List<ChatConversationModel> get conversations => _conversations;
  bool get isLoading => _isLoading;

  Future<void> loadConversations() async {
    _isLoading = true;
    notifyListeners();
    try {
      final remoteConvs = await _repository.getConversations();
      if (remoteConvs.isNotEmpty) {
        // Merge with any locally initiated conversations
        final existingIds = remoteConvs.map((c) => c.id).toSet();
        final localOnly = _conversations.where((c) => !existingIds.contains(c.id)).toList();
        _conversations = [...localOnly, ...remoteConvs];
      }
    } catch (_) {
      // Keep local conversations on error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<ChatMessageModel> getMessages(String conversationId) {
    return _conversationMessages[conversationId] ?? [];
  }

  ChatConversationModel? getConversationById(String conversationId) {
    try {
      return _conversations.firstWhere((c) => c.id == conversationId);
    } catch (_) {
      return null;
    }
  }

  /// Automatically connects buyer to seller for a specific listing
  ChatConversationModel getOrCreateConversationForResource({
    required AcademicResourceModel resource,
    UserModel? currentUser,
  }) {
    // 1. Check if conversation for this resource already exists
    final existing = _conversations.where((c) => c.resourceId == resource.id).firstOrNull;
    if (existing != null) {
      return existing;
    }

    // 2. Create a new conversation for this specific item and seller
    final convId = 'conv_${resource.id}_${DateTime.now().millisecondsSinceEpoch}';
    final newConv = ChatConversationModel(
      id: convId,
      resourceId: resource.id,
      resourceTitle: resource.title,
      resourceType: resource.resourceType,
      resourcePrice: resource.price,
      resourceImageUrl: resource.imageUrls.isNotEmpty ? resource.imageUrls.first : null,
      participant: ParticipantModel(
        id: resource.sellerId,
        name: resource.sellerName,
        university: resource.university,
        department: 'Campus Student',
        isVerifiedStudent: resource.isVerifiedSeller,
        trustRating: resource.sellerRating,
      ),
      lastMessage: 'Started chat about ${resource.title}',
      lastMessageTime: DateTime.now(),
      unreadCount: 0,
    );

    _conversations.insert(0, newConv);

    // Add initial inquiry message so the chat isn't blank
    _conversationMessages[convId] = [
      ChatMessageModel(
        id: 'msg_init_${DateTime.now().millisecondsSinceEpoch}',
        conversationId: convId,
        senderId: currentUser?.id ?? 'buyer_101',
        senderName: currentUser?.name ?? 'Alex Rivera',
        text: 'Hi ${resource.sellerName}! I saw your listing "${resource.title}". Is it still available on campus?',
        timestamp: DateTime.now(),
        isMine: true,
      ),
    ];

    notifyListeners();
    return newConv;
  }

  Future<void> loadMessages(String conversationId) async {
    try {
      final msgs = await _repository.getMessages(conversationId);
      if (msgs.isNotEmpty) {
        _conversationMessages[conversationId] = msgs;
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> sendMessage(String conversationId, String text, {double? priceOffer}) async {
    // 1. Immediately create and add message locally so the UI updates instantly!
    final tempMsg = ChatMessageModel(
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

    if (!_conversationMessages.containsKey(conversationId)) {
      _conversationMessages[conversationId] = [];
    }
    _conversationMessages[conversationId]!.add(tempMsg);

    // Update conversation preview in list
    final idx = _conversations.indexWhere((c) => c.id == conversationId);
    if (idx != -1) {
      _conversations[idx] = _conversations[idx].copyWith(
        lastMessage: text,
        lastMessageTime: DateTime.now(),
      );
    }
    notifyListeners();

    // 2. Persist in background without blocking UI
    try {
      await _repository.sendMessage(conversationId, text, priceOffer: priceOffer);
    } catch (_) {}
  }

  Future<bool> blockUser(String conversationId, String userId) async {
    try {
      final res = await _repository.blockUser(conversationId, userId);
      await loadConversations();
      return res;
    } catch (_) {
      return false;
    }
  }

  Future<bool> reportUser(String conversationId, String userId, String reason) async {
    try {
      return await _repository.reportUser(conversationId, userId, reason);
    } catch (_) {
      return false;
    }
  }
}
