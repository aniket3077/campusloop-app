import 'package:flutter/material.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/utils/formatters.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/common/resource_type_chip.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chatProvider = AppStateProvider.of(context).chatProvider;

    return Scaffold(
      appBar: AppBar(
        title: const Text('In-App Campus Messages'),
      ),
      body: ListenableBuilder(
        listenable: chatProvider,
        builder: (context, _) {
          if (chatProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final conversations = chatProvider.conversations.where((c) {
            if (_searchQuery.isEmpty) return true;
            final query = _searchQuery.toLowerCase();
            final matchName = c.otherParticipantName.toLowerCase().contains(query);
            final matchTitle = c.resourceTitle.toLowerCase().contains(query);
            final matchMsg = c.lastMessage.toLowerCase().contains(query);
            return matchName || matchTitle || matchMsg;
          }).toList();

          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val.trim()),
                  decoration: const InputDecoration(
                    hintText: 'Search chats by student name or item...',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
              ),

              Expanded(
                child: conversations.isEmpty
                    ? const EmptyStateWidget(
                        icon: Icons.chat_outlined,
                        title: 'No Active Campus Conversations',
                        message: 'When you express interest in a resource or receive a bargain proposal, your in-app chat will appear here.',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: conversations.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final conv = conversations[index];
                          final isBlocked = conv.isBlocked || conv.participant.isBlocked;

                          return ListTile(
                            leading: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: isBlocked
                                      ? Colors.grey
                                      : theme.colorScheme.primary,
                                  child: Text(
                                    conv.otherParticipantAvatar,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                if (conv.isVerifiedStudent)
                                  const Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: CircleAvatar(
                                      radius: 8,
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.verified,
                                        size: 14,
                                        color: Color(0xFF0284C7),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    conv.otherParticipantName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isBlocked ? Colors.grey : theme.colorScheme.onSurface,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                ResourceTypeChip(resourceType: conv.resourceType),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 2),
                                Text(
                                  'Item: ${conv.resourceTitle}',
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
                                  isBlocked ? '[User Blocked]' : conv.lastMessage,
                                  style: TextStyle(
                                    color: conv.unreadCount > 0
                                        ? theme.colorScheme.onSurface
                                        : theme.colorScheme.onSurfaceVariant,
                                    fontWeight: conv.unreadCount > 0
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  Formatters.formatRelativeTime(conv.lastMessageTime),
                                  style: theme.textTheme.bodySmall,
                                ),
                                const SizedBox(height: 4),
                                if (conv.unreadCount > 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '${conv.unreadCount}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
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
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
