import 'package:flutter/material.dart';
import '../models/chat_message_model.dart';
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
      _conversations = await _repository.getConversations();
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

  Future<void> loadMessages(String conversationId) async {
    try {
      final msgs = await _repository.getMessages(conversationId);
      _conversationMessages[conversationId] = msgs;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> sendMessage(String conversationId, String text, {double? priceOffer}) async {
    try {
      final msg = await _repository.sendMessage(conversationId, text, priceOffer: priceOffer);
      if (!_conversationMessages.containsKey(conversationId)) {
        _conversationMessages[conversationId] = [];
      }
      _conversationMessages[conversationId]!.add(msg);
      await loadConversations();
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
