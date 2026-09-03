import 'package:flutter/material.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/utils/formatters.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/common/resource_type_chip.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chatProvider = AppStateProvider.of(context).chatProvider;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Bargaining & Chat'),
      ),
      body: ListenableBuilder(
        listenable: chatProvider,
        builder: (context, _) {
          if (chatProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (chatProvider.conversations.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.chat_outlined,
              title: 'No Active Student Chats',
              message: 'When you express interest in a textbook or resource, your chat will appear here.',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: chatProvider.conversations.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final conv = chatProvider.conversations[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primary,
                  child: Text(
                    conv.otherParticipantAvatar,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        conv.otherParticipantName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ResourceTypeChip(resourceType: conv.resourceType),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    Text(
                      conv.resourceTitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      conv.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                trailing: Text(
                  Formatters.formatRelativeTime(conv.lastMessageTime),
                  style: theme.textTheme.bodySmall,
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.chatDetail,
                    arguments: conv.id,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
