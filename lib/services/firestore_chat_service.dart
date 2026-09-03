import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../core/firebase/firebase_manager.dart';
import '../models/chat_message_model.dart';
import 'chat_service.dart';

/// Concrete Google Cloud Firestore implementation of [ChatService]
class FirestoreChatService implements ChatService {
  final FirebaseFirestore? _firestore;
  final ChatService _fallbackService;

  FirestoreChatService({
    FirebaseFirestore? firestore,
    ChatService? fallbackService,
  })  : _firestore = firestore ?? FirebaseManager.firestore,
        _fallbackService = fallbackService ?? CloudRunChatService();

  CollectionReference<Map<String, dynamic>>? get _chatsCol {
    final db = _firestore ?? FirebaseManager.firestore;
    return db?.collection(FirebaseManager.colChats);
  }

  @override
  Future<List<ChatConversationModel>> getConversations() async {
    final col = _chatsCol;
    if (col == null) return _fallbackService.getConversations();

    try {
      final snapshot = await col.orderBy('lastMessageTime', descending: true).get();
      if (snapshot.docs.isEmpty) {
        return _fallbackService.getConversations();
      }

      return snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return ChatConversationModel.fromJson(data);
      }).toList();
    } catch (e) {
      debugPrint('[FirestoreChatService] Error getting conversations: $e');
      return _fallbackService.getConversations();
    }
  }

  @override
  Future<List<ChatMessageModel>> getMessages(String conversationId) async {
    final col = _chatsCol;
    if (col == null) return _fallbackService.getMessages(conversationId);

    try {
      final snapshot = await col
          .doc(conversationId)
          .collection(FirebaseManager.colMessages)
          .orderBy('timestamp', descending: false)
          .get();

      if (snapshot.docs.isEmpty) {
        return _fallbackService.getMessages(conversationId);
      }

      return snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return ChatMessageModel.fromJson(data);
      }).toList();
    } catch (e) {
      debugPrint('[FirestoreChatService] Error getting messages: $e');
      return _fallbackService.getMessages(conversationId);
    }
  }

  @override
  Future<ChatMessageModel> sendMessage(
    String conversationId,
    String text, {
    double? priceOffer,
  }) async {
    final col = _chatsCol;
    if (col == null) {
      return _fallbackService.sendMessage(conversationId, text, priceOffer: priceOffer);
    }

    try {
      final messageId = 'msg_${DateTime.now().millisecondsSinceEpoch}';
      final currentUserId = FirebaseManager.auth?.currentUser?.uid ?? 'user_101';
      final currentUserName = FirebaseManager.auth?.currentUser?.displayName ?? 'Alex Rivera';

      final msg = ChatMessageModel(
        id: messageId,
        conversationId: conversationId,
        senderId: currentUserId,
        senderName: currentUserName,
        text: text,
        priceOffer: priceOffer,
        timestamp: DateTime.now(),
        isMine: true,
        isOffer: priceOffer != null,
        offerStatus: priceOffer != null ? 'PENDING' : null,
      );

      final msgData = msg.toJson();
      await col
          .doc(conversationId)
          .collection(FirebaseManager.colMessages)
          .doc(messageId)
          .set(msgData);

      // Update parent conversation
      await col.doc(conversationId).set({
        'lastMessage': text,
        'lastMessageTime': DateTime.now().toIso8601String(),
      }, SetOptions(merge: true));

      return msg;
    } catch (e) {
      debugPrint('[FirestoreChatService] Error sending message: $e');
      return _fallbackService.sendMessage(conversationId, text, priceOffer: priceOffer);
    }
  }

  @override
  Future<bool> blockUser(String conversationId, String userId) async {
    final col = _chatsCol;
    if (col != null) {
      try {
        await col.doc(conversationId).update({'isBlocked': true});
        return true;
      } catch (e) {
        debugPrint('[FirestoreChatService] Error blocking user: $e');
      }
    }
    return _fallbackService.blockUser(conversationId, userId);
  }

  @override
  Future<bool> reportUser(String conversationId, String userId, String reason) async {
    final db = _firestore ?? FirebaseManager.firestore;
    if (db != null) {
      try {
        await db.collection(FirebaseManager.colReports).add({
          'conversationId': conversationId,
          'targetUserId': userId,
          'reason': reason,
          'reportedAt': DateTime.now().toIso8601String(),
          'reporterId': FirebaseManager.auth?.currentUser?.uid ?? 'user_101',
        });
        return true;
      } catch (e) {
        debugPrint('[FirestoreChatService] Error reporting user: $e');
      }
    }
    return _fallbackService.reportUser(conversationId, userId, reason);
  }

  /// Real-time live Firestore stream for conversation messages
  Stream<List<ChatMessageModel>> watchMessages(String conversationId) {
    final col = _chatsCol;
    if (col == null) {
      return Stream.fromFuture(getMessages(conversationId));
    }

    return col
        .doc(conversationId)
        .collection(FirebaseManager.colMessages)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return ChatMessageModel.fromJson(data);
      }).toList();
    });
  }
}
