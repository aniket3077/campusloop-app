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
        _conversations = remoteConvs;
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
      return _conversations.firstWhere(
        (c) => c.id == conversationId || (c.resourceId.isNotEmpty && c.resourceId == conversationId),
      );
    } catch (_) {
      return null;
    }
  }

  int get totalUnreadCount => _conversations.fold<int>(0, (sum, c) => sum + c.unreadCount);

  void markConversationRead(String conversationId) {
    final idx = _conversations.indexWhere((c) => c.id == conversationId);
    if (idx != -1 && _conversations[idx].unreadCount > 0) {
      _conversations[idx] = _conversations[idx].copyWith(unreadCount: 0);
      notifyListeners();
    }
  }

  /// Ensures conversation exists on backend and returns the real model
  Future<ChatConversationModel> ensureConversationOnBackend({
    required AcademicResourceModel resource,
    UserModel? currentUser,
    bool asSeller = false,
  }) async {
    // 1. Check if real conversation for this resource already exists
    final existing = _conversations.where(
      (c) => c.resourceId == resource.id && !c.id.startsWith('conv_'),
    ).firstOrNull;
    if (existing != null) {
      return existing;
    }

    try {
      final remote = await _repository.createConversation(
        sellerId: resource.sellerId,
        itemId: resource.id,
      );
      if (remote != null) {
        final idx = _conversations.indexWhere(
          (c) => c.id == remote.id || (resource.id.isNotEmpty && c.resourceId == resource.id),
        );
        if (idx != -1) {
          _conversations[idx] = remote;
        } else {
          _conversations.insert(0, remote);
        }
        notifyListeners();
        return remote;
      }
    } catch (e) {
      debugPrint('[ChatProvider] ensureConversationOnBackend error: $e');
    }

    // 2. Fallback to local conversation
    return getOrCreateConversationForResource(
      resource: resource,
      currentUser: currentUser,
      asSeller: asSeller,
    );
  }

  /// Automatically connects buyer to seller for a specific listing
  ChatConversationModel getOrCreateConversationForResource({
    required AcademicResourceModel resource,
    UserModel? currentUser,
    bool asSeller = false,
  }) {
    // 1. Check if conversation for this resource already exists
    final existing = _conversations.where((c) => c.resourceId == resource.id).firstOrNull;
    if (existing != null) {
      return existing;
    }

    final isUserSeller = asSeller || (currentUser != null &&
        (currentUser.id == resource.sellerId ||
         (currentUser.name.isNotEmpty && currentUser.name.toLowerCase() == resource.sellerName.toLowerCase())));

    final convId = 'conv_${resource.id}_${DateTime.now().millisecondsSinceEpoch}';

    final participant = isUserSeller
        ? const ParticipantModel(
            id: 'buyer_student',
            name: 'Campus Buyer',
            university: 'MIT CSN',
            department: 'Student',
            isVerifiedStudent: true,
            trustRating: 5.0,
          )
        : ParticipantModel(
            id: resource.sellerId,
            name: resource.sellerName,
            university: resource.university,
            department: 'Campus Student',
            isVerifiedStudent: resource.isVerifiedSeller,
            trustRating: resource.sellerRating,
          );

    final initialText = isUserSeller
        ? 'Hi ${resource.sellerName}! I saw your listing "${resource.title}". Is it still available for campus pickup today?'
        : 'Hi ${resource.sellerName}! I saw your listing "${resource.title}". Is it still available on campus?';

    final newConv = ChatConversationModel(
      id: convId,
      resourceId: resource.id,
      resourceTitle: resource.title,
      resourceType: resource.resourceType,
      resourcePrice: resource.price,
      resourceImageUrl: resource.imageUrls.isNotEmpty ? resource.imageUrls.first : null,
      participant: participant,
      lastMessage: initialText,
      lastMessageTime: DateTime.now(),
      unreadCount: isUserSeller ? 1 : 0,
    );

    _conversations.insert(0, newConv);

    // Add initial message
    _conversationMessages[convId] = [
      ChatMessageModel(
        id: 'msg_init_${DateTime.now().millisecondsSinceEpoch}',
        conversationId: convId,
        senderId: isUserSeller ? participant.id : (currentUser?.id ?? 'buyer_101'),
        senderName: isUserSeller ? participant.name : (currentUser?.name ?? 'Alex Rivera'),
        text: initialText,
        timestamp: DateTime.now(),
        isMine: !isUserSeller,
      ),
    ];

    notifyListeners();

    // Asynchronously create/resolve on backend and replace convId with real UUID
    _syncConversationWithBackend(resource: resource, tempId: convId, initialMessage: initialText);

    return newConv;
  }

  void _syncConversationWithBackend({
    required AcademicResourceModel resource,
    required String tempId,
    String? initialMessage,
  }) async {
    try {
      final remote = await _repository.createConversation(
        sellerId: resource.sellerId,
        itemId: resource.id,
        initialMessage: initialMessage,
      );
      if (remote != null && remote.id != tempId) {
        _replaceConversationId(tempId, remote.id, remoteConv: remote);
      }
    } catch (e) {
      debugPrint('[ChatProvider] _syncConversationWithBackend notice: $e');
    }
  }

  void _replaceConversationId(String oldId, String newId, {ChatConversationModel? remoteConv}) {
    final idx = _conversations.indexWhere((c) => c.id == oldId);
    if (idx != -1) {
      final old = _conversations[idx];
      _conversations[idx] = remoteConv ??
          ChatConversationModel(
            id: newId,
            resourceId: old.resourceId,
            resourceTitle: old.resourceTitle,
            resourceType: old.resourceType,
            resourcePrice: old.resourcePrice,
            resourceImageUrl: old.resourceImageUrl,
            participant: old.participant,
            lastMessage: old.lastMessage,
            lastMessageTime: old.lastMessageTime,
            unreadCount: old.unreadCount,
            isBlocked: old.isBlocked,
          );
    }
    if (_conversationMessages.containsKey(oldId)) {
      final oldMsgs = _conversationMessages.remove(oldId)!;
      final existingNew = _conversationMessages[newId] ?? [];
      _conversationMessages[newId] = [
        ...existingNew,
        ...oldMsgs.map((m) => ChatMessageModel(
              id: m.id,
              conversationId: newId,
              senderId: m.senderId,
              senderName: m.senderName,
              text: m.text,
              priceOffer: m.priceOffer,
              timestamp: m.timestamp,
              isMine: m.isMine,
              isOffer: m.isOffer,
              offerStatus: m.offerStatus,
              isRead: m.isRead,
            )),
      ];
    }
    notifyListeners();
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

  Future<void> sendMessage(
    String conversationId,
    String text, {
    double? priceOffer,
    String? senderId,
    String? senderName,
  }) async {
    // 1. Immediately create and add message locally so the UI updates instantly!
    final tempMsg = ChatMessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: senderId ?? 'user_current',
      senderName: senderName ?? 'Me',
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
    String? resolvedItemId;
    String? resolvedSellerId;
    if (idx != -1) {
      _conversations[idx] = _conversations[idx].copyWith(
        lastMessage: text,
        lastMessageTime: DateTime.now(),
      );
      resolvedItemId = _conversations[idx].resourceId;
      resolvedSellerId = _conversations[idx].participant.id;
    }
    notifyListeners();

    // 2. Persist in background without blocking UI
    try {
      final remoteMsg = await _repository.sendMessage(
        conversationId,
        text,
        priceOffer: priceOffer,
        itemId: resolvedItemId,
        sellerId: resolvedSellerId,
      );

      // If backend returned a different real conversationId than the temporary client id
      if (remoteMsg.conversationId.isNotEmpty && remoteMsg.conversationId != conversationId) {
        _replaceConversationId(conversationId, remoteMsg.conversationId);
      }
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
