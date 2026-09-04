import 'package:flutter/material.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/utils/formatters.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/resource_type_chip.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedFilter = 0; // 0: All, 1: Selling (Buyers), 2: Buying (Sellers)

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = AppStateProvider.of(context);
    final chatProvider = appState.chatProvider;
    final currentUser = appState.authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('In-App Campus Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Chats',
            onPressed: () => chatProvider.loadConversations(),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: chatProvider,
        builder: (context, _) {
          if (chatProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final allConversations = chatProvider.conversations;

          final filtered = allConversations.where((c) {
            // Search match
            if (_searchQuery.isNotEmpty) {
              final query = _searchQuery.toLowerCase();
              final matchName = c.otherParticipantName.toLowerCase().contains(query);
              final matchTitle = c.resourceTitle.toLowerCase().contains(query);
              final matchMsg = c.lastMessage.toLowerCase().contains(query);
              if (!matchName && !matchTitle && !matchMsg) return false;
            }

            // Filter match
            final isBuyerInquiry = c.otherParticipantName.toLowerCase().contains('buyer') ||
                c.participant.department.toLowerCase().contains('buyer') ||
                c.id.startsWith('conv_res_') ||
                (currentUser != null && c.participant.id != currentUser.id && c.lastMessage.contains('Hi'));

            if (_selectedFilter == 1) {
              // Selling (messages from buyers)
              return isBuyerInquiry;
            } else if (_selectedFilter == 2) {
              // Buying (messages with sellers)
              return !isBuyerInquiry;
            }
            return true;
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

              // Filter Chips (All, Selling/Buyers, Buying/Sellers)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Row(
                  children: [
                    _buildFilterChip(0, 'All Chats (${allConversations.length})'),
                    const SizedBox(width: 8),
                    _buildFilterChip(1, '🛒 Buyers Inquiring'),
                    const SizedBox(width: 8),
                    _buildFilterChip(2, '🏷️ Sellers Contacted'),
                  ],
                ),
              ),
              const SizedBox(height: 4),

              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.chat_bubble_outline_rounded, size: 64, color: Colors.grey.shade400),
                              const SizedBox(height: 16),
                              Text(
                                _selectedFilter == 1
                                    ? 'No Buyer Inquiries Yet'
                                    : _selectedFilter == 2
                                        ? 'No Active Seller Chats'
                                        : 'No Active Campus Conversations',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _selectedFilter == 1
                                    ? 'When students express interest in your items or make price offers, their chats will appear here!'
                                    : 'Explore products on the campus marketplace and tap "Chat with Seller" to connect directly.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: filtered.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final conv = filtered[index];
                          final isBlocked = conv.isBlocked || conv.participant.isBlocked;
                          final isBuyerChat = conv.otherParticipantName.toLowerCase().contains('buyer') ||
                              conv.participant.department.toLowerCase().contains('buyer');

                          return ListTile(
                            leading: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: isBlocked
                                      ? Colors.grey
                                      : (isBuyerChat ? const Color(0xFF10B981) : theme.colorScheme.primary),
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
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isBuyerChat ? const Color(0xFFDCFCE7) : const Color(0xFFEEF2FF),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    isBuyerChat ? 'Buyer' : 'Seller',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isBuyerChat ? const Color(0xFF15803D) : const Color(0xFF4338CA),
                                    ),
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
                              chatProvider.markConversationRead(conv.id);
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

  Widget _buildFilterChip(int index, String label) {
    final isSelected = _selectedFilter == index;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => _selectedFilter = index),
      selectedColor: const Color(0xFF4F46E5).withValues(alpha: 0.15),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF64748B),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        fontSize: 12,
      ),
    );
  }
}
