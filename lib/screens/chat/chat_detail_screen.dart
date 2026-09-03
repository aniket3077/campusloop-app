import 'package:flutter/material.dart';
import '../../core/utils/formatters.dart';
import '../../providers/app_state_provider.dart';

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
  final _offerController = TextEditingController();
  bool _showOfferInput = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppStateProvider.of(context).chatProvider.loadMessages(widget.conversationId);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _offerController.dispose();
    super.dispose();
  }

  void _sendMessage({double? priceOffer}) {
    final text = _textController.text.trim();
    if (text.isEmpty && priceOffer == null) return;

    final chatProvider = AppStateProvider.of(context).chatProvider;
    chatProvider.sendMessage(
      widget.conversationId,
      text.isEmpty ? 'Proposed a price offer of \$${priceOffer?.toStringAsFixed(2)}' : text,
      priceOffer: priceOffer,
    );

    _textController.clear();
    _offerController.clear();
    setState(() => _showOfferInput = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chatProvider = AppStateProvider.of(context).chatProvider;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Marcus Chen', style: TextStyle(fontSize: 16)),
            Text('Stanford University Student', style: TextStyle(fontSize: 11)),
          ],
        ),
      ),
      body: ListenableBuilder(
        listenable: chatProvider,
        builder: (context, _) {
          final messages = chatProvider.getMessages(widget.conversationId);

          return Column(
            children: [
              // Chat Header Item Reference
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
                child: Row(
                  children: [
                    Icon(Icons.menu_book, color: theme.colorScheme.primary),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Linear Algebra & Its Applications',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Text('Listed price: \$35.00', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        setState(() => _showOfferInput = !_showOfferInput);
                      },
                      child: const Text('Make Offer', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),

              // Offer Input Box if active
              if (_showOfferInput)
                Container(
                  padding: const EdgeInsets.all(12),
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _offerController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Enter offer price (\$)',
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          final offer = double.tryParse(_offerController.text);
                          if (offer != null) {
                            _sendMessage(priceOffer: offer);
                          }
                        },
                        child: const Text('Send Offer'),
                      ),
                    ],
                  ),
                ),

              // Chat Messages List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMine = msg.isMine;

                    return Align(
                      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        decoration: BoxDecoration(
                          color: isMine
                              ? theme.colorScheme.primary
                              : theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: Radius.circular(isMine ? 16 : 4),
                            bottomRight: Radius.circular(isMine ? 4 : 16),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (msg.isOffer) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade700,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'BARGAIN OFFER: \$${msg.priceOffer?.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                            ],
                            Text(
                              msg.text,
                              style: TextStyle(
                                color: isMine ? Colors.white : theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                Formatters.formatRelativeTime(msg.timestamp),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isMine
                                      ? Colors.white.withValues(alpha: 0.7)
                                      : theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom Input Bar
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            hintText: 'Type a message or proposed pickup time...',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send_rounded, color: theme.colorScheme.primary),
                        onPressed: () => _sendMessage(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
