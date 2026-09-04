import 'package:flutter/material.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/chat/chat_input_bar.dart';
import '../../widgets/chat/item_preview_card.dart';
import '../../widgets/chat/message_bubble.dart';
import '../../widgets/chat/offer_card_widget.dart';
import '../../widgets/chat/offer_dialog.dart';
import '../../widgets/chat/report_block_dialog.dart';

class ChatDetailScreen extends StatefulWidget {
  final String conversationId;

  const ChatDetailScreen({
    super.key,
    required this.conversationId,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppStateProvider.of(context).chatProvider.loadMessages(widget.conversationId).then((_) {
        _scrollToBottom();
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final chatProvider = AppStateProvider.of(context).chatProvider;
    chatProvider.sendMessage(widget.conversationId, text);
    _textController.clear();
    _scrollToBottom();
  }

  void _openOfferDialog(String itemId, String title, double originalPrice) {
    OfferDialog.show(
      context,
      itemId: itemId,
      itemTitle: title,
      originalPrice: originalPrice,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = AppStateProvider.of(context);
    final chatProvider = appState.chatProvider;
    final offerProvider = appState.offerProvider;
    final conversation = chatProvider.getConversationById(widget.conversationId);

    final isBlocked = conversation?.isBlocked ?? false;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: theme.colorScheme.primary,
              child: Text(
                conversation?.otherParticipantAvatar ?? 'M',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        conversation?.otherParticipantName ?? 'Marcus Chen',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      if (conversation?.isVerifiedStudent ?? true) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.verified, size: 14, color: Color(0xFF0284C7)),
                      ],
                    ],
                  ),
                  Text(
                    conversation?.participant.university ?? 'Stanford University',
                    style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shield_outlined),
            tooltip: 'Safety & Moderation',
            onPressed: () {
              if (conversation != null) {
                ReportBlockDialog.showOptions(
                  context: context,
                  conversation: conversation,
                );
              }
            },
          ),
          PopupMenuButton<String>(
            onSelected: (val) {
              if (conversation == null) return;
              if (val == 'report' || val == 'block') {
                ReportBlockDialog.showOptions(
                  context: context,
                  conversation: conversation,
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    Icon(Icons.flag_outlined, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Text('Report User'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'block',
                child: Row(
                  children: [
                    Icon(Icons.block_outlined, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text('Block User'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([chatProvider, offerProvider]),
        builder: (context, _) {
          final messages = chatProvider.getMessages(widget.conversationId);
          final activeOffer = conversation != null
              ? offerProvider.offers.where((o) => o.itemId == conversation.resourceId || conversation.resourceId.contains('res')).firstOrNull
              : null;

          return Column(
            children: [
              // Item Preview Card inside Chat
              if (conversation != null)
                ItemPreviewCard(
                  resourceId: conversation.resourceId,
                  resourceTitle: conversation.resourceTitle,
                  resourceType: conversation.resourceType,
                  resourcePrice: conversation.resourcePrice,
                  onMakeOffer: () => _openOfferDialog(
                    conversation.resourceId,
                    conversation.resourceTitle,
                    conversation.resourcePrice,
                  ),
                ),

              // Active Offer Card if available
              if (activeOffer != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: OfferCardWidget(
                    offer: activeOffer,
                    onCounterOffer: () {
                      OfferDialog.show(
                        context,
                        itemId: activeOffer.itemId,
                        itemTitle: activeOffer.itemTitle,
                        originalPrice: activeOffer.originalPrice,
                        parentOffer: activeOffer,
                      );
                    },
                  ),
                ),

              // Blocked User Banner
              if (isBlocked)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  color: Colors.red.shade100,
                  child: const Text(
                    'You have blocked this user. Unblock to resume messaging.',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Message List
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return MessageBubble(message: msg);
                  },
                ),
              ),

              // Message Input Bar
              if (!isBlocked)
                ChatInputBar(
                  controller: _textController,
                  onSend: _sendMessage,
                  onBargainOffer: () {
                    if (conversation != null) {
                      _openOfferDialog(
                        conversation.resourceId,
                        conversation.resourceTitle,
                        conversation.resourcePrice,
                      );
                    }
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
