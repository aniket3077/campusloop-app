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

  int get totalUnreadCount => _conversations.fold<int>(0, (sum, c) => sum + c.unreadCount);

  void markConversationRead(String conversationId) {
    final idx = _conversations.indexWhere((c) => c.id == conversationId);
    if (idx != -1 && _conversations[idx].unreadCount > 0) {
      _conversations[idx] = _conversations[idx].copyWith(unreadCount: 0);
      notifyListeners();
    }
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
            id: 'buyer_sophia',
            name: 'Sophia Patel (Buyer)',
            university: 'Stanford University',
            department: 'Computer Science',
            isVerifiedStudent: true,
            trustRating: 4.9,
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
