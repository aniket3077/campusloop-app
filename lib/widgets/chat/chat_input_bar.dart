import 'package:flutter/material.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onBargainOffer;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onBargainOffer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
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
            IconButton(
              icon: Icon(Icons.handshake_outlined, color: theme.colorScheme.primary),
              tooltip: 'Propose Price Offer',
              onPressed: onBargainOffer,
            ),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Type in-app message or pickup terms...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send_rounded, color: theme.colorScheme.primary),
              onPressed: onSend,
            ),
          ],
        ),
      ),
    );
  }
}
